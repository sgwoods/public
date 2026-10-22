"""Render an opted-in external project's small hub page from its manifest."""
import html
from datetime import datetime, timedelta, timezone

from render_index import format_local_datetime, parse_datetime


def render_freshness(payload, observation=None, now=None):
    observation = observation or {}
    state = observation.get("state")
    checked = observation.get("checked_at")
    messages = []
    if checked:
        checked_at = parse_datetime(checked)
        messages.append(
            'Hub last successfully checked: <time datetime="'
            + html.escape(checked, quote=True) + '">'
            + html.escape(format_local_datetime(checked_at)) + ' (America/Toronto)</time>.'
        )
        now = now or datetime.now(timezone.utc)
        if now - checked_at > timedelta(days=8):
            messages.append("This observation is over eight days old; another check is needed.")
    else:
        messages.append("The hub has not yet completed a successful repository check for this page.")

    branch = html.escape(observation.get("branch") or "default")
    source = payload.get("source_commit")
    observed = observation.get("commit")
    commit_text = html.escape((observed or "")[:7])
    if observation.get("commit_url") and observed:
        commit_text = '<a href="' + html.escape(observation["commit_url"], quote=True) + '">' + commit_text + '</a>'

    if state == "check_failed":
        attempted = observation.get("attempted_at")
        when = " at " + html.escape(format_local_datetime(parse_datetime(attempted))) if attempted else ""
        messages.append("The latest repository check failed" + when + "; a current comparison is unavailable.")
        if observed and checked:
            messages.append("The last successful observation retained commit " + commit_text + ".")
    elif state == "not_observed":
        messages.append("No public repository observation is configured.")
    elif not checked or not observed:
        messages.append("The observed branch cannot yet be compared with the published build.")
    elif observation.get("snapshot_commit") != source:
        # An observation belongs to the snapshot it checked, not a later import.
        messages.append("The last check refers to a different snapshot; this published build needs another check.")
    elif state == "dirty_snapshot" or payload.get("source_dirty"):
        messages.append("The snapshot includes uncommitted changes; its commit alone cannot establish a match.")
    elif source and observed == source:
        messages.append("At that check, the observed " + branch + " branch matched the published build (" + commit_text + ").")
    elif state in {"different_commit", "newer_commit", "legacy_unverified"}:
        observed_date = observation.get("commit_date")
        source_date = payload.get("source_commit_at") or observation.get("snapshot_date")
        newer = observed_date and source_date and parse_datetime(observed_date) > parse_datetime(source_date)
        if newer:
            messages.append("A newer commit exists on " + branch + " (" + commit_text + ").")
        elif source:
            messages.append("The observed " + branch + " commit (" + commit_text + ") differs from the published build; its order is not established by this check.")
        else:
            messages.append("The snapshot has no commit identity; a match cannot be established.")
        messages.append("This is a review signal; it does not establish a new published release.")
    else:
        messages.append("A match with the published build has not been established.")

    observed_date = observation.get("commit_date")
    if observed_date and checked:
        messages.append("Observed commit dated " + html.escape(format_local_datetime(parse_datetime(observed_date))) + " (America/Toronto).")
    return '<section class="panel" id="repository-freshness"><h2>Repository freshness</h2>\n' + "\n".join(
        "<p>" + message + "</p>" for message in messages
    ) + '\n<p><a href="index.html#repository-activity">Portfolio repository activity</a> · <a href="data/shared/repository-observations.json">Observation data</a></p>\n</section>'


def render(payload, observation=None, now=None):
    name = html.escape(payload["display_name"])
    repo = payload["repo_url"]
    links = [(payload["experience_url"], "Play the published build"), (repo, "Source repository"),
             (repo + "/blob/main/docs/ARCHITECTURE.md", "Current architecture and features"),
             (repo + "/blob/main/docs/ROADMAP.md", "Roadmap"),
             (payload["dashboard_url"], "Build and test history")]
    buttons = " ".join(f'<a class="button" href="{html.escape(url, quote=True)}">{label}</a>' for url, label in links)
    sha = payload["source_commit"]
    image = f"https://raw.githubusercontent.com/{repo.removeprefix('https://github.com/')}/{sha}/docs/media/arch-gameplay.gif"
    return f'''<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{name} | Steven Woods Projects</title><link rel="stylesheet" href="assets/public-site.css"></head>
<body><main class="shell">
<section class="hero"><span class="eyebrow">Public project</span><h1>{name}</h1>
<p>{html.escape(payload['description'])}</p><div class="links">{buttons}</div></section>
<section class="panel"><h2>Published build</h2>
<p><strong>{html.escape(payload['status_value'])}</strong> · Built {html.escape(payload['source_build_at'])}</p>
<p>{html.escape(payload['focus_value'])}</p>
<img src="{image}" alt="Star Swarm gameplay from the published source documentation" style="max-width:100%;height:auto" loading="lazy">
</section>
{render_freshness(payload, observation, now)}
<section class="panel"><h2>Status and next steps</h2>
<p>Star Swarm is an independent parallel comparison with Aurora, developed using Claude and the Firstmate platform. It is not an Aurora branch or shared release lane. Firstmate is development tooling, not the project being built. Each project keeps its own code, work history, release identity, and roadmap.</p>
<p>The source repository owns the tested feature description and roadmap. This page follows the deployed build identity; newer development is tracked separately on the portfolio homepage.</p>
<div class="links"><a class="button" href="project-suite-overview.html#project-{payload['project_id']}">Portfolio priorities</a>
<a class="button" href="index.html#repository-activity">Repository activity</a>
<a class="button" href="PROJECT-STATUS-CONTRACT.md">Maintaining this status</a></div>
</section></main></body></html>
'''
