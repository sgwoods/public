"""Render deliberately sanitized private-project reports, never private sources."""
import html

from datetime import datetime, timezone


METADATA_KEYS = {"checked_at", "report_basis", "last_default_branch_commit_at",
                 "release_version", "released_at", "activity"}
ACTIVITY_KEYS = {"window_start", "window_end", "commit_count"}
BASE_KEYS = {"schema_version", "project_id", "active", "display_name", "description",
             "project_page_path", "repo_url", "dashboard_url", "experience_url",
             "repo_pushed_at", "status_generated_at", "status_label", "status_value",
             "focus_label", "focus_value", "status_sync", "private_metadata"}
PROJECT_PAGES = {"confidential-project": "confidential-project.html",
                 "financial-planner": "financial-planner.html",
                 "woods-financial-dashboard": "woods-financial-dashboard.html"}


def timestamp(value):
    parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    if parsed.tzinfo is None:
        raise ValueError("Private metadata timestamps need a timezone")
    return parsed.astimezone(timezone.utc)


def validate(payload):
    if payload.get("project_id") not in PROJECT_PAGES or payload.get("project_page_path") != PROJECT_PAGES[payload["project_id"]]:
        raise ValueError("Private summaries require an approved project identity and page")
    if payload.get("schema_version") != "1.0" or type(payload.get("active")) is not bool:
        raise ValueError("Invalid private summary schema or active flag")
    if set(payload) != BASE_KEYS:
        raise ValueError("Private summary must use the documented field allowlist")
    if any(payload.get(key) is not None for key in
           ("repo_url", "dashboard_url", "experience_url", "repo_pushed_at")):
        raise ValueError("Private summaries cannot expose source links or snapshot dates")
    if payload["status_sync"] != "private-summary-v1":
        raise ValueError("Unsupported private summary interface")
    metadata = payload["private_metadata"]
    if set(metadata) != METADATA_KEYS:
        raise ValueError("Private metadata contains undocumented fields")
    if metadata["report_basis"] not in {"Hub-assisted metadata review", "Owner-approved export"}:
        raise ValueError("Private report basis must be explicit")
    checked = timestamp(metadata["checked_at"])
    timestamp(payload["status_generated_at"])
    for key in ("last_default_branch_commit_at", "released_at"):
        if metadata[key] is not None and timestamp(metadata[key]) > checked:
            raise ValueError("Private metadata cannot postdate its check")
    if bool(metadata["release_version"]) != bool(metadata["released_at"]):
        raise ValueError("Private releases need both an approved version and release time")
    activity = metadata["activity"]
    if activity is not None:
        if set(activity) != ACTIVITY_KEYS:
            raise ValueError("Private activity permits only a window and aggregate count")
        if type(activity["commit_count"]) is not int or activity["commit_count"] < 0:
            raise ValueError("Private activity count must be a nonnegative integer")
        if not timestamp(activity["window_start"]) < timestamp(activity["window_end"]) <= checked:
            raise ValueError("Invalid private activity window")


def details(metadata, format_time):
    def date(value):
        return format_time(timestamp(value)) if value else "Not reported"

    release = metadata["release_version"]
    activity = metadata["activity"]
    activity_text = (f'{activity["commit_count"]} commits; {date(activity["window_start"])}'
                     f' to {date(activity["window_end"])}') if activity else "Not reported (not zero)"
    return [
        ("Visibility", "Private code and data; approved summary only"),
        ("Metadata checked", date(metadata["checked_at"])),
        ("Metadata freshness", "Report over eight days old; review needed" if
         (datetime.now(timezone.utc) - timestamp(metadata["checked_at"])).total_seconds() > 8 * 86400 else
         "Recorded metadata check; not a live repository check"),
        ("Report basis", metadata["report_basis"]),
        ("Default-branch commit date", date(metadata["last_default_branch_commit_at"])),
        ("Release", f'{release}; {date(metadata["released_at"])}' if release else "Not verified; no release claimed"),
        ("Reported default-branch activity", activity_text),
        ("Activity scope", "Fixed window; includes merges and all file types; excludes other branches and local edits"),
    ]


def render(payload, format_time):
    validate(payload)
    escape = html.escape
    rows = details(payload["private_metadata"], format_time)
    rows.extend([(payload["status_label"], payload["status_value"]),
                 (payload["focus_label"], payload["focus_value"])])
    body = "".join(f"<div><strong>{escape(label)}</strong> {escape(value)}</div>" for label, value in rows)
    next_step = ("Maintain the approved source-owned status export and verify releases on the owning machine."
                 if payload["private_metadata"]["report_basis"] == "Owner-approved export" else
                 "Establish an approved source-owned summary export and verify releases on the owning machine.")
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{escape(payload["display_name"])}</title>
    <link rel="stylesheet" href="assets/public-site.css">
</head>
<body>
    <main class="shell">
        <section class="hero">
            <div class="heroTop"><span class="eyebrow">Private Project / Public Summary</span>
                <a class="heroHomeLink" href="index.html">Steven Woods</a></div>
            <h1>{escape(payload["display_name"])}</h1>
            <p>{escape(payload["description"])}</p>
        </section>
        <section class="panel" id="summary-freshness">
            <h2>Approved status and freshness</h2>
            <div class="detailList">{body}</div>
            <p>Status summary exported: {escape(format_time(timestamp(payload["status_generated_at"])))}.
            Metadata checks are not release dates. These are fixed-window commit counts, not effort,
            code-only edits, runtime health, or all-branch/local activity. Zero does not mean no work.</p>
            <p>The public hub does not poll this private repository. Reports older than eight days
            need review; compare the recorded check time above, not the homepage render time.</p>
        </section>
        <section class="panel">
            <h2>Privacy and next steps</h2>
            <p>Code, data, deployment addresses, commit identities, messages, filenames, and financial
            details stay private. Only owner-approved, non-confidential aggregate metadata belongs here.</p>
            <p>Next: {escape(next_step)} Do not infer a release from code activity.</p>
            <a class="button" href="project-suite-overview.html">Portfolio priorities</a>
            <a class="button" href="PRIVATE-PROJECT-STATUS.md">Private summary interface</a>
        </section>
    </main>
</body>
</html>
'''
