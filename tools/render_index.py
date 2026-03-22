#!/usr/bin/env python3
"""Render public/index.html from project status manifests."""

from __future__ import annotations

import html
import json
import subprocess
from dataclasses import dataclass
from datetime import date, datetime, time, timedelta, timezone
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
ACTIVITY_PROJECTS = [
    {
        "label": "Abtweak",
        "repo_path": Path("/Users/stevenwoods/mmath-renovation"),
        "ref": "origin/main",
        "css_class": "activitySegment--abtweak",
        "project_id": "mmath-renovation",
    },
    {
        "label": "CSP",
        "repo_path": Path("/Users/stevenwoods/phd-renovation"),
        "ref": "origin/main",
        "css_class": "activitySegment--csp",
        "project_id": "phd-renovation",
    },
    {
        "label": "Galaga",
        "repo_path": Path("/Users/stevenwoods/Documents/Codex-Test1"),
        "ref": "origin/main",
        "css_class": "activitySegment--galaga",
        "project_id": "codex-test1",
    },
]
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


@dataclass
class ActivityWeek:
    start: datetime
    counts: dict[str, int]

    @property
    def total(self) -> int:
        return sum(self.counts.values())


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


def git_datetime(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%Y-%m-%dT%H:%M:%S%z")


def current_week_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    start_date = local_today - timedelta(days=local_today.weekday())
    return datetime.combine(start_date, time.min, tzinfo=LOCAL_TZ)


def weekly_commit_count(repo_path: Path, ref: str, start: datetime, end: datetime) -> int:
    result = subprocess.run(
        [
            "git",
            "-C",
            str(repo_path),
            "rev-list",
            "--count",
            f"--since={git_datetime(start)}",
            f"--before={git_datetime(end)}",
            ref,
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    return int(result.stdout.strip() or "0")


def load_activity_weeks(num_weeks: int = 8) -> list[ActivityWeek]:
    start = current_week_start() - timedelta(weeks=num_weeks - 1)
    weeks: list[ActivityWeek] = []
    for offset in range(num_weeks):
        week_start = start + timedelta(weeks=offset)
        week_end = week_start + timedelta(weeks=1)
        counts: dict[str, int] = {}
        for project in ACTIVITY_PROJECTS:
            counts[project["project_id"]] = weekly_commit_count(
                project["repo_path"],
                project["ref"],
                week_start,
                week_end,
            )
        weeks.append(ActivityWeek(start=week_start, counts=counts))
    return weeks


def nice_upper_bound(value: int) -> int:
    if value <= 5:
        return 5
    if value <= 20:
        step = 5
    elif value <= 60:
        step = 10
    elif value <= 120:
        step = 20
    else:
        step = 25
    return ((value + step - 1) // step) * step


def format_week_label(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%b %-d")


def render_activity_chart() -> str:
    weeks = load_activity_weeks()
    ceiling = nice_upper_bound(max(week.total for week in weeks))
    midpoint = ceiling // 2
    chart_config = {
        "generated_at": datetime.now(LOCAL_TZ).isoformat(),
        "weeks": [week.start.isoformat() for week in weeks],
        "projects": [
            {
                "label": project["label"],
                "project_id": project["project_id"],
                "repo": project["repo_path"].name,
                "ref": "main",
            }
            for project in ACTIVITY_PROJECTS
        ],
    }
    legend = []
    for project in ACTIVITY_PROJECTS:
        total = sum(week.counts[project["project_id"]] for week in weeks)
        legend.append(
            f"""                <div class="activityLegendItem">
                    <span class="activityLegendSwatch {project["css_class"]}"></span>
                    <span><strong>{html.escape(project["label"])}</strong> <span data-activity-legend-total="{project["project_id"]}">{total}</span> commits in the last 8 weeks</span>
                </div>"""
        )

    columns = []
    for week in weeks:
        segments = []
        for project in ACTIVITY_PROJECTS:
            count = week.counts[project["project_id"]]
            height = (count / ceiling) * 100
            segments.append(
                f"""                                <span class="activitySegment {project["css_class"]}" data-activity-project="{project["project_id"]}" style="height: {height:.2f}%;" title="{html.escape(project["label"])}: {count} commits"></span>"""
            )
        columns.append(
            f"""                    <div class="activityWeek" data-activity-week="{week.start.isoformat()}">
                        <div class="activityColumn">
                            <div class="activityStack" aria-label="{html.escape(format_week_label(week.start))}: {week.total} total commits">
{chr(10).join(segments)}
                            </div>
                        </div>
                        <div class="activityTotal" data-activity-total>{week.total}</div>
                        <div class="activityLabel">{html.escape(format_week_label(week.start))}</div>
                    </div>"""
        )

    chart_config_json = json.dumps(chart_config).replace("</", "<\\/")

    return f"""        <section class="panel" data-activity-chart>
            <h2>Recent Project Activity</h2>
            <p class="lead">Weekly commit counts on <code>origin/main</code> for the last 8 weeks across the three main project lines: Abtweak, CSP, and Galaga.</p>
            <div class="activityChart">
                <div class="activityYAxis" aria-hidden="true">
                    <span data-activity-axis="top">{ceiling}</span>
                    <span data-activity-axis="mid">{midpoint}</span>
                    <span data-activity-axis="bottom">0</span>
                </div>
                <div class="activityPlot">
                    <div class="activityGridLine activityGridLine--top"></div>
                    <div class="activityGridLine activityGridLine--mid"></div>
                    <div class="activityBars">
{chr(10).join(columns)}
                    </div>
                </div>
            </div>
            <div class="activityLegend">
{chr(10).join(legend)}
            </div>
            <p class="footer" data-activity-status>Rendered from local repository history and refreshed from GitHub when the page loads.</p>
            <script id="activity-chart-config" type="application/json">{chart_config_json}</script>
        </section>"""


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
    <link rel="stylesheet" href="assets/public-site.css">
    <script src="assets/public-index.js" defer></script>
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
                <article class="card">
                    <h3>Style guide</h3>
                    <p>Shared colors, panels, button patterns, and ancestor-navigation guidance for public pages.</p>
                    <div class="links">
                        {render_button("style-guide.html", "Open guide")}
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

{render_activity_chart()}
    </main>
</body>
</html>
"""


def main() -> None:
    OUTPUT.write_text(render())


if __name__ == "__main__":
    main()
