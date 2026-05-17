#!/usr/bin/env python3
"""Render a repo-owned project-suite overview for portfolio coordination."""

from __future__ import annotations

import html
import json
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any

import render_index


ROOT = render_index.ROOT
NOTES_PATH = ROOT / "data" / "shared" / "project-suite-overview.json"
HTML_OUTPUT = ROOT / "project-suite-overview.html"
MARKDOWN_OUTPUT = ROOT / "PROJECT-SUITE-OVERVIEW.md"


def load_notes() -> dict[str, Any]:
    return json.loads(NOTES_PATH.read_text())


def load_projects() -> list[render_index.ProjectStatus]:
    projects = sorted(
        [render_index.load_project(path) for path in sorted(render_index.DATA_DIR.glob("*.json"))]
        + [render_index.load_project(path) for path in sorted(ROOT.glob("*/project-manifest.json"))],
        key=render_index.sort_key,
    )
    projects = [project for project in projects if project.active]
    projects = render_index.dedupe_projects(projects)
    projects.sort(key=render_index.sort_key)
    return projects


def git_branch() -> str | None:
    result = subprocess.run(
        ["git", "branch", "--show-current"],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    branch = result.stdout.strip()
    return branch or None


def priority_lookup(notes: dict[str, Any]) -> dict[str, dict[str, str]]:
    return {entry["id"]: entry for entry in notes["priority_bands"]}


def project_source_counts(project_id: str) -> dict[str, int] | None:
    source_manifest_path = ROOT / project_id / "source-manifest.json"
    if source_manifest_path.exists():
        payload = json.loads(source_manifest_path.read_text())
        sources = payload.get("sources", [])
        return {
            "total": len(sources),
            "approved": len([source for source in sources if source.get("status") == "approved"]),
            "deferred": len([source for source in sources if source.get("status") == "deferred"]),
            "rejected": len([source for source in sources if source.get("status") == "rejected"]),
        }

    if project_id == "ai-dystopia-quotes":
        approved_path = ROOT / "data" / "ai-dystopia-quotes.approved.json"
        payload = json.loads(approved_path.read_text())
        records = payload.get("records", [])
        return {
            "total": len(records),
            "approved": len(records),
            "deferred": 0,
            "rejected": 0,
        }

    return None


def project_links(project: render_index.ProjectStatus, note: dict[str, Any]) -> list[dict[str, str]]:
    links: list[dict[str, str]] = [
        {"label": "Project page", "url": project.project_page_href},
    ]
    if project.dashboard_url:
        links.append({"label": "Dashboard", "url": project.dashboard_url})
    if project.experience_url:
        links.append({"label": "Live experience", "url": project.experience_url})
    if project.repo_url:
        links.append({"label": "Repository", "url": project.repo_url})
    links.extend(note.get("extra_links", []))
    return links


def format_visibility(note: dict[str, Any]) -> str:
    return note["visibility"]


def format_surface_class(note: dict[str, Any]) -> str:
    return note["surface_class"]


def status_summary(project: render_index.ProjectStatus) -> str:
    return (
        f"{project.status_label}: {project.status_value}. "
        f"{project.focus_label}: {project.focus_value}. "
        f"Last repo update: {render_index.format_local_date(project.repo_pushed_at)}."
    )


def evidence_summary(project_id: str) -> str | None:
    counts = project_source_counts(project_id)
    if not counts:
        return None
    if project_id == "ai-dystopia-quotes":
        return f"Approved corpus: {counts['approved']} entries."
    if counts["total"] == 0:
        return "Evidence baseline: no formal source records yet."
    return (
        "Evidence baseline: "
        f"{counts['approved']} approved / {counts['deferred']} deferred / "
        f"{counts['rejected']} rejected ({counts['total']} total)."
    )


def project_description(project: render_index.ProjectStatus) -> str:
    return project.description or "Public project page synced from its published repository or archive status manifest."


def markdown_link(label: str, url: str) -> str:
    return f"[{label}]({url})"


def html_link(label: str, url: str) -> str:
    return f'<a class="button button--ghost" href="{html.escape(url)}">{html.escape(label)}</a>'


def render_markdown(notes: dict[str, Any], projects: list[render_index.ProjectStatus]) -> str:
    priority_map = priority_lookup(notes)
    project_notes = notes["projects"]
    branch = git_branch()
    priority_counts = Counter(project_notes[project.project_id]["priority_now"] for project in projects)

    lines: list[str] = [
        "# Project Suite Overview",
        "",
        f"Updated: `{notes['updated_at']}`",
        "",
        notes["summary"],
        "",
        "This overview tracks the current repo coordination state in this checkout.",
        "Per-project manifests remain the factual status layer; this overview is the portfolio judgment layer.",
    ]
    if branch:
        lines.extend(["", f"Current branch snapshot: `{branch}`"])

    lines.extend(["", "## What This Page Is For", ""])
    for item in notes["use_this_page_for"]:
        lines.append(f"- {item}")

    lines.extend(["", "## Update Workflow", ""])
    for item in notes["update_workflow"]:
        lines.append(f"- {item}")

    lines.extend(["", "## Time-Energy-Value Rules", ""])
    for item in notes["tev_rules"]:
        lines.append(f"- {item}")

    lines.extend(["", "## Current Priority Lanes", ""])
    for band in notes["priority_bands"]:
        count = priority_counts.get(band["id"], 0)
        lines.append(f"- **{band['label']}** ({count}): {band['description']}")

    lines.extend(["", "## Web Entry Point", "", "### Reference Pages", ""])
    for page in render_index.REFERENCE_PAGES:
        lines.append(f"- {markdown_link(page['title'], page['page_path'])}: {page['description']}")

    lines.extend(["", "### Recovered Legacy Archives", ""])
    for archive in render_index.LEGACY_ARCHIVES:
        lines.append(f"- {markdown_link(archive['title'], archive['page_path'])}: {archive['description']}")

    lines.extend(
        [
            "",
            "### Active Project Cards",
            "",
            "| Project | Surface Class | Visibility | Priority | Current Manifest State |",
            "| --- | --- | --- | --- | --- |",
        ]
    )
    for project in projects:
        note = project_notes[project.project_id]
        priority = priority_map[note["priority_now"]]["label"]
        lines.append(
            f"| {markdown_link(project.display_name, project.project_page_href)} | "
            f"{format_surface_class(note)} | {format_visibility(note)} | {priority} | "
            f"{project.status_value}; {project.focus_value} |"
        )

    lines.extend(["", "## Project Records", ""])
    for project in projects:
        note = project_notes[project.project_id]
        priority = priority_map[note["priority_now"]]["label"]
        evidence = evidence_summary(project.project_id)
        links = ", ".join(markdown_link(link["label"], link["url"]) for link in project_links(project, note))
        lines.extend(
            [
                f"### {project.display_name}",
                "",
                f"- Surface class: {format_surface_class(note)}",
                f"- Visibility: {format_visibility(note)}",
                f"- Priority now: {priority}",
                f"- Time-energy-value: energy {note['energy']}; value {note['value']}; horizon {note['time_horizon']}",
                f"- Current manifest state: {status_summary(project)}",
            ]
        )
        if evidence:
            lines.append(f"- Evidence status: {evidence}")
        lines.extend(
            [
                f"- Likely current work: {note['likely_current_work']}",
                f"- Next step: {note['next_step']}",
                f"- Quality: {note['quality_note']}",
                f"- Coordination note: {note['coordination_note']}",
            ]
        )
        if note.get("drift_note"):
            lines.append(f"- Drift note: {note['drift_note']}")
        lines.append(f"- Public links: {links}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def render_priority_card(band: dict[str, str], count: int) -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(band["label"])}</h3>
                    <div class="detailList">
                        <div><strong>Projects</strong> {count}</div>
                    </div>
                    <p>{html.escape(band["description"])}</p>
                </article>"""


def render_reference_preview(page: dict[str, str]) -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(page["title"])}</h3>
                    <p>{html.escape(page["description"])}</p>
                    <div class="links">
                        {render_index.render_button(page["page_path"], page["button_label"])}
                    </div>
                </article>"""


def render_archive_preview(archive: dict[str, str]) -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(archive["title"])}</h3>
                    <p>{html.escape(archive["description"])}</p>
                    <div class="links">
                        {render_index.render_button(archive["page_path"], archive["button_label"])}
                    </div>
                </article>"""


def render_project_entry(
    project: render_index.ProjectStatus,
    note: dict[str, Any],
    priority_map: dict[str, dict[str, str]],
) -> str:
    badges = [
        note["surface_class"],
        note["visibility"],
        priority_map[note["priority_now"]]["label"],
        f"Energy {note['energy']}",
        f"Value {note['value']}",
        f"Horizon {note['time_horizon']}",
    ]
    evidence = evidence_summary(project.project_id)
    drift_html = ""
    if note.get("drift_note"):
        drift_html = (
            f'<div class="notePanel"><strong>Drift note</strong> '
            f'{html.escape(note["drift_note"])}</div>'
        )
    extra_rows = ""
    if evidence:
        extra_rows += f"<li><strong>Evidence status:</strong> {html.escape(evidence)}</li>"

    links_html = " ".join(html_link(link["label"], link["url"]) for link in project_links(project, note))
    return f"""            <article class="entry suiteEntry" id="project-{html.escape(project.project_id)}">
                <div class="suiteEntryTop">
                    <div>
                        <h3 class="entryTitle">{html.escape(project.display_name)}</h3>
                        <span class="entryMeta"><strong>Current manifest state</strong> {html.escape(status_summary(project))}</span>
                    </div>
                    <a class="button" href="{html.escape(project.project_page_href)}">Open project page</a>
                </div>
                <div class="badgeRow">
                    {"".join(f'<span class="badge">{html.escape(badge)}</span>' for badge in badges)}
                </div>
                <p class="suiteSummary">{html.escape(project_description(project))}</p>
                <ul class="suiteFacts">
                    <li><strong>Likely current work:</strong> {html.escape(note["likely_current_work"])}</li>
                    <li><strong>Next step:</strong> {html.escape(note["next_step"])}</li>
                    <li><strong>Quality:</strong> {html.escape(note["quality_note"])}</li>
                    <li><strong>Coordination note:</strong> {html.escape(note["coordination_note"])}</li>
                    {extra_rows}
                </ul>
                {drift_html}
                <div class="links">
                    {links_html}
                </div>
            </article>"""


def render_html(notes: dict[str, Any], projects: list[render_index.ProjectStatus]) -> str:
    priority_map = priority_lookup(notes)
    project_notes = notes["projects"]
    priority_counts = Counter(project_notes[project.project_id]["priority_now"] for project in projects)
    branch = git_branch()

    branch_note = (
        f"<div class=\"notePanel\"><strong>Current branch snapshot:</strong> "
        f"<code>{html.escape(branch)}</code>. This page reflects the repo coordination state in this checkout, "
        "so it can run ahead of or behind the live public site until changes are published.</div>"
        if branch
        else ""
    )

    priority_cards = "\n".join(
        render_priority_card(band, priority_counts.get(band["id"], 0))
        for band in notes["priority_bands"]
    )
    reference_cards = "\n".join(render_reference_preview(page) for page in render_index.REFERENCE_PAGES)
    archive_cards = "\n".join(render_archive_preview(archive) for archive in render_index.LEGACY_ARCHIVES)
    project_entries = "\n".join(
        render_project_entry(project, project_notes[project.project_id], priority_map)
        for project in projects
    )

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Project Suite Overview</title>
    <link rel="stylesheet" href="assets/public-site.css">
    <style>
        .badgeRow {{
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 14px 0 16px;
        }}

        .badge {{
            display: inline-flex;
            align-items: center;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(121, 184, 255, 0.14);
            border: 1px solid rgba(121, 184, 255, 0.24);
            color: #eff7ff;
            font-size: 12px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }}

        .suiteEntry {{
            padding: 24px;
        }}

        .suiteEntry + .suiteEntry {{
            margin-top: 16px;
        }}

        .suiteEntryTop {{
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: flex-start;
        }}

        .suiteSummary {{
            margin: 0 0 14px;
            color: var(--muted);
            line-height: 1.6;
        }}

        .suiteFacts {{
            margin: 0;
            padding-left: 18px;
            color: var(--muted);
        }}

        .suiteFacts li + li {{
            margin-top: 8px;
        }}

        .metaList {{
            display: grid;
            gap: 12px;
        }}

        @media (max-width: 720px) {{
            .suiteEntryTop {{
                flex-direction: column;
                align-items: flex-start;
            }}
        }}
    </style>
</head>
<body>
    <!-- Generated by tools/render_project_suite_overview.py from data/shared/project-suite-overview.json and active project manifests -->
    <main class="shell">
        <section class="hero">
            <div class="heroTop">
                <span class="eyebrow">Reference Page</span>
                <a class="heroHomeLink" href="index.html">Steven Woods</a>
            </div>
            <h1>Project Suite Overview</h1>
            <p class="lead">{html.escape(notes["summary"])}</p>
            <div class="meta">
                <div class="metaCard">
                    <span class="metaLabel">Tracked projects</span>
                    <span class="metaValue">{len(projects)}</span>
                    <div class="metaNote">Active project lines currently carried by this overview.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Reference pages</span>
                    <span class="metaValue">{len(render_index.REFERENCE_PAGES)}</span>
                    <div class="metaNote">Top-level public entry-point pages outside the active project cards.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Priority bands</span>
                    <span class="metaValue">{len(notes["priority_bands"])}</span>
                    <div class="metaNote">The current reprioritization vocabulary for this suite.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Updated</span>
                    <span class="metaValue">{html.escape(notes["updated_at"])}</span>
                    <div class="metaNote">Update this when the portfolio judgment layer changes materially.</div>
                </div>
            </div>
            <div class="links">
                {render_index.render_button("PROJECT-SUITE-OVERVIEW.md", "Open repo overview")}
                {render_index.render_button("index.html", "Open public index")}
                {render_index.render_button("PUBLIC-OPERATING-MODEL.md", "Open operating model")}
            </div>
        </section>

        <section class="panel">
            <h2>How To Use This</h2>
            <div class="metaList">
                {"".join(f'<div class="notePanel">{html.escape(item)}</div>' for item in notes["use_this_page_for"])}
            </div>
            {branch_note}
        </section>

        <section class="panel">
            <h2>Update Workflow</h2>
            <ul class="guideList">
                {"".join(f"<li>{html.escape(item)}</li>" for item in notes["update_workflow"])}
            </ul>
        </section>

        <section class="panel">
            <h2>Time-Energy-Value Rules</h2>
            <ul class="guideList">
                {"".join(f"<li>{html.escape(item)}</li>" for item in notes["tev_rules"])}
            </ul>
        </section>

        <section class="panel">
            <h2>Current Priority Lanes</h2>
            <div class="grid">
{priority_cards}
            </div>
        </section>

        <section class="panel">
            <h2>Web Entry Point</h2>
            <p class="footer">This section mirrors what the public homepage is trying to expose: top-level reference pages, active project cards, and the legacy archive lane.</p>
            <h3>Reference Pages</h3>
            <div class="grid">
{reference_cards}
            </div>
            <h3>Recovered Legacy Archives</h3>
            <div class="grid">
{archive_cards}
            </div>
        </section>

        <section class="panel">
            <h2>Project Records</h2>
            <p class="footer">Per-project manifests stay factual. The judgments below are the portfolio layer used for reprioritization, quality calls, and next-step selection.</p>
            <div class="entryGrid">
{project_entries}
            </div>
        </section>
    </main>
</body>
</html>
"""


def validate(notes: dict[str, Any], projects: list[render_index.ProjectStatus]) -> None:
    project_ids = {project.project_id for project in projects}
    note_ids = set(notes["projects"].keys())
    missing = sorted(project_ids - note_ids)
    extra = sorted(note_ids - project_ids)
    if missing:
        raise SystemExit(f"Missing project-suite notes for: {', '.join(missing)}")
    if extra:
        raise SystemExit(f"Project-suite notes include unknown projects: {', '.join(extra)}")


def main() -> None:
    notes = load_notes()
    projects = load_projects()
    validate(notes, projects)
    HTML_OUTPUT.write_text(render_html(notes, projects))
    MARKDOWN_OUTPUT.write_text(render_markdown(notes, projects))
    print(f"Rendered {HTML_OUTPUT.relative_to(ROOT)} and {MARKDOWN_OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
