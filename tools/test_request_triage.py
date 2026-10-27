#!/usr/bin/env python3
"""Request identity, evidence, safety and changing-queue regression checks."""
from copy import deepcopy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

import content_inventory as ci
import triage_content_requests as triage


class TriageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.git("init", "-q")
        path = self.root / "data/content/update-requests.json"
        path.parent.mkdir(parents=True)
        self.signal = dict(request_id="a" * 20, content_id="archive/source", owner="archive", reason="local_content_gap")
        path.write_text(json.dumps(dict(requests=[self.signal])))
        (self.root / "evidence.md").write_text("Public evidence\n")
        self.git("add", ".")
        self.git("-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-qm", "baseline")
        self.entry = dict(**self.signal, title="Source", canonical_url="https://example.org/source", state="resolved",
                          batch_id="completed", decision="Reuse exact preserved copy.", evidence_paths=["evidence.md"],
                          question_ids=[], automatic_fetch=False, changes_release_status=False)
        self.ledger = dict(schema_version="1.0", reviewed_on="2026-10-27", summary="One resolved signal.",
                           baseline=dict(commit=self.git("rev-parse", "HEAD"), requests_sha256=ci.digest(path.read_bytes()), request_count=1),
                           entries=[self.entry], batches=[dict(batch_id="completed", rank=0, title="Completed", value="Reuse", effort="Done", next_action="Retain", stop_gate="No extra claims")],
                           questions=[], outreach_drafts=[])

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], text=True, stderr=subprocess.STDOUT).strip()

    def test_baseline_and_deterministic_report(self):
        triage.validate(self.ledger, self.root)
        report = triage.render(self.ledger)
        self.assertIn("1 signals", report)
        self.assertIn("resolved", report)
        self.assertEqual(report, triage.render(deepcopy(self.ledger)))

    def test_omission_and_duplicate_fail(self):
        self.ledger["entries"] = []
        with self.assertRaisesRegex(ValueError, "every request"):
            triage.validate(self.ledger, self.root)
        self.ledger["entries"] = [self.entry, deepcopy(self.entry)]
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            triage.validate(self.ledger, self.root)

    def test_hash_and_identity_cannot_drift(self):
        self.ledger["baseline"]["requests_sha256"] = "0" * 64
        with self.assertRaisesRegex(ValueError, "hash mismatch"):
            triage.validate(self.ledger, self.root)
        self.ledger["baseline"]["requests_sha256"] = ci.digest((self.root / "data/content/update-requests.json").read_bytes())
        self.entry["reason"] = "different"
        with self.assertRaisesRegex(ValueError, "identity changed"):
            triage.validate(self.ledger, self.root)

    def test_resolution_needs_evidence(self):
        self.entry["evidence_paths"] = []
        with self.assertRaisesRegex(ValueError, "need evidence"):
            triage.validate(self.ledger, self.root)

    def test_evidence_must_be_safe_and_versioned(self):
        (self.root / "untracked.md").write_text("not part of record")
        for name in ["untracked.md", "../outside", "private/secret.md"]:
            self.entry["evidence_paths"] = [name]
            with self.assertRaises(ValueError):
                triage.validate(self.ledger, self.root)

    def test_question_and_batch_references_are_checked(self):
        self.entry["question_ids"] = ["not-known"]
        with self.assertRaisesRegex(ValueError, "question"):
            triage.validate(self.ledger, self.root)
        self.entry["question_ids"] = []
        self.entry["batch_id"] = "not-known"
        with self.assertRaisesRegex(ValueError, "state/batch"):
            triage.validate(self.ledger, self.root)

    def test_no_fetch_or_release_promotion(self):
        for key in ["automatic_fetch", "changes_release_status"]:
            self.entry[key] = True
            with self.assertRaisesRegex(ValueError, "cannot fetch"):
                triage.validate(self.ledger, self.root)
            self.entry[key] = False

    def test_new_signals_and_returned_resolutions_are_not_suppressed(self):
        new = {**self.signal, "request_id": "b" * 20}
        result = triage.compare(self.ledger, dict(evaluated_on="2026-10-27", requests=[self.signal, new]))
        self.assertEqual(result["counts"], dict(reopened_needs_review=1, untriaged=1))
        self.assertEqual(result["active_signal_count"], 2)
        self.assertEqual(result["resolved_baseline_signals_absent"], [])

    def test_absent_resolution_is_not_falsely_reopened(self):
        result = triage.compare(self.ledger, dict(evaluated_on="2026-10-27", requests=[]))
        self.assertEqual(result["active_signal_count"], 0)
        self.assertEqual(result["resolved_baseline_signals_absent"], [self.signal["request_id"]])

    def test_status_rejects_a_register_from_a_different_bundle(self):
        (self.root / triage.LEDGER).write_text(ci.dumps(self.ledger))
        outputs = {ci.OUTPUTS[1]: json.dumps(dict(path=triage.LEDGER, sha256=ci.digest((self.root / triage.LEDGER).read_bytes()))) + "\n",
                   ci.OUTPUTS[2]: '{"sources": []}\n', ci.OUTPUTS[3]: '{"requests": []}\n', ci.OUTPUTS[4]: "Overview\n"}
        for name, value in outputs.items():
            (self.root / name).write_text(value)
        (self.root / ci.OUTPUTS[0]).write_text(ci.dumps(dict(source_tree_sha256="a" * 64,
            outputs_sha256={name: ci.digest(value.encode()) for name, value in outputs.items()})))
        triage.verified_triage_catalog(self.root)
        (self.root / triage.LEDGER).write_text('{"different": true}\n')
        with self.assertRaisesRegex(ValueError, "differs from the verified catalog"):
            triage.verified_triage_catalog(self.root)


if __name__ == "__main__":
    unittest.main()
