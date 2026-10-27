#!/usr/bin/env python3
"""Regression guards for verified video identity, dates and clip scope."""
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]


class MediaAttributionTests(unittest.TestCase):
    def setUp(self):
        data = json.loads((ROOT / "steven-woods-research/source-manifest.json").read_text())
        self.sources = {row["source_id"]: row for row in data["sources"]}
        self.overrides = json.loads((ROOT / "data/content/curation.json").read_text())["source_overrides"]

    def test_wrong_speaker_is_not_a_steven_recording(self):
        row = self.sources["src-steven-2023-uwaterloo-entrepreneurship-impact"]
        self.assertIsNone(row["urls"]["archive_web"])
        self.assertEqual(self.overrides["steven-woods-research/" + row["source_id"]]["recordings"], [])
        project = json.loads((ROOT / "steven-woods-research/project-manifest.json").read_text())
        self.assertTrue(all("L64GbHRcsFQ" not in item["url"] for item in project["notable_items"]))

    def test_promo_does_not_become_full_keynote(self):
        row = self.sources["src-steven-2023-research-discovery-days-keynote"]
        self.assertEqual(row["date"]["sort"], "2023-04-04")
        self.assertIn("promotional", row["title"])
        self.assertNotIn("November 2", row["date"]["display"])
        recording = self.overrides["steven-woods-research/" + row["source_id"]]["recordings"][0]
        self.assertEqual(recording["duration_seconds"], 176)
        self.assertIn("not_full_keynote", recording["state"])

    def test_joint_talk_event_date_is_not_its_upload_date(self):
        row = self.sources["src-steven-2017-google-waterloo-uw-community"]
        self.assertEqual(row["date"]["sort"], "2017-09-28")
        recording = self.overrides["steven-woods-research/" + row["source_id"]]["recordings"][0]
        self.assertIn("Verna Friesen", recording["other_speakers"])
        self.assertEqual(recording["duration_seconds"], 3243)


if __name__ == "__main__":
    unittest.main()
