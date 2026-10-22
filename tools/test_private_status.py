import copy
import json
import unittest
import tempfile
from pathlib import Path
from unittest.mock import patch

import private_status
import render_index
import check_repository_freshness


class PrivateStatusTests(unittest.TestCase):
    def setUp(self):
        self.path = render_index.DATA_DIR / "financial-planner.json"
        self.payload = json.loads(self.path.read_text())

    def test_summary_has_no_release_source_or_private_links(self):
        private_status.validate(self.payload)
        project = render_index.load_project(self.path)
        self.assertIsNone(project.repo_pushed_at)
        self.assertIsNone(project.source_commit)
        page = private_status.render(self.payload, render_index.format_local_datetime)
        self.assertIn("Not verified; no release claimed", page)
        self.assertIn("63 commits;", page)
        for forbidden in ("github.com/", "source_commit", "commit_url", "Open repository"):
            self.assertNotIn(forbidden, page)
        card = render_index.render_project_card(project)
        self.assertIn("Metadata checked", card)
        self.assertNotIn("Reported snapshot date", card)
        self.assertNotIn("Repository checked", card)

    def test_allowlist_rejects_private_identifiers_and_links(self):
        for level, key, value in [("base", "source_commit", "private-sha"),
                                   ("base", "repo_url", "https://github.com/private/repo"),
                                   ("metadata", "commit_message", "private text"),
                                   ("activity", "commits", [{"sha": "private-sha"}])]:
            with self.subTest(key=key):
                payload = copy.deepcopy(self.payload)
                target = payload if level == "base" else payload["private_metadata"]
                if level == "activity":
                    target = target["activity"]
                target[key] = value
                with self.assertRaises(ValueError):
                    private_status.validate(payload)

    def test_bad_counts_dates_and_unpaired_release_are_rejected(self):
        for count in (-1, True, "3"):
            payload = copy.deepcopy(self.payload)
            payload["private_metadata"]["activity"]["commit_count"] = count
            with self.assertRaises(ValueError):
                private_status.validate(payload)
        payload = copy.deepcopy(self.payload)
        payload["private_metadata"]["release_version"] = "1.0"
        with self.assertRaises(ValueError):
            private_status.validate(payload)
        payload = copy.deepcopy(self.payload)
        payload["private_metadata"]["activity"]["window_end"] = "2099-01-01T00:00:00Z"
        with self.assertRaises(ValueError):
            private_status.validate(payload)

    def test_missing_activity_is_unknown_and_text_is_escaped(self):
        payload = copy.deepcopy(self.payload)
        payload["private_metadata"]["activity"] = None
        payload["description"] = '<script>alert("test")</script>'
        private_status.validate(payload)
        page = private_status.render(payload, render_index.format_local_datetime)
        self.assertIn("Not reported (not zero)", page)
        self.assertIn("&lt;script&gt;", page)
        self.assertNotIn("<script>", page)

    def test_public_observer_never_requests_private_summary_sources(self):
        def get(endpoint):
            self.assertFalse(any(name in endpoint for name in
                                 ("financial-planner", "windigo-portfolio-portal", "woods-financial-dashboard")))
            raise ValueError("Unrelated public check not mocked")
        result = check_repository_freshness.observe(get=get)
        for key in ("confidential-project", "financial-planner", "woods-financial-dashboard"):
            self.assertEqual(result["projects"][key]["state"], "not_observed")
            self.assertNotIn("commit", result["projects"][key])

    def test_even_a_malformed_private_manifest_cannot_trigger_private_observation(self):
        payload = copy.deepcopy(self.payload)
        payload["repo_url"] = "https://github.com/private/private"
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "data/projects").mkdir(parents=True)
            (root / "data/projects/financial-planner.json").write_text(json.dumps(payload))
            with patch.object(check_repository_freshness, "ROOT", root):
                result = check_repository_freshness.observe(get=lambda _: self.fail("Private API was requested"))
            self.assertEqual(result["projects"]["financial-planner"]["state"], "not_observed")


if __name__ == "__main__":
    unittest.main()
