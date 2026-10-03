#!/usr/bin/env python3
"""Deliberately baseline committed archive content; never claim new research."""
import argparse
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path

from archive_provenance import content_digest

ROOT = Path(__file__).resolve().parents[1]


def git(*args):
    return subprocess.check_output(["git", "-C", str(ROOT), *args], text=True).strip()


def snapshot(check=False):
    failures = []
    for path in sorted(ROOT.glob("*/project-manifest.json")):
        data = json.loads(path.read_text())
        if not data.get("active") or data.get("repo_url"):
            continue
        scope = path.parent.name
        pathspec = [scope, f":(exclude){scope}/project-manifest.json"]
        if git("status", "--porcelain", "--", *pathspec):
            raise SystemExit(f"Commit archive content before baselining: {scope}")
        entries = []
        for line in git("ls-tree", "-r", "HEAD", "--", scope).splitlines():
            meta, name = line.split("\t", 1)
            mode, kind, sha = meta.split()
            entries.append(dict(path=name, mode=mode, type=kind, sha=sha))
        digest = content_digest(entries, scope)
        if check:
            if data.get("source_content_sha256") != digest:
                failures.append(scope)
            continue
        commit, date = git("log", "-1", "--format=%H %cI", "HEAD", "--", *pathspec).split()
        metadata = dict(source_commit=commit, source_commit_at=date, repo_pushed_at=date,
                        source_ref=git("rev-parse", "--abbrev-ref", "HEAD"), source_dirty=False, source_scope=scope,
                        source_content_sha256=digest)
        if all(data.get(key) == value for key, value in metadata.items()):
            continue
        metadata["status_generated_at"] = datetime.now(timezone.utc).isoformat(timespec="seconds")
        for output in [path, ROOT / "data/projects" / (data["project_id"] + ".json")]:
            if output.exists():
                payload = json.loads(output.read_text())
                payload.update(metadata)
                output.write_text(json.dumps(payload, indent=2) + "\n")
        print(f"{scope}: {commit[:8]} ({date}); content fingerprint recorded")
    if failures:
        raise SystemExit("Archive snapshots need deliberate review: " + ", ".join(failures))
    if check:
        print("Archive content matches recorded provenance.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    snapshot(parser.parse_args().check)
