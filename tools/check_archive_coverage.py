#!/usr/bin/env python3
"""Report approved artifact coverage separately from provenance freshness.

Missing captures are a backlog, not a failing release. --check fails only for
declared copies that are missing, outside this repo, untracked or hash-mismatched.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def inventory():
    tracked = set(subprocess.check_output(["git", "-C", str(ROOT), "ls-files", "-z"], text=True).split("\0"))
    rows, errors = [], []
    for manifest in sorted(ROOT.glob("*/source-manifest.json")):
        sources = json.loads(manifest.read_text())["sources"]
        approved = [source for source in sources if source.get("status") == "approved"]
        row = dict(archive=manifest.parent.name, records=len(sources), approved=len(approved),
                   approved_local=0, missing_captures=[])
        for source in approved:
            local = source.get("urls", {}).get("archive_local")
            if not local:
                row["missing_captures"].append(dict(source_id=source["source_id"], url=source["urls"].get("canonical")))
                continue
            path = (manifest.parent / local).resolve()
            if not path.is_relative_to(ROOT) or not path.is_file() or path.relative_to(ROOT).as_posix() not in tracked:
                errors.append(f"{source['source_id']}: declared copy is outside repo, missing or untracked")
                continue
            row["approved_local"] += 1
            sidecar = path.with_suffix(path.suffix + ".capture.json")
            if sidecar.exists():
                metadata = json.loads(sidecar.read_text())
                if hashlib.sha256(path.read_bytes()).hexdigest() != metadata["capture_sha256"]:
                    errors.append(f"{source['source_id']}: capture hash mismatch")
                if sidecar.relative_to(ROOT).as_posix() not in tracked:
                    errors.append(f"{source['source_id']}: provenance sidecar is untracked")
        rows.append(row)
    return dict(archives=rows, errors=errors)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    report = inventory()
    print(json.dumps(report, indent=2))
    if args.check and report["errors"]:
        raise SystemExit(1)
