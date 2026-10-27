#!/usr/bin/env python3
"""Offline privacy, resumability, timestamp and export-boundary checks."""
import json
from pathlib import Path
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

import transcribe_private_audio as asr


class PrivateASRTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def test_public_and_ignored_staging_are_rejected(self):
        public = self.root / "public"
        public.mkdir()
        for name in ("transcript.txt", ".private/raw.json", "private-transcripts/audio.mp3"):
            with self.assertRaisesRegex(ValueError, "outside the public"):
                asr.require_private(public / name, public)

    def test_existing_symlink_into_public_is_rejected(self):
        public = self.root / "public"
        public.mkdir()
        (self.root / "alias").symlink_to(public, target_is_directory=True)
        with self.assertRaises(ValueError):
            asr.require_private(self.root / "alias/draft.txt", public)

    def test_git_outputs_need_private_visibility(self):
        (self.root / ".git").mkdir()
        with patch.object(asr.subprocess, "check_output", return_value="PUBLIC\n"):
            with self.assertRaisesRegex(ValueError, "verified PRIVATE"):
                asr.require_private(self.root / "run", self.root / "elsewhere")
        with patch.object(asr.subprocess, "check_output", return_value="PRIVATE\n"):
            self.assertEqual(asr.require_private(self.root / "run", self.root / "elsewhere"), (self.root / "run").resolve())

    def test_summary_never_exports_text_or_private_paths(self):
        result = asr.safe_summary(dict(state="private_draft_unreviewed", transcript="secret words",
                                      private_output_hashes={"x": "hash"}, input="/private/path", content_id="source"))
        self.assertNotIn("secret", json.dumps(result))
        self.assertNotIn("/private/path", json.dumps(result))
        self.assertFalse(result["public_transcript_available"])
        self.assertFalse(result["speaker_attribution_verified"])
        self.assertFalse(result["style_eligible"])

    def test_resume_rejects_modified_source_model_or_checkpoint(self):
        path = self.root / "chunk.json"
        signature = asr.checkpoint_signature({"audio": "old", "model": "model"})
        asr.write_json(path, dict(signature=signature, segments=[]))
        digest = asr.sha256(path)
        self.assertEqual(asr.checked_chunk(path, signature, digest)["segments"], [])
        with self.assertRaisesRegex(ValueError, "options differ"):
            asr.checked_chunk(path, asr.checkpoint_signature({"audio": "new", "model": "model"}))
        path.write_text(json.dumps(dict(signature=signature, segments=[{"text": "edited"}])))
        with self.assertRaisesRegex(ValueError, "checksum differs"):
            asr.checked_chunk(path, signature, digest)

    def test_atomic_private_metadata_permissions(self):
        path = self.root / "run/job.json"
        asr.write_json(path, {"state": "test"})
        self.assertEqual(path.stat().st_mode & 0o777, 0o600)

    def test_overlap_keeps_one_core_and_does_not_invent_speakers(self):
        segments = [dict(start=0, end=4, text="previous chunk"), dict(start=6, end=10, text="this chunk", avg_logprob=-2)]
        rows = asr.normalize_segments(segments, offset=595, keep_start=600, keep_end=1200, duration=1300)
        self.assertEqual(len(rows), 1)
        self.assertEqual(rows[0]["start"], 601)
        self.assertEqual(rows[0]["speaker"], "unknown")
        self.assertIn("low_log_probability", rows[0]["review_flags"])

    def test_invalid_timestamps_fail(self):
        for start, end in [(float("nan"), 3), (5, 2)]:
            with self.assertRaisesRegex(ValueError, "timestamps"):
                asr.normalize_segments([dict(start=start, end=end, text="x")], 0, 0, 10, 10)

    def test_subtitle_timestamp_rounding(self):
        self.assertEqual(asr.stamp(59.9999, ","), "00:01:00,000")

    def test_local_run_resumes_without_repeating_inference(self):
        audio = self.root / "audio.mp3"
        audio.write_bytes(b"fixture audio")
        model = self.root / "model"
        model.mkdir()
        for name in ("config.json", "weights.safetensors"):
            (model / name).write_bytes(b"fixture model")
        args = SimpleNamespace(input=audio, run_dir=self.root / "run", model_dir=model,
            source_url="https://example.org/episode.mp3", content_id="source", model_id="fixture/model",
            model_revision="a" * 40, chunk_seconds=600, overlap_seconds=5)
        engine = unittest.mock.Mock()
        engine.transcribe.return_value = dict(segments=[dict(start=0, end=3, text="fixture words")])

        def ffmpeg(command, **kwargs):
            Path(command[-1]).write_bytes(b"decoded fixture")

        with patch.object(asr.subprocess, "check_output", return_value='{"format":{"duration":"50"}}'), \
             patch.object(asr.subprocess, "run", side_effect=ffmpeg), \
             patch.object(asr.importlib.metadata, "version", return_value="fixture"), \
             patch.dict("sys.modules", {"mlx_whisper": engine}):
            asr.run(args)
            asr.run(args)
        self.assertEqual(engine.transcribe.call_count, 1)
        result = json.loads((args.run_dir / "transcript.json").read_text())
        self.assertEqual(result["state"], "private_draft_unreviewed")
        self.assertFalse(result["speaker_attribution_verified"])


if __name__ == "__main__":
    unittest.main()
