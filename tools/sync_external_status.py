#!/usr/bin/env python3
"""Import explicitly opted-in public Pages build identities, without source writes."""
import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse

from check_repository_freshness import api

ROOT = Path(__file__).resolve().parents[1]


def updated_manifest(payload, identity, commit):
    if identity.get("dirty") is not False or identity.get("mode") != "release":
        raise ValueError("Only clean release build identities may be imported")
    short = identity.get("commit", "")
    if not re.fullmatch(r"[0-9a-f]{7,40}", short) or not commit["sha"].startswith(short):
        raise ValueError("Build commit cannot be verified")
    datetime.fromisoformat(identity["builtAt"].replace("Z", "+00:00"))
    result = dict(payload)
    result.update(source_commit=commit["sha"], source_commit_at=commit["commit"]["committer"]["date"],
                  repo_pushed_at=commit["commit"]["committer"]["date"], source_ref="deployed",
                  source_dirty=False, source_build_at=identity["builtAt"],
                  status_value="Build " + commit["sha"][:7])
    if result != payload:
        result["status_generated_at"] = datetime.now(timezone.utc).isoformat(timespec="seconds")
    return result


def fetch_identity(url):
    # Keep HTTP status separate from the body; only an initial 404 is pending.
    response = subprocess.run(
        ["curl", "--silent", "--show-error", "--location", "--max-time", "20",
         "--write-out", "\n%{http_code}", url], check=True, capture_output=True, text=True)
    body, status = response.stdout.rsplit("\n", 1)
    if status == "404":
        raise FileNotFoundError("Build identity is not served yet")
    if status != "200":
        raise ValueError("Build identity request failed")
    return json.loads(body)


def main(project_ids=None):
    failed = []
    selected = set(project_ids) if project_ids else None
    projects = []
    for path in sorted((ROOT / "data/projects").glob("*.json")):
        payload = json.loads(path.read_text())
        if payload.get("active") and payload.get("status_sync") == "github-pages-build-v1":
            projects.append((path, payload))
    unknown = selected - {payload["project_id"] for _, payload in projects} if selected is not None else set()
    if unknown:
        raise SystemExit("Unknown opted-in projects: " + ", ".join(sorted(unknown)))
    for path, payload in projects:
        if selected is not None and payload["project_id"] not in selected:
            continue
        try:
            parsed = urlparse(payload["repo_url"])
            repo = parsed.path.strip("/")
            if parsed.netloc != "github.com" or not re.fullmatch(r"[\w.-]+/[\w.-]+", repo):
                raise ValueError("Invalid public repository")
            if api(f"repos/{repo}")["private"]:
                raise ValueError("Private repository excluded")
            owner, name = repo.split("/")
            url = f"https://{owner}.github.io/{name}/build.json"
            try:
                identity = fetch_identity(url)
            except FileNotFoundError:
                if payload.get("source_commit") or payload.get("source_build_at"):
                    raise
                print(f"{payload['project_id']}: awaiting first deployment (build.json HTTP 404); no source identity asserted")
                continue
            sha = identity.get("commit", "")
            if not re.fullmatch(r"[0-9a-f]{7,40}", sha):
                raise ValueError("Invalid build identity")
            result = updated_manifest(payload, identity, api(f"repos/{repo}/commits/{sha}"))
            if result != payload:
                path.write_text(json.dumps(result, indent=2) + "\n")
            print(f"{payload['project_id']}: deployed source {result['source_commit'][:7]} verified")
        except Exception as error:
            # Preserve the published manifest and avoid exposing transport error details.
            failed.append(path.name)
            print(f"{path.name}: import failed ({type(error).__name__}); previous snapshot retained")
    if failed:
        raise SystemExit("External imports failed: " + ", ".join(failed))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", action="append", help="Import only this project; repeat to select several")
    main(parser.parse_args().project)
