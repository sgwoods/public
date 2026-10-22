import copy
import json
import tempfile
import unittest
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from types import SimpleNamespace

import working_activity as activity


class WorkingActivityTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        self.root = Path(directory.name)
        (self.root / "data/activity").mkdir(parents=True)
        counts = (10, 43, 24, 1, 14, 5, 3, 30, 36, 33, 23, 22, 17, 26, 36, 20, 23, 25)
        self.report = {
            "schema_version": "1.0", "project_id": "ai-briefing",
            "generated_at": "2026-10-22T18:12:10Z", "checked_at": "2026-10-22T18:12:10Z",
            "timezone": "America/Toronto", "scope": "working-default-branch",
            "report_basis": "hub-assisted-baseline", "uncommitted_work": "not_checked",
            "window_start": "2026-10-05", "window_end": "2026-10-23",
            "days": [{"date": (date(2026, 10, 5) + timedelta(days=index)).isoformat(),
                      "development": 0, "publication": 0, "automation": 0, "unclassified": count}
                     for index, count in enumerate(counts)],
        }
        (self.root / "data/activity/ai-briefing.json").write_text(json.dumps(self.report))
        self.now = datetime(2026, 10, 22, 19, tzinfo=timezone.utc)
        self.projects = [SimpleNamespace(project_id="ai-briefing", display_name="AI Briefing", project_page_href="ai-briefing.html"),
                         SimpleNamespace(project_id="confidential-project", display_name="Rental portal", project_page_href="confidential-project.html"),
                         SimpleNamespace(project_id="financial-planner", display_name="Personal planning", project_page_href="financial-planner.html")]
        self.registry = activity.project_registry(self.projects)

    def test_baseline_is_unclassified_not_development_or_released_work(self):
        activity.validate(self.report, self.registry, self.now)
        self.assertEqual(activity.totals(self.report), {"development": 0, "publication": 0, "automation": 0, "unclassified": 391})
        self.assertEqual(len(self.report["days"]), 18)
        page = activity.render(self.projects, self.root, self.now)
        self.assertIn("391 unclassified", page)
        self.assertIn("Baseline only; source export not yet established", page)
        self.assertIn("Zero classified development", page)
        self.assertIn("Awaiting source report", page)
        self.assertIn("Unknown, not zero", page)

    def test_private_source_fields_are_rejected_at_every_level(self):
        for key in ("source_commit", "repo_url", "branch", "commit_message", "files", "token"):
            for daily in (False, True):
                with self.subTest(key=key, daily=daily):
                    report = copy.deepcopy(self.report)
                    target = report["days"][0] if daily else report
                    target[key] = "must not be published"
                    with self.assertRaises(ValueError):
                        activity.validate(report, self.registry, self.now)

    def test_count_and_coverage_failures_never_become_zero(self):
        for value in (-1, True, "2", None):
            report = copy.deepcopy(self.report)
            report["days"][0]["development"] = value
            with self.assertRaises(ValueError):
                activity.validate(report, self.registry, self.now)
        for mutation in (lambda report: report["days"].pop(),
                         lambda report: report["days"].reverse(),
                         lambda report: report["days"].__setitem__(1, report["days"][0])):
            report = copy.deepcopy(self.report)
            mutation(report)
            with self.assertRaises(ValueError):
                activity.validate(report, self.registry, self.now)

    def test_firstmate_tooling_is_not_a_separate_work_series(self):
        report = copy.deepcopy(self.report)
        report["project_id"] = "firstmate"
        with self.assertRaises(ValueError):
            activity.validate(report, self.registry, self.now)
        self.assertNotIn("firstmate", self.registry)
        self.assertNotIn("Firstmate contributions", activity.render(self.projects, self.root, self.now))

    def test_star_swarm_and_aurora_remain_independent_projects(self):
        projects = self.projects + [
            SimpleNamespace(project_id="star-swarm", display_name="Star Swarm", project_page_href="star-swarm.html"),
            SimpleNamespace(project_id="aurora-galactica", display_name="Aurora", project_page_href="aurora-galactica.html"),
        ]
        registry = activity.project_registry(projects)
        self.assertNotIn("firstmate", registry)
        self.assertNotEqual(registry["star-swarm"]["href"], registry["aurora-galactica"]["href"])
        for key, daily_count in (("star-swarm", 1), ("aurora-galactica", 2)):
            report = copy.deepcopy(self.report)
            report["project_id"] = key
            for row in report["days"]:
                row["unclassified"] = daily_count
            (self.root / f"data/activity/{key}.json").write_text(json.dumps(report))
        reports = activity.load_reports(self.root, registry, self.now)
        self.assertEqual(activity.totals(reports["star-swarm"])["unclassified"], 18)
        self.assertEqual(activity.totals(reports["aurora-galactica"])["unclassified"], 36)
        self.assertEqual(activity.totals(reports["ai-briefing"])["unclassified"], 391)
        page = activity.render(projects, self.root, self.now)
        self.assertIn("independent parallel comparison with Aurora", page)
        self.assertIn("separate histories, releases, and work reports", page)

    def test_owner_export_can_replace_and_classify_a_baseline(self):
        report = copy.deepcopy(self.report)
        report["report_basis"] = "owner-approved-export"
        report["uncommitted_work"] = "present"
        report["days"][0].update(development=6, publication=2, automation=2, unclassified=0)
        activity.validate(report, self.registry, self.now)
        (self.root / "data/activity/ai-briefing.json").write_text(json.dumps(report))
        page = activity.render(self.projects, self.root, self.now)
        self.assertIn("6 classified development; 2 publication; 2 automation; 381 unclassified", page)
        self.assertIn("Owner-approved source export", page)
        self.assertNotIn("Baseline only", page)

    def test_future_naive_or_wrong_zone_reports_fail(self):
        for field, value in [("checked_at", "2099-01-01T00:00:00Z"),
                             ("generated_at", "2026-10-22T18:00:00"),
                             ("timezone", "UTC"), ("window_end", "2026-10-24")]:
            report = copy.deepcopy(self.report)
            report[field] = value
            with self.assertRaises(ValueError):
                activity.validate(report, self.registry, self.now)
        with self.assertRaisesRegex(ValueError, "^Invalid working report timestamp$"):
            activity.timestamp("do not echo this private value")

    def test_report_ages_without_rewriting_its_source_times(self):
        page = activity.render(self.projects, self.root, datetime(2026, 11, 1, tzinfo=timezone.utc))
        self.assertIn("report over eight days old", page)
        self.assertEqual(self.report["checked_at"], "2026-10-22T18:12:10Z")
        self.assertIn("October 22, 2026", page)

    def test_rental_and_personal_finance_have_distinct_missing_rows(self):
        page = activity.render(self.projects, self.root, self.now)
        self.assertIn('href="confidential-project.html">Rental portal', page)
        self.assertIn('href="financial-planner.html">Personal planning', page)
        self.assertEqual(page.count("Awaiting source report"), 2)

    def test_unknown_ids_duplicate_keys_and_mismatched_filenames_fail(self):
        report = copy.deepcopy(self.report)
        report["project_id"] = "kanban-web-migration"
        with self.assertRaises(ValueError):
            activity.validate(report, self.registry, self.now)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "data/activity").mkdir(parents=True)
            path = root / "data/activity/other.json"
            path.write_text(json.dumps(self.report))
            with self.assertRaises(ValueError):
                activity.load_reports(root, self.registry, self.now)
            path.write_text('{"project_id":"hidden", "project_id":"ai-briefing"}')
            with self.assertRaisesRegex(ValueError, "Duplicate JSON field"):
                activity.read_report(path)


if __name__ == "__main__":
    unittest.main()
