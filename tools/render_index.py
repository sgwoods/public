#!/usr/bin/env python3
"""Render public/index.html from project status manifests."""

from __future__ import annotations

import html
import json
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

try:
    from zoneinfo import ZoneInfo
except ImportError as exc:  # pragma: no cover
    raise SystemExit(f"zoneinfo is required: {exc}")


ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "data" / "projects"
OUTPUT = ROOT / "index.html"
LOCAL_TZ = ZoneInfo("America/Toronto")
PROJECT_ORDER = [
    "codex-test1",
    "phd-renovation",
    "mmath-renovation",
]
PROJECT_DESCRIPTIONS = {
    "codex-test1": "Public project page for the Neo Galaga Tribute web application.",
    "phd-renovation": "Public project page for the restored PhD program-understanding codebase.",
    "mmath-renovation": "Public project page for reviving the AbTweak thesis code and documentation.",
}
LEGACY_SPECTRA = {
    "title": "Old Research Archive Recovery",
    "description": "Recovered entry point for the historical Spectra research site, including preserved publication, course, bibliography, reserve, and raw research-artifact archives.",
    "page_path": "Spectra/Html/index-spectra.html",
    "last_updated": "March 22, 2026",
    "last_addition": "Research Artifacts Archive",
}


@dataclass
class ProjectStatus:
    project_id: str
    display_name: str
    project_page_path: str
    repo_url: str
    dashboard_url: str | None
    experience_url: str | None
    repo_pushed_at: datetime
    status_label: str
    status_value: str
    focus_label: str
    focus_value: str
    active: bool


def parse_datetime(value: str) -> datetime:
    normalized = value.replace("Z", "+00:00")
    parsed = datetime.fromisoformat(normalized)
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=timezone.utc)
    return parsed.astimezone(timezone.utc)


def format_local_date(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%B %-d, %Y")


def load_project(path: Path) -> ProjectStatus:
    payload: dict[str, Any] = json.loads(path.read_text())
    return ProjectStatus(
        project_id=payload["project_id"],
        display_name=payload["display_name"],
        project_page_path=payload["project_page_path"],
        repo_url=payload["repo_url"],
        dashboard_url=payload.get("dashboard_url"),
        experience_url=payload.get("experience_url"),
        repo_pushed_at=parse_datetime(payload["repo_pushed_at"]),
        status_label=payload["status_label"],
        status_value=payload["status_value"],
        focus_label=payload["focus_label"],
        focus_value=payload["focus_value"],
        active=bool(payload["active"]),
    )


def project_description(project: ProjectStatus) -> str:
    return PROJECT_DESCRIPTIONS.get(
        project.project_id,
        "Public project page synced from its repository status manifest.",
    )


def sort_key(project: ProjectStatus) -> tuple[int, str]:
    if project.project_id in PROJECT_ORDER:
        return (PROJECT_ORDER.index(project.project_id), project.display_name.lower())
    return (len(PROJECT_ORDER), project.display_name.lower())


def render_button(href: str, label: str) -> str:
    return f'<a class="button" href="{html.escape(href)}">{html.escape(label)}</a>'


def render_project_card(project: ProjectStatus) -> str:
    buttons = [
        render_button(project.project_page_path, "Open project page"),
        render_button(project.repo_url, "Open repository"),
    ]
    if project.dashboard_url:
        buttons.insert(1, render_button(project.dashboard_url, "Open dashboard"))
    if project.experience_url:
        buttons.insert(2, render_button(project.experience_url, "Open live experience"))
    return f"""                <article class="card">
                    <h3>{html.escape(project.display_name)}</h3>
                    <p>{html.escape(project_description(project))}</p>
                    <div class="detailList">
                        <div><strong>Last repo update</strong> {html.escape(format_local_date(project.repo_pushed_at))}</div>
                        <div><strong>{html.escape(project.status_label)}</strong> {html.escape(project.status_value)}</div>
                        <div><strong>{html.escape(project.focus_label)}</strong> {html.escape(project.focus_value)}</div>
                    </div>
                    <div class="links">
                        {" ".join(buttons)}
                    </div>
                </article>"""


def render_legacy_card() -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(LEGACY_SPECTRA["title"])}</h3>
                    <p>{html.escape(LEGACY_SPECTRA["description"])}</p>
                    <div class="detailList">
                        <div><strong>Last update</strong> {html.escape(LEGACY_SPECTRA["last_updated"])}</div>
                        <div><strong>Last addition</strong> {html.escape(LEGACY_SPECTRA["last_addition"])}</div>
                    </div>
                    <div class="links">
                        {render_button(LEGACY_SPECTRA["page_path"], "Open archive")}
                    </div>
                </article>"""


def render() -> str:
    projects = sorted(
        (
            load_project(path)
            for path in sorted(DATA_DIR.glob("*.json"))
        ),
        key=sort_key,
    )
    projects = [project for project in projects if project.active]
    if not projects:
        raise SystemExit("No active project manifests found.")

    last_updated = max(project.repo_pushed_at for project in projects)
    project_cards = "\n".join(render_project_card(project) for project in projects)

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Steven Woods Public Pages</title>
    <style>
        :root {{
            --bg: #07131f;
            --bg2: #10253b;
            --card: rgba(7, 19, 31, 0.72);
            --text: #eff7ff;
            --muted: #9cc4df;
            --shadow: 0 18px 40px rgba(0, 0, 0, 0.28);
        }}

        * {{
            box-sizing: border-box;
        }}

        body {{
            margin: 0;
            color: var(--text);
            font-family: "Avenir Next", "Segoe UI", sans-serif;
            background:
                radial-gradient(circle at top left, rgba(103, 230, 168, 0.18), transparent 26%),
                radial-gradient(circle at top right, rgba(121, 184, 255, 0.22), transparent 32%),
                linear-gradient(160deg, var(--bg), var(--bg2));
            min-height: 100vh;
        }}

        h1 {{
            margin: 18px 0 10px;
            font-size: clamp(34px, 5vw, 58px);
            line-height: .95;
            letter-spacing: -0.04em;
        }}

        a {{
            color: #d9f7ff;
        }}

        .shell {{
            max-width: 1100px;
            margin: 0 auto;
            padding: 40px 20px 72px;
        }}

        .hero,
        .panel {{
            border: 1px solid rgba(177, 222, 255, 0.18);
            border-radius: 28px;
            background:
                linear-gradient(160deg, rgba(12, 34, 54, 0.88), rgba(7, 19, 31, 0.72)),
                radial-gradient(circle at 20% 0%, rgba(103, 230, 168, 0.14), transparent 32%);
            box-shadow: var(--shadow);
        }}

        .hero {{
            padding: 36px 34px 32px;
        }}

        .eyebrow {{
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 7px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.08);
            color: #d7ecff;
            font-size: 12px;
            letter-spacing: .14em;
            text-transform: uppercase;
        }}

        .hero p,
        .panel p {{
            color: var(--muted);
            line-height: 1.6;
        }}

        .hero p {{
            max-width: 760px;
            font-size: 18px;
        }}

        .meta {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 14px;
            margin-top: 28px;
        }}

        .metaCard {{
            padding: 16px 18px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }}

        .metaLabel {{
            display: block;
            color: #8fb3cc;
            font-size: 12px;
            letter-spacing: .12em;
            text-transform: uppercase;
            margin-bottom: 6px;
        }}

        .metaValue {{
            font-size: 18px;
            font-weight: 600;
        }}

        .metaNote {{
            margin-top: 8px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.5;
        }}

        .panel {{
            margin-top: 22px;
            padding: 28px;
            background: rgba(7, 19, 31, 0.68);
        }}

        .panel h2 {{
            margin: 0 0 12px;
            font-size: 24px;
            letter-spacing: -0.02em;
        }}

        .grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 16px;
        }}

        .card {{
            padding: 18px 18px 16px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }}

        .card h3 {{
            margin: 0 0 8px;
            font-size: 18px;
        }}

        .detailList {{
            display: grid;
            gap: 8px;
            margin-top: 14px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.5;
        }}

        .detailList strong {{
            color: #eff7ff;
            margin-right: 6px;
        }}

        .links {{
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 18px;
        }}

        .button {{
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 16px;
            border-radius: 999px;
            background: rgba(121, 184, 255, 0.18);
            border: 1px solid rgba(121, 184, 255, 0.28);
            color: #eff7ff;
            text-decoration: none;
            font-size: 14px;
            letter-spacing: 0.04em;
        }}

        .footer {{
            margin-top: 18px;
            color: #8db0c8;
            font-size: 13px;
            line-height: 1.6;
        }}

        @media (max-width: 720px) {{
            .shell {{
                padding: 20px 14px 54px;
            }}

            .hero,
            .panel {{
                padding: 24px 22px;
            }}
        }}
    </style>
</head>
<body>
    <!-- Generated by tools/render_index.py from data/projects/*.json -->
    <main class="shell">
        <section class="hero">
            <span class="eyebrow">Public Index</span>
            <h1>Steven Woods Public Pages</h1>
            <p>
                Shared public entry point for long-lived research restorations, active software projects,
                and supporting reference material. Active project cards below are rendered from the
                project status manifests in this repository.
            </p>
            <div class="meta">
                <div class="metaCard">
                    <span class="metaLabel">Tracked Projects</span>
                    <span class="metaValue">{len(projects)}</span>
                    <div class="metaNote">Active projects currently publishing homepage status manifests.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Repository Work Last Updated</span>
                    <span class="metaValue">{html.escape(format_local_date(last_updated))}</span>
                    <div class="metaNote">Computed from the latest `repo_pushed_at` value across active project manifests.</div>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Reference Pages</h2>
            <div class="grid">
                <article class="card">
                    <h3>Academic ancestry</h3>
                    <p>Direct advisor lineage with links to the Mathematics Genealogy Project.</p>
                    <div class="links">
                        {render_button("academic.html", "Open page")}
                    </div>
                </article>
                <article class="card">
                    <h3>Patents and publications</h3>
                    <p>Selected books, patents, and academic publications.</p>
                    <div class="links">
                        {render_button("patents-publications.html", "Open page")}
                    </div>
                </article>
            </div>
        </section>

        <section class="panel">
            <h2>Active Project Dashboards</h2>
            <div class="grid">
{project_cards}
            </div>
            <p class="footer">This homepage is rendered centrally from `data/projects/*.json` so independent project syncs do not write directly into `index.html`.</p>
        </section>

        <section class="panel">
            <h2>Recovered Legacy Archives</h2>
            <div class="grid">
{render_legacy_card()}
            </div>
        </section>
    </main>
</body>
</html>
"""


def main() -> None:
    OUTPUT.write_text(render())


if __name__ == "__main__":
    main()
