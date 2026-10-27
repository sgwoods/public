#!/usr/bin/env python3
"""Resumable, local-only ASR. Raw audio and unreviewed text never go in public."""
import argparse
from datetime import datetime, timezone
import hashlib
import importlib.metadata
import json
import math
import os
from pathlib import Path
import subprocess
import tempfile
from urllib.parse import urlsplit

PUBLIC_ROOT = Path(__file__).resolve().parents[1]


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def require_private(path, public_root=PUBLIC_ROOT):
    path = path.resolve()
    if path.is_relative_to(public_root.resolve()):
        raise ValueError("Audio/transcript staging must be outside the public checkout, including ignored folders")
    for parent in (path, *path.parents):
        if (parent / ".git").exists():
            visibility = subprocess.check_output(
                ["gh", "repo", "view", "--json", "visibility", "--jq", ".visibility"], cwd=parent, text=True).strip()
            if visibility != "PRIVATE":
                raise ValueError("Git staging repository must be verified PRIVATE")
            break
    return path


def write_json(path, payload):
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    with tempfile.NamedTemporaryFile(mode="w", dir=path.parent, encoding="utf-8", delete=False) as stream:
        json.dump(payload, stream, indent=2, ensure_ascii=True)
        stream.write("\n")
        temporary = Path(stream.name)
    temporary.chmod(0o600)
    temporary.replace(path)


def stamp(seconds, separator="."):
    millis = max(0, round(seconds * 1000))
    hours, rem = divmod(millis, 3600000)
    minutes, rem = divmod(rem, 60000)
    secs, frac = divmod(rem, 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d}{separator}{frac:03d}"


def normalize_segments(segments, offset, keep_start, keep_end, duration):
    result = []
    for segment in segments:
        start, end = float(segment["start"]) + offset, float(segment["end"]) + offset
        if not all(math.isfinite(value) for value in (start, end)) or end < start:
            raise ValueError("Invalid ASR timestamps")
        if not keep_start <= (start + end) / 2 < keep_end:
            continue
        row = dict(start=max(0.0, start), end=min(duration, end), text=str(segment["text"]).strip(),
                   speaker="unknown", speaker_verified=False)
        for name in ("avg_logprob", "compression_ratio", "no_speech_prob"):
            if name in segment:
                value = float(segment[name])
                if not math.isfinite(value):
                    raise ValueError("Invalid ASR quality metric")
                row[name] = value
        row["review_flags"] = [name for name, flagged in (
            ("low_log_probability", row.get("avg_logprob", 0) < -1),
            ("high_compression_ratio", row.get("compression_ratio", 0) > 2.4),
            ("possible_non_speech", row.get("no_speech_prob", 0) > 0.6)) if flagged]
        if row["text"] and row["end"] > row["start"]:
            result.append(row)
    return result


def checkpoint_signature(config):
    return hashlib.sha256(json.dumps(config, sort_keys=True).encode()).hexdigest()


def checked_chunk(path, signature, expected_hash=None):
    if expected_hash and sha256(path) != expected_hash:
        raise ValueError("Private checkpoint checksum differs; do not silently reuse edited ASR")
    data = json.loads(path.read_text())
    if data["signature"] != signature:
        raise ValueError("Checkpoint source/model/options differ; choose a new private run directory")
    return data


def safe_summary(job):
    keys = ("schema_version", "content_id", "state", "started_at", "completed_at", "source_url",
            "source_audio_sha256", "source_audio_bytes", "duration_seconds", "engine", "engine_version",
            "model_id", "model_revision", "model_hashes", "chunk_seconds", "overlap_seconds", "chunks_complete",
            "chunks_expected", "segment_count", "word_count", "flagged_segment_count", "review_required")
    result = {key: job[key] for key in keys if key in job}
    result.update(public_transcript_available=False, speaker_attribution_verified=False,
                  inference="local_only_no_cloud_transcription_api", style_eligible=False)
    return result


def run(args):
    os.umask(0o077)
    os.environ["HF_HUB_OFFLINE"] = "1"
    os.environ["HF_HUB_DISABLE_TELEMETRY"] = "1"
    source = urlsplit(args.source_url)
    if source.scheme != "https" or source.username or source.password or source.query or source.fragment:
        raise ValueError("Use a public HTTPS source URL without credentials, query tokens or fragments")
    if len(args.model_revision) != 40 or any(letter not in "0123456789abcdef" for letter in args.model_revision):
        raise ValueError("Pin the model to a full revision, not a mutable branch name")
    audio, output = require_private(args.input), require_private(args.run_dir)
    model = args.model_dir.resolve()
    if not audio.is_file() or not (model / "config.json").is_file() or not (model / "weights.safetensors").is_file():
        raise ValueError("Existing private audio and pinned local model files are required; nothing is fetched automatically")
    if args.chunk_seconds < 30 or not 0 <= args.overlap_seconds < args.chunk_seconds / 2:
        raise ValueError("Invalid chunk/overlap settings")
    output.mkdir(parents=True, exist_ok=True, mode=0o700)
    output.chmod(0o700)
    probe = json.loads(subprocess.check_output(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "json", str(audio)], text=True))
    duration = float(probe["format"]["duration"])
    if not math.isfinite(duration) or duration <= 0:
        raise ValueError("Audio duration must be positive")
    version = importlib.metadata.version("mlx-whisper")
    config = dict(source_audio_sha256=sha256(audio), source_audio_bytes=audio.stat().st_size,
                  duration_seconds=duration, engine="mlx-whisper", engine_version=version,
                  model_id=args.model_id, model_revision=args.model_revision,
                  model_hashes={name: sha256(model / name) for name in ("config.json", "weights.safetensors")},
                  chunk_seconds=args.chunk_seconds, overlap_seconds=args.overlap_seconds,
                  language="en", task="transcribe", condition_on_previous_text=False,
                  runner_sha256=sha256(Path(__file__)))
    signature = checkpoint_signature(config)
    job_path = output / "job.json"
    if job_path.exists():
        job = checked_chunk(job_path, signature)
    else:
        job = dict(schema_version="1.0", content_id=args.content_id, source_url=args.source_url,
                   signature=signature, state="private_asr_in_progress", started_at=datetime.now(timezone.utc).isoformat(),
                   review_required=["listen_and_correct", "verify_speaker_turns", "check_chunk_boundaries", "review_names_and_dates", "separate_rights_and_publication_approval"],
                   **config)
    if job["content_id"] != args.content_id or job["source_url"] != args.source_url:
        raise ValueError("Checkpoint source identity differs")
    job.setdefault("checkpoint_hashes", {})
    write_json(job_path, job)
    import mlx_whisper
    all_segments = []
    total = math.ceil(duration / args.chunk_seconds)
    for index in range(total):
        keep_start, keep_end = index * args.chunk_seconds, min(duration, (index + 1) * args.chunk_seconds)
        start, end = max(0, keep_start - args.overlap_seconds), min(duration, keep_end + args.overlap_seconds)
        checkpoint = output / f"chunk-{index:03d}.json"
        if checkpoint.exists():
            chunk = checked_chunk(checkpoint, signature, job["checkpoint_hashes"].get(checkpoint.name))
        else:
            wav = output / f"chunk-{index:03d}.wav"
            subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", str(start), "-i", str(audio),
                            "-t", str(end - start), "-ac", "1", "-ar", "16000", str(wav)], check=True)
            result = mlx_whisper.transcribe(str(wav), path_or_hf_repo=str(model), language="en", task="transcribe",
                                           condition_on_previous_text=False, word_timestamps=False, verbose=None)
            chunk = dict(signature=signature, index=index, keep_start=keep_start, keep_end=keep_end,
                         segments=normalize_segments(result["segments"], start, keep_start, keep_end, duration))
            write_json(checkpoint, chunk)
            wav.unlink()
        all_segments.extend(chunk["segments"])
        job["checkpoint_hashes"][checkpoint.name] = sha256(checkpoint)
        job.update(chunks_complete=index + 1, chunks_expected=total, segment_count=len(all_segments),
                   word_count=sum(len(row["text"].split()) for row in all_segments),
                   flagged_segment_count=sum(bool(row["review_flags"]) for row in all_segments))
        write_json(job_path, job)
        print(f"Private ASR checkpoint {index + 1}/{total} saved; no transcript text exported.", flush=True)
    all_segments.sort(key=lambda row: row["start"])
    write_json(output / "transcript.json", dict(state="private_draft_unreviewed", speaker_attribution_verified=False, segments=all_segments))
    with (output / "transcript.txt").open("w") as stream:
        stream.write("UNREVIEWED LOCAL ASR. SPEAKERS UNKNOWN. NOT APPROVED FOR PUBLICATION OR STYLE USE.\n\n")
        for row in all_segments:
            stream.write(f"[{stamp(row['start'])} - {stamp(row['end'])}] speaker_unknown: {row['text']}\n")
    with (output / "transcript.srt").open("w") as stream:
        for index, row in enumerate(all_segments, 1):
            stream.write(f"{index}\n{stamp(row['start'], ',')} --> {stamp(row['end'], ',')}\n{row['text']}\n\n")
    job.update(state="private_draft_unreviewed", completed_at=datetime.now(timezone.utc).isoformat(),
               private_output_hashes={name: sha256(output / name) for name in ("transcript.json", "transcript.txt", "transcript.srt")})
    write_json(job_path, job)
    print("Private draft complete. Listening, speaker verification and publication review remain required.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["run", "summary"])
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--input", type=Path)
    parser.add_argument("--model-dir", type=Path)
    parser.add_argument("--model-id")
    parser.add_argument("--model-revision")
    parser.add_argument("--content-id")
    parser.add_argument("--source-url")
    parser.add_argument("--chunk-seconds", type=int, default=600)
    parser.add_argument("--overlap-seconds", type=int, default=5)
    args = parser.parse_args()
    if args.command == "summary":
        private = require_private(args.run_dir)
        print(json.dumps(safe_summary(json.loads((private / "job.json").read_text())), indent=2))
    else:
        if not all(getattr(args, name) for name in ("input", "model_dir", "model_id", "model_revision", "content_id", "source_url")):
            parser.error("run requires explicit input, local model, pinned model ID/revision and source identity")
        run(args)
