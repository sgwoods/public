import json
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path
from unittest.mock import patch

import check_repository_freshness as checker
from archive_provenance import content_digest
from sync_external_status import updated_manifest
from render_external_project import render, render_freshness


class ProjectPageFreshnessTests(unittest.TestCase):
    def setUp(self):
        self.now = datetime(2026, 10, 12, 20, tzinfo=timezone.utc)
        self.payload = {"source_commit": "a" * 40, "source_commit_at": "2026-10-11T12:00:00Z"}
        self.observation = {"state": "matches", "branch": "main", "commit": "a" * 40,
                            "snapshot_commit": "a" * 40, "commit_date": "2026-10-11T12:00:00Z",
                            "checked_at": "2026-10-12T19:00:00Z"}

    def test_match_is_tied_to_the_checked_snapshot(self):
        output = render_freshness(self.payload, self.observation, self.now)
        self.assertIn("October 12, 2026 at 3:00 PM", output)
        self.assertIn("At that check, the observed main branch matched the published build", output)
        output = render_freshness(dict(self.payload, source_commit="b" * 40), self.observation, self.now)
        self.assertIn("refers to a different snapshot", output)
        self.assertNotIn("matched the published build", output)

    def test_different_commit_is_newer_only_with_a_later_date(self):
        observation = dict(self.observation, state="different_commit", commit="b" * 40,
                           commit_date="2026-10-12T12:00:00Z")
        output = render_freshness(self.payload, observation, self.now)
        self.assertIn("A newer commit exists on main", output)
        self.assertIn("review signal", output)
        self.assertNotIn("out of date", output)
        observation["commit_date"] = "2026-10-10T12:00:00Z"
        output = render_freshness(self.payload, observation, self.now)
        self.assertIn("differs from the published build", output)
        self.assertNotIn("A newer commit", output)

    def test_failure_reports_retained_observation_without_claiming_a_match(self):
        observation = dict(self.observation, state="check_failed", attempted_at="2026-10-12T20:00:00Z")
        output = render_freshness(self.payload, observation, self.now)
        self.assertIn("latest repository check failed", output)
        self.assertIn("October 12, 2026 at 3:00 PM", output)
        self.assertIn("last successful observation retained commit", output)
        self.assertNotIn("matched the published build", output)

    def test_missing_and_old_checks_are_explicit(self):
        output = render_freshness(self.payload, now=self.now)
        self.assertIn("not yet completed a successful repository check", output)
        self.assertNotIn("October 12", output)
        output = render_freshness(self.payload, dict(self.observation, checked_at="2026-10-03T19:00:00Z"), self.now)
        self.assertIn("over eight days old", output)

    def test_render_preserves_project_labels_and_escapes_observed_fields(self):
        payload = dict(self.payload, display_name="Test", repo_url="https://github.com/example/test",
                       experience_url="https://example.com", dashboard_url="https://example.com/ci",
                       status_value="Release 1.0", source_build_at="2026-10-11T12:01:00Z",
                       description="A project", focus_value="Project focus", project_id="test")
        before = dict(payload)
        output = render(payload, dict(self.observation, branch="<script>alert(1)</script>"), self.now)
        self.assertEqual(payload, before)
        self.assertIn("Release 1.0", output)
        self.assertIn("2026-10-11T12:01:00Z", output)
        self.assertIn("&lt;script&gt;", output)
        self.assertNotIn("<script>alert", output)


class FreshnessTests(unittest.TestCase):
    def test_archive_fingerprint_ignores_only_its_manifest(self):
        entries = [{"path": "archive/source-manifest.json", "mode": "100644", "type": "blob", "sha": "a"},
                   {"path": "archive/project-manifest.json", "mode": "100644", "type": "blob", "sha": "b"}]
        baseline = content_digest(entries, "archive")
        entries[1]["sha"] = "metadata-change"
        self.assertEqual(baseline, content_digest(entries, "archive"))
        entries[0]["sha"] = "source-change"
        self.assertNotEqual(baseline, content_digest(entries, "archive"))
        entries[0]["sha"] = "a"
        entries.append({"path": "archive/new-evidence.txt", "mode": "100644", "type": "blob", "sha": "c"})
        self.assertNotEqual(baseline, content_digest(entries, "archive"))

    def test_deployed_import_rejects_dirty_or_unknown_builds(self):
        commit = {"sha": "a" * 40, "commit": {"committer": {"date": "2026-10-03T00:00:00Z"}}}
        identity = {"commit": "a" * 7, "dirty": False, "mode": "release", "builtAt": "2026-10-03T00:01:00Z"}
        result = updated_manifest({}, identity, commit)
        self.assertEqual(result["source_commit"], commit["sha"])
        self.assertEqual(updated_manifest(result, identity, commit), result)
        for invalid in [dict(identity, dirty=True), dict(identity, mode="dev"), dict(identity, commit="unknown"), dict(identity, commit="b" * 7)]:
            with self.assertRaises(ValueError):
                updated_manifest({}, invalid, commit)

    def test_commit_identity_is_not_a_release_claim(self):
        commit = {"sha": "b", "commit": {"committer": {"date": "2026-09-24T00:00:00Z"}}}
        self.assertEqual(checker.classify({"source_commit": "a"}, commit), "different_commit")
        self.assertEqual(checker.classify({"source_commit": "b"}, commit), "matches")
        self.assertEqual(checker.classify({"source_commit": "b", "source_dirty": True}, commit), "dirty_snapshot")
        self.assertEqual(checker.classify({"repo_pushed_at": "2026-06-11T00:00:00Z"}, commit), "newer_commit")
        self.assertEqual(checker.classify({"repo_pushed_at": "2026-10-01T00:00:00Z"}, commit), "legacy_unverified")

    def test_failed_check_retains_previous_success(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifests = root / "data/projects"
            manifests.mkdir(parents=True)
            (manifests / "test.json").write_text(json.dumps({"project_id": "test", "display_name": "Test",
                "active": True, "repo_url": "https://github.com/example/test", "repo_pushed_at": "2026-06-11T00:00:00Z",
                "status_generated_at": "2026-06-11T00:00:00Z"}))
            previous = {"projects": {"test": {"commit": "old", "checked_at": "2026-06-12T00:00:00Z"}}}
            def fail(endpoint):
                raise ValueError("unavailable")
            with patch.object(checker, "ROOT", root):
                row = checker.observe(previous, fail)["projects"]["test"]
            self.assertEqual(row["state"], "check_failed")
            self.assertEqual(row["commit"], "old")
            self.assertEqual(row["checked_at"], "2026-06-12T00:00:00Z")

    def test_archive_is_path_scoped_and_private_repo_is_not_read(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "data/projects").mkdir(parents=True)
            (root / "archive").mkdir()
            snapshot = {"project_id": "archive", "display_name": "Archive", "active": True,
                "repo_pushed_at": "2026-06-11T00:00:00Z", "status_generated_at": "2026-06-11T00:00:00Z"}
            (root / "archive/project-manifest.json").write_text(json.dumps(snapshot))
            endpoints = []
            def get(endpoint):
                endpoints.append(endpoint)
                if "commits?" not in endpoint:
                    return {"private": False, "default_branch": "main"}
                return [{"sha": "a", "html_url": "https://github.com/sgwoods/public/commit/a",
                    "commit": {"committer": {"date": "2026-06-12T00:00:00Z"}}}]
            with patch.object(checker, "ROOT", root):
                checker.observe(get=get)
            self.assertIn("path=archive", endpoints[-1])
            snapshot["repo_url"] = "https://github.com/example/private"
            (root / "archive/project-manifest.json").write_text(json.dumps(snapshot))
            with patch.object(checker, "ROOT", root):
                row = checker.observe(get=lambda _: {"private": True, "default_branch": "main"})["projects"]["archive"]
            self.assertEqual(row["state"], "check_failed")
            self.assertNotIn("commit", row)


if __name__ == "__main__":
    unittest.main()
