#!/usr/bin/env python3
"""Publish authenticated public GitHub commit history for dashboard metrics."""
import json
import re
import subprocess
from datetime import datetime, timedelta, timezone
from urllib.parse import quote, urlencode

import render_index
import render_project_suite_overview as suite
from check_repository_freshness import api

OUTPUT = render_index.ROOT / "data/shared/repository-activity.json"


def api_pages(endpoint):
    result = subprocess.run(["gh", "api", "--paginate", endpoint], check=True,
                            capture_output=True, text=True, timeout=120)
    # Older gh versions emit adjacent JSON documents and do not support --slurp.
    remaining, pages = result.stdout.lstrip(), []
    decoder = json.JSONDecoder()
    while remaining:
        page, offset = decoder.raw_decode(remaining)
        pages.append(page)
        remaining = remaining[offset:].lstrip()
    if not pages:
        raise ValueError("History request returned no JSON")
    return pages


def path_matches(path, scopes, excluded):
    return path not in excluded and any(path == scope or path.startswith(scope.rstrip("/") + "/") for scope in scopes)


def observe(projects, previous=None, get=api, pages=api_pages, now=None):
    now = now or datetime.now(timezone.utc)
    stamp = now.isoformat(timespec="seconds")
    window_start = render_index.current_week_start(now.astimezone(render_index.LOCAL_TZ).date()) - timedelta(weeks=7)
    since = window_start.astimezone(timezone.utc).isoformat()
    previous = previous or {}
    rows, metadata, heads, histories, changes = {}, {}, {}, {}, {}
    for project in projects:
        key, repo = project["project_id"], project["repo"]
        scopes, excluded = project["pathspecs"], project.get("exclude_paths", [])
        old = previous.get("projects", {}).get(key, {})
        same_scope = old.get("repo") == repo and old.get("paths") == scopes and old.get("exclude_paths", []) == excluded
        row = dict(old) if same_scope else {}
        row.update(repo=repo, paths=scopes, exclude_paths=excluded, attempted_at=stamp)
        try:
            if not re.fullmatch(r"[\w.-]+/[\w.-]+", repo):
                raise ValueError("Invalid public repository")
            if repo not in metadata:
                metadata[repo] = get(f"repos/{repo}")
            if metadata[repo]["private"]:
                # A repository changing visibility must not contribute retained public metrics.
                row = {"repo": repo, "paths": scopes, "exclude_paths": excluded, "attempted_at": stamp}
                raise ValueError("Private repository excluded")
            branch = metadata[repo]["default_branch"]
            if repo not in heads:
                heads[repo] = get(f"repos/{repo}/commits/{quote(branch, safe='')}")["sha"]
            head = heads[repo]
            commits = {}
            for scope in scopes or [None]:
                cache_key = (repo, scope)
                if cache_key not in histories:
                    query = {"sha": head, "since": since, "until": stamp, "per_page": 100}
                    if scope:
                        query["path"] = scope
                    history = pages(f"repos/{repo}/commits?{urlencode(query)}")
                    histories[cache_key] = [commit for page in history for commit in page]
                for commit in histories[cache_key]:
                    sha = commit["sha"]
                    date = commit["commit"]["committer"]["date"]
                    if not window_start <= render_index.parse_datetime(date) <= now:
                        continue
                    if scopes:
                        change_key = (repo, sha)
                        if change_key not in changes:
                            details = pages(f"repos/{repo}/commits/{sha}?per_page=100")
                            changes[change_key] = {path for page in details for file in page["files"]
                                                   for path in (file["filename"], file.get("previous_filename")) if path}
                        if not any(path_matches(path, scopes, excluded) for path in changes[change_key]):
                            continue
                    commits[sha] = {"sha": sha, "date": date}
            row.update(branch=branch, branch_commit=head, checked_at=stamp, window_start=since,
                       state="ok", commits=sorted(commits.values(), key=lambda item: (item["date"], item["sha"])))
            row.pop("error", None)
        except (ValueError, KeyError, TypeError, subprocess.SubprocessError):
            row.update(state="check_failed", error="Public history check failed; previous history retained if available")
        rows[key] = row
    return {"schema_version": "1.0", "attempted_at": stamp, "date_basis": "committer",
            "definition": "Reachable public default-branch commits; archive scopes exclude their own project manifest. Includes merges; not a progress or release metric.",
            "projects": rows}


def main():
    coding, archives = render_index.classify_projects(suite.load_projects())
    projects = render_index.build_coding_activity_projects(coding) + render_index.build_research_activity_projects(archives)
    previous = json.loads(OUTPUT.read_text()) if OUTPUT.exists() else {}
    result = observe(projects, previous)
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    failures = sum(row["state"] != "ok" for row in result["projects"].values())
    print(f"Measured {len(projects)} public project histories; {failures} failed checks.")
    if failures:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
