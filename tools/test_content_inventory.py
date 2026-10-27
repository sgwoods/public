#!/usr/bin/env python3
"""Offline inventory, privacy, provenance, freshness and source-mapping checks."""
from copy import deepcopy
from datetime import date
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import content_inventory as ci


class InventoryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.run_git("init", "-q")
        self.write("data/publications.bib", "")
        self.policy = dict(schema_version="1.0", source_overrides={}, supplemental_sources=[], approved_public_transcript_paths=[])
        self.write(ci.POLICY, ci.dumps(self.policy))
        self.write("archive/historic/source.html", "<html><body><p>Reviewed source text.</p></body></html>")
        self.write("archive/source-manifest.json", ci.dumps(dict(sources=[dict(
            source_id="src-historical", title="Historical source", source_type="profile", status="approved",
            date={"display": "1996", "sort": "1996-01-01", "precision": "year"},
            urls={"canonical": "https://example.org/history", "archive_local": "historic/source.html", "archive_web": None}
        )])))
        self.write("README.md", "Public repository\n")
        self.commit()

    def run_git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args], stderr=subprocess.STDOUT).decode().strip()

    def write(self, path, text):
        full = self.root / path
        full.parent.mkdir(parents=True, exist_ok=True)
        full.write_text(text)

    def commit(self):
        self.run_git("add", ".")
        self.run_git("-c", "user.name=Inventory Test", "-c", "user.email=test@example.invalid", "commit", "-qm", "fixture")

    def build(self, **kwargs):
        return ci.build(root=self.root, as_of=date(2026, 10, 27), **kwargs)

    def test_all_tracked_paths_and_only_expected_outputs(self):
        self.write("untracked-private.txt", "never inventory this")
        outputs = self.build()
        artifacts = [json.loads(line) for line in outputs[ci.OUTPUTS[1]].splitlines()]
        expected = set(self.run_git("ls-files").splitlines()) | set(ci.OUTPUTS)
        self.assertEqual({item["path"] for item in artifacts}, expected)
        self.assertNotIn("untracked-private.txt", outputs[ci.OUTPUTS[1]])
        catalog = json.loads(outputs[ci.OUTPUTS[0]])
        self.assertEqual(catalog["input_files"], len(expected - set(ci.OUTPUTS)))

    def test_history_is_actual_file_change_not_latest_catalog_commit(self):
        first = self.run_git("rev-parse", "HEAD")
        self.write("new.txt", "another file")
        self.commit()
        metadata = ci.history(self.root)
        self.assertEqual(metadata["README.md"]["revision"], first)
        self.assertEqual(metadata["new.txt"]["revision"], self.run_git("rev-parse", "HEAD"))

    def test_catalog_outputs_do_not_cause_recursive_churn(self):
        first = self.build()
        for name, contents in first.items():
            self.write(name, contents)
        self.commit()
        self.assertEqual(first, self.build())

    def test_bundle_detects_mixed_or_modified_outputs(self):
        for name, contents in self.build().items():
            self.write(name, contents)
        self.assertEqual(ci.verify_bundle(self.root)["schema_version"], "1.0")
        self.write(ci.OUTPUTS[2], '{"sources": []}\n')
        with self.assertRaisesRegex(ValueError, "bundle mismatch"):
            ci.verify_bundle(self.root)

    def test_changed_bytes_fail_or_are_explicit_uncommitted_preview(self):
        self.write("README.md", "changed\n")
        with self.assertRaisesRegex(ValueError, "Commit catalog inputs"):
            self.build()
        preview = self.build(allow_dirty=True)
        self.assertTrue(json.loads(preview[ci.OUTPUTS[0]])["preview_only_uncommitted_inputs"])
        row = next(item for item in map(json.loads, preview[ci.OUTPUTS[1]].splitlines()) if item["path"] == "README.md")
        self.assertIsNone(row["provenance"]["revision"])
        self.assertIsNone(row["provenance"]["committed_at"])

    def test_identical_files_share_content_hash(self):
        self.write("duplicate.md", "Public repository\n")
        self.commit()
        groups = json.loads(self.build()[ci.OUTPUTS[0]])["duplicate_content_groups"]
        self.assertTrue(any(set(group["paths"]) == {"README.md", "duplicate.md"} for group in groups))

    def test_traversal_and_absolute_paths_fail(self):
        for value in ("/tmp/private", "../private", "archive/../../private", "C:\\private"):
            with self.subTest(value=value), self.assertRaises(ValueError):
                ci.safe_local(self.root, value)

    def test_token_urls_are_not_emitted_in_errors(self):
        for url in ("https://example.org/?token=TOPSECRET", "https://user:TOPSECRET@example.org/", "https://stratechery.com/safe-looking"):
            with self.subTest(url=url), self.assertRaises(ValueError) as exc:
                ci.safe_url(url)
            self.assertNotIn("TOPSECRET", str(exc.exception))
        self.assertEqual(ci.safe_url("https://www.youtube.com/watch?v=abcdefghijk"), "https://www.youtube.com/watch?v=abcdefghijk")

    def test_private_tracked_paths_fail_even_if_force_added(self):
        for name in ("private/notes.md", "exports/Shares.csv", "archive/transcripts/unreviewed.md"):
            self.write(name, "private data")
            self.run_git("add", name)
            with self.subTest(name=name), self.assertRaisesRegex(ValueError, "Private/unreviewed"):
                self.build(allow_dirty=True)
            self.run_git("rm", "--cached", name)
            (self.root / name).unlink()

    def test_html_text_excludes_embedded_payloads(self):
        self.write("test.html", "<p>Good text</p><script>PRIVATE_TOKEN</script><style>TRACKER</style><p>More text</p>")
        text = ci.extract_text(self.root / "test.html", "html")
        self.assertIn("Good text", text)
        self.assertNotIn("PRIVATE_TOKEN", text)
        self.assertNotIn("TRACKER", text)

    def test_legacy_srt_is_not_assumed_to_be_a_transcript(self):
        self.assertEqual(ci.classify("class.srt", b"Sorted class roster\n")[0], "text")
        self.assertEqual(ci.classify("captions.srt", b"1\n00:00:01,000 --> 00:00:02,000\nHello\n")[0], "caption_candidate")

    def test_audio_and_pdf_presence_do_not_claim_text(self):
        self.assertEqual(ci.classify("voice.wav", b"RIFF000000WAVE")[1], "transcript_not_inferred")
        self.assertEqual(ci.classify("doc.pdf", b"%PDF-1.5")[1], "requires_local_pdf_extraction")

    def request_source(self, **changes):
        source = dict(content_id="example/source", owner="example", source_type="profile", local_artifacts=["file"],
                      identity_review="not_assessed_for_voice", recordings=[], transcript={"state": "not_catalogued"},
                      freshness={"policy": "historical", "last_successful_external_check": None})
        source.update(changes)
        return source

    def test_historical_source_is_not_age_expired(self):
        source = self.request_source(freshness={"policy": "historical", "last_successful_external_check": "1996-01-01"})
        self.assertEqual(ci.update_requests([source], date(2026, 10, 27))["requests"], [])

    def test_current_profile_review_boundary_and_unknown_check(self):
        source = self.request_source(freshness={"policy": "current_profile", "last_successful_external_check": "2026-10-26", "review_after_days": 30})
        self.assertEqual(ci.update_requests([source], date(2026, 11, 24))["requests"], [])
        requests = ci.update_requests([source], date(2026, 11, 25))["requests"]
        self.assertEqual(requests[0]["reason"], "external_review_due")
        source["freshness"]["last_successful_external_check"] = None
        self.assertEqual(ci.update_requests([source], date(2026, 10, 27))["requests"][0]["reason"], "external_check_unknown")

    def test_event_listing_with_no_recording_produces_discovery_request(self):
        source = self.request_source(source_type="appearance", text_role="event_listing_not_talk_transcript")
        self.assertEqual(ci.update_requests([source], date(2026, 10, 27))["requests"][0]["reason"], "recording_link_gap")

    def test_uncaptured_deferred_sources_are_gaps_but_rejections_are_not_requeued(self):
        source = self.request_source(source_type="media-mention", local_artifacts=[], source_status="deferred")
        self.assertEqual(ci.update_requests([source], date(2026, 10, 27))["requests"][0]["reason"], "local_content_gap")
        source["source_status"] = "rejected"
        self.assertEqual(ci.update_requests([source], date(2026, 10, 27))["requests"], [])

    def test_blocked_identity_and_transcript_requests_are_stable_not_sent(self):
        source = self.request_source(identity_review="needs_identity_verification", recordings=[{"url": "https://example.org/voice"}],
                                     freshness={"policy": "current_profile", "access_state": "blocked", "last_successful_external_check": None})
        one = ci.update_requests([source], date(2026, 10, 27))["requests"]
        two = ci.update_requests([source], date(2026, 10, 28))["requests"]
        self.assertEqual(one, two)
        self.assertEqual({item["reason"] for item in one}, {"identity_unresolved", "public_access_blocked", "transcript_gap"})
        self.assertTrue(all(not item["automatic_fetch"] and not item["changes_release_status"] and item["state"] == "proposed_not_sent" for item in one))

    def test_future_external_check_is_rejected(self):
        self.policy["source_overrides"]["archive/src-historical"] = {"freshness": {"policy": "current_profile", "last_successful_external_check": "2099-01-01"}}
        self.write(ci.POLICY, ci.dumps(self.policy))
        self.commit()
        with self.assertRaisesRegex(ValueError, "future"):
            self.build()

    def test_shallow_history_is_not_a_fake_current_provenance(self):
        with patch.object(ci, "git", return_value=b"true\n"):
            with self.assertRaisesRegex(ValueError, "Full Git history"):
                ci.artifact_inventory(self.root, self.policy)

    def test_unknown_override_is_rejected(self):
        self.policy["source_overrides"]["missing/source"] = {"text_role": "unverified"}
        self.write(ci.POLICY, ci.dumps(self.policy))
        self.commit()
        with self.assertRaisesRegex(ValueError, "Unknown override"):
            self.build()

    def test_ledger_only_captures_are_discoverable_without_promotion(self):
        self.write("steven-woods-research/historic/artifacts/archive-html/support.html", "<p>Supporting source</p>")
        self.write("steven-woods-research/research/media-sources-review.md", "| media-mention | Supporting article | 2001 | https://example.org/support | Pending review | `archive-html/support.html` |\n")
        self.commit()
        records = json.loads(self.build()[ci.OUTPUTS[2]])["sources"]
        record = next(item for item in records if item["content_id"].startswith("ledger:"))
        self.assertEqual(record["source_status"], "review_ledger_only_not_approved")
        self.assertFalse(record["style_eligible"])
        self.assertEqual(record["local_artifacts"], ["steven-woods-research/historic/artifacts/archive-html/support.html"])

    def test_real_source_associations_do_not_use_podcast_domain_fallback(self):
        policy = json.loads((ci.ROOT / ci.POLICY).read_text())
        overrides = policy["source_overrides"]
        riddick = overrides["steven-woods-research/src-steven-2023-riddick-show"]
        self.assertEqual(len(riddick["recordings"]), 1)
        self.assertIn("2023_05_01", riddick["recordings"][0]["url"])
        self.assertNotIn("apple.com", json.dumps(riddick["recordings"]))
        self.assertFalse(policy["approved_public_transcript_paths"])
        self.assertEqual(overrides["steven-woods-research/src-steven-2012-slideshare-keynote-deck"]["identity_review"], "needs_identity_verification")

    def test_schema_definitions_accept_generated_outputs(self):
        import jsonschema
        schema = json.loads((ci.ROOT / "data/content/schema.json").read_text())
        jsonschema.Draft202012Validator.check_schema(schema)
        outputs = self.build()
        for kind, path in (("catalog", ci.OUTPUTS[0]), ("sources", ci.OUTPUTS[2]), ("requests", ci.OUTPUTS[3])):
            validator = jsonschema.Draft202012Validator({**schema, "$ref": "#/$defs/" + kind}, format_checker=jsonschema.FormatChecker())
            validator.validate(json.loads(outputs[path]))
        validator = jsonschema.Draft202012Validator({**schema, "$ref": "#/$defs/artifact"})
        for item in map(json.loads, outputs[ci.OUTPUTS[1]].splitlines()):
            validator.validate(item)


if __name__ == "__main__":
    unittest.main()
