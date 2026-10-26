#!/usr/bin/env python3
"""Offline bootstrap regression tests; never install tools or change shell profiles."""
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).with_name("start_codex_on_new_mac.sh")


class BootstrapTests(unittest.TestCase):
    def run_shell(self, body):
        return subprocess.run(
            ["/bin/bash", "-c", f'source "{SCRIPT}"; {body}'],
            text=True, capture_output=True,
        )

    def test_source_does_not_run_main(self):
        result = self.run_shell("printf ready")
        self.assertEqual((result.returncode, result.stdout), (0, "ready"))

    def test_supported_versions(self):
        for version, expected in [("v20.19.0", 1), ("v24.1.0", 0), ("v25.8.2", 0), ("broken", 1)]:
            with self.subTest(version=version):
                result = self.run_shell(f"node() {{ echo '{version}'; }}; node_is_supported")
                self.assertEqual(result.returncode, expected)

    def test_failed_node_is_not_supported(self):
        self.assertNotEqual(self.run_shell("node() { return 1; }; node_is_supported").returncode, 0)

    def test_existing_node_requires_no_brew(self):
        result = self.run_shell("node() { echo v24.1.0; }; brew_bin() { exit 9; }; ensure_node")
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_keg_selection_without_install_or_force_link(self):
        with tempfile.TemporaryDirectory(prefix="node keg ") as directory:
            binary = Path(directory) / "bin" / "node"
            binary.parent.mkdir()
            binary.write_text("#!/bin/bash\necho v24.1.0\n")
            binary.chmod(0o755)
            result = self.run_shell(
                f"brew_bin() {{ echo fake_brew; }}; "
                f"fake_brew() {{ [[ \"$1\" == --prefix ]] || return 9; printf '%s' '{directory}'; }}; "
                "node_is_supported() { [[ $(command -v node) == *'node keg '* ]] && [[ $(node --version) == v24.1.0 ]]; }; "
                "ensure_node; node --version"
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("v24.1.0", result.stdout)

    def test_install_missing_node(self):
        result = self.run_shell(
            "select_installed_node() { [[ ${installed:-no} == yes ]]; }; "
            "brew_bin() { echo fake_brew; }; "
            "fake_brew() { [[ $1 == install && $2 == node@24 ]]; installed=yes; }; ensure_node"
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_failed_install_fails_clearly(self):
        result = self.run_shell(
            "select_installed_node() { return 1; }; brew_bin() { echo fake_brew; }; "
            "fake_brew() { return 0; }; ensure_node"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("still unavailable", result.stderr)

    def test_toolchain_includes_gh_and_node(self):
        result = self.run_shell(
            "ensure_homebrew() { :; }; ensure_brew_package() { echo package:$1:$2; }; "
            "ensure_node() { echo node-selected; }; install_required_toolchain"
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("package:gh:gh", result.stdout)
        self.assertIn("node-selected", result.stdout)

    def test_active_fetch_does_not_depend_on_recovery(self):
        result = self.run_shell('git() { printf "%s\\n" "$*" >&2; }; fetch_public_refs /tmp/checkout main')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("public-recovery", result.stderr)
        self.assertIn("main:refs/remotes/origin/main", result.stderr)


if __name__ == "__main__":
    unittest.main()
