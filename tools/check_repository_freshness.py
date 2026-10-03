#!/usr/bin/env python3
"""Observe public source repositories without changing published release claims."""
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlencode, urlparse

import render_index
from archive_provenance import content_digest

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "data/shared/repository-observations.json"


def api(endpoint):
    result = subprocess.run(["gh", "api", endpoint], check=True, capture_output=True,
                            text=True, timeout=30)
    return json.loads(result.stdout)


def classify(snapshot, commit):
    if snapshot.get("source_dirty"):
        return "dirty_snapshot"
    source = snapshot.get("source_commit")
    if source:
        return "matches" if source == commit["sha"] else "different_commit"
    observed = render_index.parse_datetime(commit["commit"]["committer"]["date"])
    exported = render_index.parse_datetime(snapshot["repo_pushed_at"])
    return "newer_commit" if observed > exported else "legacy_unverified"


def observe(previous=None, get=api):
    previous = previous or {}
    now = datetime.now(timezone.utc).isoformat(timespec="seconds")
    rows = {}
    paths = sorted((ROOT / "data/projects").glob("*.json")) + sorted(ROOT.glob("*/project-manifest.json"))
    snapshots = {}
    for path in paths:
        snapshot = json.loads(path.read_text())
        if not snapshot.get("active"):
            continue
        key = snapshot["project_id"]
        if key not in snapshots or render_index.parse_datetime(snapshot["status_generated_at"]) > render_index.parse_datetime(snapshots[key][0]["status_generated_at"]):
            snapshots[key] = (snapshot, path)
    metadata = {}
    trees = {}
    for key, (snapshot, path) in snapshots.items():
        row = dict(previous.get("projects", {}).get(key, {}))
        row.update(display_name=snapshot["display_name"], attempted_at=now,
                   snapshot_commit=snapshot.get("source_commit"),
                   snapshot_date=snapshot["repo_pushed_at"])
        repo_url = snapshot.get("repo_url")
        archive = ROOT / ("quack" if key == "quack-com" else key)
        if not repo_url and not (archive / "project-manifest.json").exists():
            rows[key] = {"display_name": snapshot["display_name"], "state": "not_observed",
                         "attempted_at": now, "reason": "No public repository configured"}
            continue
        try:
            if repo_url:
                parsed = urlparse(repo_url)
                if parsed.netloc != "github.com" or len(parsed.path.strip("/").split("/")) != 2:
                    raise ValueError("Unsupported repository URL")
                repo = parsed.path.strip("/").removesuffix(".git")
                scope = None
            else:
                repo, scope = "sgwoods/public", archive.name
            if repo not in metadata:
                metadata[repo] = get(f"repos/{repo}")
            if metadata[repo]["private"]:
                raise ValueError("Private repository is excluded from public observation")
            branch = metadata[repo]["default_branch"]
            query = {"sha": branch, "per_page": 1}
            if scope:
                query["path"] = scope
            commits = get(f"repos/{repo}/commits?{urlencode(query)}")
            if not commits:
                raise ValueError("No commits for configured scope")
            commit = commits[0]
            state = classify(snapshot, commit)
            if scope and snapshot.get("source_content_sha256"):
                if repo not in trees:
                    tree = get(f"repos/{repo}/git/trees/{branch}?recursive=1")
                    if tree.get("truncated"):
                        raise ValueError("Incomplete archive tree")
                    trees[repo] = tree["tree"]
                state = "content_matches" if content_digest(trees[repo], scope) == snapshot["source_content_sha256"] else "content_changed"
            row.update(repo=repo, branch=branch, path=scope, checked_at=now,
                       commit=commit["sha"], commit_date=commit["commit"]["committer"]["date"],
                       commit_url=commit["html_url"], state=state)
            row.pop("error", None)
        except (ValueError, KeyError, subprocess.SubprocessError):
            # Keep the last successful observation; never expose API stderr or credentials.
            row.update(state="check_failed", error="Repository check failed; last successful observation retained if available")
        rows[key] = row
    return {"schema_version": "1.0", "attempted_at": now, "projects": rows}


def main():
    previous = json.loads(OUTPUT.read_text()) if OUTPUT.exists() else {}
    result = observe(previous)
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    failures = sum(row["state"] == "check_failed" for row in result["projects"].values())
    print(f"Observed {len(result['projects'])} project scopes; {failures} failed checks.")
    if failures:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
