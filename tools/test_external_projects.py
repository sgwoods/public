"""Offline presentation, deployment-import and integration regression checks."""
from copy import deepcopy
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import refresh_public_coordination as refresh
import render_external_project as renderer
import sync_external_status as sync


NOW = datetime(2026, 10, 12, tzinfo=timezone.utc)
STAR = dict(project_id="star-swarm", display_name="Star Swarm", repo_url="https://github.com/sgwoods/star-swarm",
            experience_url="https://sgwoods.github.io/star-swarm/",
            dashboard_url="https://github.com/sgwoods/star-swarm/actions/workflows/ci.yml",
            source_commit="a" * 40, source_commit_at="2026-10-11T12:00:00Z",
            source_build_at="2026-10-11T12:01:00Z", status_value="Build aaaaaaa",
            description="A published game.", focus_value="Independent game development")


class ExternalPageTests(unittest.TestCase):
    def setUp(self):
        self.notes = json.loads((refresh.ROOT / "data/shared/project-suite-overview.json").read_text())

    def test_star_swarm_legacy_bytes_at_a_fixed_clock(self):
        page = renderer.render(STAR, now=NOW, presentation=self.notes["projects"]["star-swarm"]["external_page"])
        # Captured from the pre-refactor renderer on origin/main, not the new template.
        self.assertEqual(hashlib.sha256(page.encode()).hexdigest(),
                         "44fc109c6553807aab77436e5bb1d2695e9107faf3076f187eb2bc19b220da42")

    def test_bookshelf_has_its_own_presentation_and_no_image_or_game_narrative(self):
        payload = dict(STAR, project_id="virtual-bookshelf", display_name="Virtual Bookshelf",
                       description="Books", focus_value="Review the catalogue", source_commit=None,
                       source_build_at=None, status_value="Awaiting first deployment")
        presentation = self.notes["projects"]["virtual-bookshelf"]["external_page"]
        before = deepcopy((payload, presentation))
        page = renderer.render(payload, {"state": "awaiting_deployment", "checked_at": "2026-10-12T00:00:00Z",
                                        "commit": "b" * 40}, NOW, presentation=presentation)
        self.assertIn("Browse the bookshelf", page)
        self.assertIn("docs/ARCHITECTURE.md", page)
        self.assertNotIn(">Current architecture and features</a>", page)
        self.assertNotIn(">Build and test history</a>", page)
        self.assertIn('id="repository-freshness"', page)
        self.assertIn("Awaiting the first verified clean release deployment", page)
        for unwanted in ("<img", "Star Swarm", "Aurora", "Firstmate", "Play the published build", "Built None", "1970"):
            self.assertNotIn(unwanted, page)
        self.assertEqual((payload, presentation), before)

    def test_presentation_text_is_escaped_and_image_path_is_relative(self):
        presentation = dict(experience_label="<Browse>", paragraphs=["<script>unsafe</script>"],
                            image={"path": "docs/image.gif", "alt": '" onerror="unsafe'})
        page = renderer.render(STAR, now=NOW, presentation=presentation)
        self.assertIn("&lt;Browse&gt;", page)
        self.assertIn("&lt;script&gt;", page)
        self.assertNotIn('alt="" onerror=', page)
        for path in ("../private.gif", "/absolute.gif", "https://elsewhere/image.gif", "..\\private.gif"):
            with self.subTest(path=path), self.assertRaises(ValueError):
                renderer.render(STAR, now=NOW, presentation=dict(presentation, image={"path": path, "alt": "Test"}))

    def test_both_projects_are_wired_from_suite_notes_without_mutation(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory).resolve()
            (root / "data/projects").mkdir(parents=True)
            payloads = [dict(STAR, active=True, status_sync="github-pages-build-v1", project_page_path="star-swarm.html"),
                        dict(STAR, project_id="virtual-bookshelf", display_name="Virtual Bookshelf", active=True,
                             status_sync="github-pages-build-v1", project_page_path="virtual-bookshelf.html")]
            for payload in payloads:
                (root / "data/projects" / (payload["project_id"] + ".json")).write_text(json.dumps(payload))
            before = deepcopy(self.notes)
            with patch.object(refresh, "ROOT", root), patch.object(refresh.render_index, "render", return_value=""), \
                    patch.object(refresh.render_project_suite_overview, "render_html", return_value=""), \
                    patch.object(refresh.render_project_suite_overview, "render_markdown", return_value=""):
                outputs = {row.path.name: row.contents for row in refresh.build_outputs(self.notes, [])}
            self.assertIn("Play the published build", outputs["star-swarm.html"])
            self.assertIn("Browse the bookshelf", outputs["virtual-bookshelf.html"])
            self.assertNotIn("<img", outputs["virtual-bookshelf.html"])
            self.assertEqual(self.notes, before)


class ExternalImportTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        (self.root / "data/projects").mkdir(parents=True)
        for key in ("star-swarm", "virtual-bookshelf", "exporter"):
            payload = dict(project_id=key, active=True, repo_url=f"https://github.com/sgwoods/{key}",
                           source_commit=None, repo_pushed_at=None, source_build_at=None)
            if key != "exporter":
                payload["status_sync"] = "github-pages-build-v1"
            (self.root / "data/projects" / (key + ".json")).write_text(json.dumps(payload, indent=2) + "\n")
        self.identity = dict(commit="a" * 7, dirty=False, mode="release", builtAt="2026-10-11T12:01:00Z")
        self.endpoints = []

    def api(self, endpoint):
        self.endpoints.append(endpoint)
        if "/commits/" in endpoint:
            return {"sha": "a" * 40, "commit": {"committer": {"date": "2026-10-11T12:00:00Z"}}}
        return {"private": False}

    def read(self, key):
        return (self.root / "data/projects" / (key + ".json")).read_bytes()

    def run_import(self, selected=None, effect=None):
        with patch.object(sync, "ROOT", self.root), patch.object(sync, "api", side_effect=self.api), \
                patch.object(sync, "fetch_identity", side_effect=effect, return_value=self.identity):
            sync.main(selected)

    def test_two_opted_in_imports_are_idempotent_and_skip_exporters(self):
        exporter = self.read("exporter")
        self.run_import()
        first = [self.read(key) for key in ("star-swarm", "virtual-bookshelf")]
        self.run_import()
        self.assertEqual(first, [self.read(key) for key in ("star-swarm", "virtual-bookshelf")])
        self.assertEqual(self.read("exporter"), exporter)
        self.assertFalse(any("exporter" in endpoint for endpoint in self.endpoints))

    def test_selected_import_never_observes_or_writes_another_manifest(self):
        before = self.read("star-swarm")
        self.run_import(["virtual-bookshelf"])
        self.assertEqual(self.read("star-swarm"), before)
        self.assertTrue(all("virtual-bookshelf" in endpoint for endpoint in self.endpoints))
        with self.assertRaises(SystemExit):
            self.run_import(["misspelling"])

    def test_all_selections_are_preflighted_before_any_fetch_or_write(self):
        before = self.read("star-swarm")
        with self.assertRaises(SystemExit):
            self.run_import(["star-swarm", "virtual-bookshelff"])
        self.assertEqual(self.read("star-swarm"), before)
        self.assertEqual(self.endpoints, [])

    def test_initial_404_is_pending_but_a_lost_published_build_fails_and_retains_bytes(self):
        before = self.read("virtual-bookshelf")
        self.run_import(["virtual-bookshelf"], FileNotFoundError())
        self.assertEqual(self.read("virtual-bookshelf"), before)
        self.run_import(["virtual-bookshelf"])
        before = self.read("virtual-bookshelf")
        with self.assertRaises(SystemExit):
            self.run_import(["virtual-bookshelf"], FileNotFoundError())
        self.assertEqual(self.read("virtual-bookshelf"), before)

    def test_failed_transport_and_invalid_release_do_not_become_pending_or_advance_source(self):
        before = self.read("virtual-bookshelf")
        with self.assertRaises(SystemExit):
            self.run_import(["virtual-bookshelf"], ValueError("Unavailable"))
        self.identity["dirty"] = True
        with self.assertRaises(SystemExit):
            self.run_import(["virtual-bookshelf"])
        self.assertEqual(self.read("virtual-bookshelf"), before)

    def test_fetch_distinguishes_404_and_other_http_or_transport_errors(self):
        for code, error in (("404", FileNotFoundError), ("500", ValueError), ("403", ValueError)):
            with self.subTest(code=code), patch.object(sync.subprocess, "run", return_value=type("Response", (), {"stdout": "{}\n" + code})), \
                    self.assertRaises(error):
                sync.fetch_identity("https://example.org/build.json")
        with patch.object(sync.subprocess, "run", side_effect=subprocess.CalledProcessError(6, "curl")), \
                self.assertRaises(subprocess.CalledProcessError):
            sync.fetch_identity("https://example.org/build.json")


if __name__ == "__main__":
    unittest.main()
