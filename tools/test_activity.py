import json
import subprocess
import unittest
from datetime import date, datetime, timedelta, timezone
from types import SimpleNamespace
from unittest.mock import patch

import observe_activity as collector
import render_index as renderer


class ActivityTests(unittest.TestCase):
    def test_pagination_works_without_newer_gh_slurp_flag(self):
        result = SimpleNamespace(stdout='[{"sha":"a"}]\n[{"sha":"b"}]\n')
        with patch.object(collector.subprocess, "run", return_value=result) as run:
            self.assertEqual(collector.api_pages("repos/example/code/commits"), [[{"sha": "a"}], [{"sha": "b"}]])
            self.assertNotIn("--slurp", run.call_args.args[0])

    def setUp(self):
        self.now = datetime(2026, 10, 22, 18, tzinfo=timezone.utc)
        self.project = {"project_id": "archive", "repo": "example/public", "label": "Archive",
                        "pathspecs": ["archive", "archive.html"], "exclude_paths": ["archive/project-manifest.json"],
                        "color_top": "red", "color_bottom": "blue"}

    def test_paginated_overlapping_history_is_deduped_and_metadata_is_excluded(self):
        calls = []
        def get(endpoint):
            calls.append(endpoint)
            return {"private": False, "default_branch": "trunk"} if endpoint == "repos/example/public" else {"sha": "head"}
        def commit(sha):
            return {"sha": sha, "commit": {"committer": {"date": "2026-10-22T01:00:00Z"},
                                          "author": {"date": "2020-01-01T00:00:00Z"}}}
        def pages(endpoint):
            calls.append(endpoint)
            if "/commits?" in endpoint:
                return [[commit("metadata")], [commit("content"), commit("content")]]
            if "/commits/metadata?" in endpoint:
                return [{"files": [{"filename": "archive/project-manifest.json"}, {"filename": "index.html"}]}]
            return [{"files": [{"filename": "archive/evidence.txt"}]}]
        result = collector.observe([self.project], get=get, pages=pages, now=self.now)
        row = result["projects"]["archive"]
        self.assertEqual(row["branch"], "trunk")
        self.assertEqual(row["branch_commit"], "head")
        self.assertEqual(row["commits"], [{"sha": "content", "date": "2026-10-22T01:00:00Z"}])
        self.assertTrue(any("sha=head" in call for call in calls))
        start = renderer.current_day_start(date(2026, 10, 21))
        self.assertEqual(renderer.activity_count(result, self.project, start, start + timedelta(days=1)), 1)

    def test_failure_retains_evidence_but_never_becomes_zero(self):
        previous = {"projects": {"archive": {"repo": self.project["repo"], "paths": self.project["pathspecs"],
            "exclude_paths": self.project["exclude_paths"], "checked_at": "2026-10-21T18:00:00Z",
            "commits": [{"sha": "old", "date": "2026-10-21T12:00:00Z"}], "state": "ok"}}}
        def fail(_):
            raise subprocess.CalledProcessError(1, "gh")
        result = collector.observe([self.project], previous, get=fail, now=self.now)
        row = result["projects"]["archive"]
        self.assertEqual(row["state"], "check_failed")
        self.assertEqual(row["commits"][0]["sha"], "old")
        self.assertEqual(row["checked_at"], "2026-10-21T18:00:00Z")
        self.assertIsNone(renderer.activity_count(result, self.project, self.now - timedelta(days=1), self.now))
        self.assertIsNone(renderer.activity_count({}, self.project, self.now - timedelta(days=1), self.now))
        self.assertIsNone(renderer.ActivityBucket(self.now, self.now, "Today", {"archive": None}).total)

    def test_private_history_is_never_requested_or_retained(self):
        calls = []
        def get(endpoint):
            calls.append(endpoint)
            return {"private": True, "default_branch": "main"}
        old = {"projects": {"archive": {"repo": self.project["repo"], "paths": self.project["pathspecs"],
            "exclude_paths": self.project["exclude_paths"], "commits": [{"sha": "old"}], "checked_at": "2026-10-21T12:00:00Z"}}}
        result = collector.observe([self.project], old, get=get, pages=lambda _: self.fail("Private history requested"), now=self.now)
        self.assertEqual(calls, ["repos/example/public"])
        self.assertNotIn("commits", result["projects"]["archive"])
        coding = renderer.build_coding_activity_projects([
            SimpleNamespace(project_id="private", display_name="Private summary", repo_url=None),
            SimpleNamespace(project_id="public", display_name="Public code", repo_url="https://github.com/example/code"),
        ])
        self.assertEqual([item["project_id"] for item in coding], ["public"])

    def test_dst_day_and_half_open_boundaries(self):
        start = renderer.current_day_start(date(2026, 11, 1))
        end = start + timedelta(days=1)
        self.assertEqual((end.astimezone(timezone.utc) - start.astimezone(timezone.utc)).total_seconds(), 25 * 3600)
        snapshot = {"projects": {"archive": {"state": "ok", "repo": self.project["repo"], "paths": self.project["pathspecs"],
            "exclude_paths": self.project["exclude_paths"], "window_start": "2026-10-01T00:00:00Z",
            "checked_at": "2026-11-03T00:00:00Z", "commits": [
                {"sha": "inside", "date": "2026-11-02T04:30:00Z"}, {"sha": "next-day", "date": "2026-11-02T05:00:00Z"}]}}}
        self.assertEqual(renderer.activity_count(snapshot, self.project, start, end), 1)
        snapshot["projects"]["archive"]["window_start"] = end.isoformat()
        self.assertIsNone(renderer.activity_count(snapshot, self.project, start, end))

    def test_archive_url_becomes_a_git_path_and_unknown_is_rendered_explicitly(self):
        project = SimpleNamespace(project_id="archive", display_name="Archive", project_page_href="https://sgwoods.github.io/public/archive.html")
        with patch.object(renderer, "research_manifest_folder_by_id", return_value={"archive": "archive"}):
            spec = renderer.build_research_activity_projects([project])[0]
        self.assertEqual(spec["pathspecs"], ["archive.html"] if not (renderer.ROOT / "archive").exists() else ["archive", "archive.html"])
        self.assertEqual(spec["exclude_paths"], ["archive/project-manifest.json"])
        bucket = renderer.ActivityBucket(self.now, self.now + timedelta(days=1), "Today", {"archive": None})
        with patch.object(renderer, "load_activity_snapshot", return_value={}):
            output = renderer.render_activity_chart(chart_id="test", title="Test", lead="History", projects=[spec], metric_label="commits", buckets=[bucket], bucket_mode="daily")
        self.assertIn("Unavailable</span>", output)
        self.assertIn("data-activity-total>N/A", output)
        self.assertIn("Not yet measured", output)


if __name__ == "__main__":
    unittest.main()
