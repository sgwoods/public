import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import check_repository_freshness as checker


class FreshnessTests(unittest.TestCase):
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
