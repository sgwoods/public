#!/usr/bin/env python3
"""Offline source-registry provenance and landing-page regression tests."""
from copy import deepcopy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

import render_person_content as person


class PersonContentTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.git("init", "-q")
        self.payload = dict(schema_version="1.0", project_id="steven-woods-research", sources=[
            dict(source_id="one", status="approved", urls={"archive_local": "capture.html"}),
            dict(source_id="two", status="approved", urls={}),
            dict(source_id="three", status="candidate", urls={})])
        self.write(person.MANIFEST, json.dumps(self.payload))
        self.write("steven-woods-research/capture.html", "<p>Public capture</p>")
        self.write(person.SUMMARY, "<!-- source-registry-date:start -->old<!-- source-registry-date:end -->\n"
                   "<!-- content-inventory:start -->old<!-- content-inventory:end -->\n")
        self.commit()
        self.first = self.git("rev-parse", "HEAD")

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], stderr=subprocess.STDOUT, text=True).strip()

    def write(self, name, content):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)

    def commit(self):
        self.git("add", ".")
        self.git("-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-qm", "fixture")

    def test_resolves_actual_content_commit_and_date(self):
        meta = person.metadata(self.root, self.payload)
        self.assertEqual(meta["content_commit"], self.first)
        self.assertEqual(meta["content_updated_at"], self.git("show", "-s", "--format=%cI", self.first))
        self.assertEqual(len(meta["content_sha256"]), 64)

    def test_metadata_and_formatting_do_not_advance_content(self):
        expected = person.metadata(self.root, self.payload)
        changed = deepcopy(self.payload)
        changed["metadata"] = expected
        self.write(person.MANIFEST, json.dumps(changed, indent=4))
        self.commit()
        self.assertEqual(person.metadata(self.root, changed), expected)

    def test_uncommitted_semantic_change_fails(self):
        self.payload["sources"][0]["status"] = "rejected"
        with self.assertRaisesRegex(ValueError, "Commit source registry"):
            person.metadata(self.root, self.payload)

    def test_new_content_gets_its_own_commit(self):
        self.payload["sources"][0]["status"] = "rejected"
        self.write(person.MANIFEST, json.dumps(self.payload))
        self.commit()
        self.assertEqual(person.metadata(self.root, self.payload)["content_commit"], self.git("rev-parse", "HEAD"))

    def test_outputs_are_idempotent_and_counts_derived(self):
        changes = person.outputs(self.root)
        self.assertIn("1 of 2 approved sources", changes[person.SUMMARY])
        self.assertIn("not a fresh check", changes[person.SUMMARY])
        self.assertIn("Other machines consume", changes[person.SUMMARY])
        self.assertIn("No unreviewed transcript or LinkedIn export", changes[person.SUMMARY])
        for name, content in changes.items():
            self.write(name, content)
        self.commit()
        self.assertEqual(person.outputs(self.root), {})

    def test_missing_capture_and_marker_fail(self):
        self.payload["metadata"] = person.metadata(self.root, self.payload)
        (self.root / "steven-woods-research/capture.html").unlink()
        with self.assertRaisesRegex(ValueError, "capture is missing"):
            person.render_summary(self.root, self.payload)
        with self.assertRaisesRegex(ValueError, "exactly one"):
            person.replace_region("no marker", "missing", "new")

    def test_shallow_history_fails(self):
        (self.root / ".git/shallow").write_text(self.first + "\n")
        with self.assertRaisesRegex(ValueError, "Full history"):
            person.metadata(self.root, self.payload)


if __name__ == "__main__":
    unittest.main()
