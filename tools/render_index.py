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
    "aurora-galactica",
    "phd-renovation",
    "mmath-renovation",
    "steven-woods-research",
    "google-canada-research",
    "inovia-research",
    "canberra-research",
    "sei-pittsburgh-research",
    "quack-com",
    "kinitos-neoedge",
]
CODING_ACTIVITY_PROJECTS = [
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
        "label": "Aurora",
        "repo_path": Path("/Users/stevenwoods/Documents/Codex-Test1"),
        "ref": "origin/main",
        "css_class": "activitySegment--galaga",
        "project_id": "aurora-galactica",
    },
]
RESEARCH_ACTIVITY_PROJECTS = [
    {
        "label": "Steven",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--steven",
        "project_id": "steven-woods-research",
        "pathspecs": ["steven-woods-research", "steven-woods-research.html"],
        "repo": "public",
    },
    {
        "label": "Quack",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--quack",
        "project_id": "quack-com",
        "pathspecs": ["quack", "quack-com.html"],
        "repo": "public",
    },
    {
        "label": "Google",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--google",
        "project_id": "google-canada-research",
        "pathspecs": ["google-canada-research", "google-canada-research.html"],
        "repo": "public",
    },
    {
        "label": "Inovia",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--inovia",
        "project_id": "inovia-research",
        "pathspecs": ["inovia-research", "inovia-research.html"],
        "repo": "public",
    },
    {
        "label": "Canberra",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--canberra",
        "project_id": "canberra-research",
        "pathspecs": ["canberra-research", "canberra-research.html"],
        "repo": "public",
    },
    {
        "label": "SEI",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--sei",
        "project_id": "sei-pittsburgh-research",
        "pathspecs": ["sei-pittsburgh-research", "sei-pittsburgh-research.html"],
        "repo": "public",
    },
    {
        "label": "Kinitos / NeoEdge",
        "repo_path": ROOT,
        "ref": "HEAD",
        "api_ref": "main",
        "css_class": "activitySegment--kinitos",
        "project_id": "kinitos-neoedge",
        "pathspecs": ["kinitos-neoedge", "kinitos-neoedge.html"],
        "repo": "public",
    },
]
LEGACY_ARCHIVES = [
    {
        "title": "Old Research Archive Recovery",
        "description": "Recovered entry point for the historical Spectra research site, including preserved publication, course, bibliography, reserve, and raw research-artifact archives.",
        "page_path": "Spectra/Html/index-spectra.html",
        "last_updated": "March 22, 2026",
        "last_addition": "Research Artifacts Archive",
        "button_label": "Open archive",
    },
]


@dataclass
class ProjectStatus:
    project_id: str
    display_name: str
    description: str | None
    project_page_href: str
    repo_url: str | None
    dashboard_url: str | None
    experience_url: str | None
    repo_pushed_at: datetime
    status_generated_at: datetime
    status_label: str
    status_value: str
    focus_label: str
    focus_value: str
    person_context: str | None
    timeline_label: str | None
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
    timeline_span = payload.get("timeline_span") or {}
    project_page_href = payload.get("project_page_url") or payload.get("project_page_path")
    if not project_page_href:
        raise SystemExit(f"Missing project page link in {path}")
    status_label = payload.get("status_label") or "Current phase"
    status_value = payload.get("status_value") or timeline_span.get("label") or "Archive project"
    focus_label = payload.get("focus_label") or "Current focus"
    focus_value = payload.get("focus_value") or payload.get("current_focus") or "Archive organization"
    return ProjectStatus(
        project_id=payload["project_id"],
        display_name=payload["display_name"],
        description=payload.get("description"),
        project_page_href=project_page_href,
        repo_url=payload.get("repo_url") or None,
        dashboard_url=payload.get("dashboard_url"),
        experience_url=payload.get("experience_url"),
        repo_pushed_at=parse_datetime(payload["repo_pushed_at"]),
        status_generated_at=parse_datetime(payload["status_generated_at"]),
        status_label=status_label,
        status_value=status_value,
        focus_label=focus_label,
        focus_value=focus_value,
        person_context=payload.get("person_context"),
        timeline_label=timeline_span.get("label"),
        active=bool(payload["active"]),
    )

def sort_key(project: ProjectStatus) -> tuple[int, str]:
    if project.project_id in PROJECT_ORDER:
        return (PROJECT_ORDER.index(project.project_id), project.display_name.lower())
    return (len(PROJECT_ORDER), project.display_name.lower())


def project_rank(project: ProjectStatus) -> tuple[datetime, datetime, int, int, str]:
    return (
        project.status_generated_at,
        project.repo_pushed_at,
        int(bool(project.person_context)),
        int(bool(project.repo_url)),
        project.project_id,
    )


def dedupe_projects(projects: list[ProjectStatus]) -> list[ProjectStatus]:
    latest_by_id: dict[str, ProjectStatus] = {}
    for project in projects:
        existing = latest_by_id.get(project.project_id)
        if existing is None or project_rank(project) > project_rank(existing):
            latest_by_id[project.project_id] = project

    latest_by_repo: dict[str, ProjectStatus] = {}
    passthrough: list[ProjectStatus] = []

    for project in latest_by_id.values():
        key = (project.repo_url or "").strip().lower()
        if not key:
            passthrough.append(project)
            continue
        existing = latest_by_repo.get(key)
        if existing is None:
            latest_by_repo[key] = project
            continue
        if (
            project.status_generated_at,
            project.repo_pushed_at,
            project.project_id,
        ) > (
            existing.status_generated_at,
            existing.repo_pushed_at,
            existing.project_id,
        ):
            latest_by_repo[key] = project

    return passthrough + list(latest_by_repo.values())


def render_button(href: str, label: str) -> str:
    return f'<a class="button" href="{html.escape(href)}">{html.escape(label)}</a>'


def git_datetime(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%Y-%m-%dT%H:%M:%S%z")


def current_week_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    start_date = local_today - timedelta(days=local_today.weekday())
    return datetime.combine(start_date, time.min, tzinfo=LOCAL_TZ)


def git_rev_list_count(
    repo_path: Path,
    ref: str,
    start: datetime,
    end: datetime,
    pathspecs: list[str] | None = None,
) -> int:
    command = [
        "git",
        "-C",
        str(repo_path),
        "rev-list",
        "--count",
        f"--since={git_datetime(start)}",
        f"--before={git_datetime(end)}",
        ref,
    ]
    if pathspecs:
        command.extend(["--", *pathspecs])

    result = subprocess.run(
        command,
        check=True,
        capture_output=True,
        text=True,
    )
    return int(result.stdout.strip() or "0")


def load_activity_weeks(projects: list[dict[str, Any]], num_weeks: int = 8) -> list[ActivityWeek]:
    start = current_week_start() - timedelta(weeks=num_weeks - 1)
    weeks: list[ActivityWeek] = []
    for offset in range(num_weeks):
        week_start = start + timedelta(weeks=offset)
        week_end = week_start + timedelta(weeks=1)
        counts: dict[str, int] = {}
        for project in projects:
            counts[project["project_id"]] = git_rev_list_count(
                project["repo_path"],
                project["ref"],
                week_start,
                week_end,
                project.get("pathspecs"),
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


def render_activity_chart(
    *,
    chart_id: str,
    title: str,
    lead: str,
    projects: list[dict[str, Any]],
    metric_label: str,
) -> str:
    weeks = load_activity_weeks(projects)
    ceiling = nice_upper_bound(max(week.total for week in weeks))
    midpoint = ceiling // 2
    chart_config = {
        "chart_id": chart_id,
        "generated_at": datetime.now(LOCAL_TZ).isoformat(),
        "weeks": [week.start.isoformat() for week in weeks],
        "metric_label": metric_label,
        "projects": [
            {
                "label": project["label"],
                "project_id": project["project_id"],
                "repo": project.get("repo", project["repo_path"].name),
                "ref": project.get("api_ref", project["ref"].replace("origin/", "")),
                "paths": project.get("pathspecs", []),
            }
            for project in projects
        ],
    }
    legend = []
    for project in projects:
        total = sum(week.counts[project["project_id"]] for week in weeks)
        legend.append(
            f"""                <div class="activityLegendItem">
                    <span class="activityLegendSwatch {project["css_class"]}"></span>
                    <span><strong>{html.escape(project["label"])}</strong> <span data-activity-legend-total="{project["project_id"]}">{total}</span> {html.escape(metric_label)} in the last 8 weeks</span>
                </div>"""
        )

    columns = []
    for week in weeks:
        segments = []
        for project in projects:
            count = week.counts[project["project_id"]]
            height = (count / ceiling) * 100
            segments.append(
                f"""                                <span class="activitySegment {project["css_class"]}" data-activity-project="{project["project_id"]}" style="height: {height:.2f}%;" title="{html.escape(project["label"])}: {count} {html.escape(metric_label)}"></span>"""
            )
        columns.append(
            f"""                    <div class="activityWeek" data-activity-week="{week.start.isoformat()}">
                        <div class="activityColumn">
                            <div class="activityStack" aria-label="{html.escape(format_week_label(week.start))}: {week.total} total {html.escape(metric_label)}">
{chr(10).join(segments)}
                            </div>
                        </div>
                        <div class="activityTotal" data-activity-total>{week.total}</div>
                        <div class="activityLabel">{html.escape(format_week_label(week.start))}</div>
                    </div>"""
        )

    chart_config_json = json.dumps(chart_config).replace("</", "<\\/")

    return f"""        <section class="panel" data-activity-chart data-activity-chart-id="{chart_id}">
            <h2>{html.escape(title)}</h2>
            <p class="lead">{html.escape(lead)}</p>
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
            <script id="activity-chart-config-{chart_id}" type="application/json">{chart_config_json}</script>
        </section>"""


def render_project_card(project: ProjectStatus) -> str:
    description = project.description or "Public project page synced from its repository status manifest."
    buttons = [render_button(project.project_page_href, "Open project page")]
    if project.dashboard_url:
        buttons.insert(1, render_button(project.dashboard_url, "Open dashboard"))
    if project.experience_url:
        buttons.insert(2, render_button(project.experience_url, "Open live experience"))
    if project.repo_url:
        buttons.append(render_button(project.repo_url, "Open repository"))
    details = [
        f"<div><strong>Last repo update</strong> {html.escape(format_local_date(project.repo_pushed_at))}</div>",
        f"<div><strong>{html.escape(project.status_label)}</strong> {html.escape(project.status_value)}</div>",
        f"<div><strong>{html.escape(project.focus_label)}</strong> {html.escape(project.focus_value)}</div>",
    ]
    if project.timeline_label:
        details.insert(1, f"<div><strong>Archive span</strong> {html.escape(project.timeline_label)}</div>")
    person_context = ""
    if project.person_context:
        person_context = f'\n                    <p class="footer">{html.escape(project.person_context)}</p>'
    return f"""                <article class="card" data-project-card="{html.escape(project.project_id)}">
                    <h3>{html.escape(project.display_name)}</h3>
                    <p>{html.escape(description)}</p>
                    <div class="detailList">
                        {"".join(details)}
                    </div>
{person_context}
                    <div class="links">
                        {" ".join(buttons)}
                    </div>
                </article>"""


def render_legacy_card(archive: dict[str, str]) -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(archive["title"])}</h3>
                    <p>{html.escape(archive["description"])}</p>
                    <div class="detailList">
                        <div><strong>Last update</strong> {html.escape(archive["last_updated"])}</div>
                        <div><strong>Last addition</strong> {html.escape(archive["last_addition"])}</div>
                    </div>
                    <div class="links">
                        {render_button(archive["page_path"], archive["button_label"])}
                    </div>
                </article>"""


def render_style_guide_note() -> str:
    return f"""        <section class="panel">
            <div class="notePanel">
                <span class="microLabel">Project Note</span>
                <p class="microNote">The shared public-site style guide lives here for the active project pages, but it stays intentionally low-profile on the homepage. LinkedIn is also linked here as an external profile/source reference.</p>
                <div class="links">
                    {render_button("style-guide.html", "Open style guide")}
                    {render_button("https://www.linkedin.com/in/stevenwoods/", "Open LinkedIn")}
                </div>
            </div>
        </section>"""


def render() -> str:
    projects = sorted(
        [load_project(path) for path in sorted(DATA_DIR.glob("*.json"))]
        + [load_project(path) for path in sorted(ROOT.glob("*/project-manifest.json"))],
        key=sort_key,
    )
    projects = [project for project in projects if project.active]
    projects = dedupe_projects(projects)
    projects.sort(key=sort_key)
    if not projects:
        raise SystemExit("No active project manifests found.")

    last_updated = max(project.repo_pushed_at for project in projects)
    project_cards = "\n".join(render_project_card(project) for project in projects)
    project_manifest_config = {
        "repo_contents_api": "https://api.github.com/repos/sgwoods/public/contents/data/projects?ref=main",
        "fallback_manifest_paths": [f"data/projects/{path.name}" for path in sorted(DATA_DIR.glob("*.json"))],
        "supplemental_manifest_paths": [
            f"{path.parent.name}/{path.name}" for path in sorted(ROOT.glob("*/project-manifest.json"))
        ],
        "project_order": PROJECT_ORDER,
    }
    project_manifest_config_json = json.dumps(project_manifest_config).replace("</", "<\\/")

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
    <!-- Generated by tools/render_index.py from data/projects/*.json and */project-manifest.json -->
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
                    <span class="metaValue" data-project-count>{len(projects)}</span>
                    <div class="metaNote">Active projects currently publishing homepage status manifests.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Repository Work Last Updated</span>
                    <span class="metaValue" data-project-last-updated>{html.escape(format_local_date(last_updated))}</span>
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

        <section class="panel" data-project-manifests>
            <h2>Active Project Dashboards</h2>
            <div class="grid" data-project-grid>
{project_cards}
            </div>
            <p class="footer" data-project-status>This homepage is rendered centrally from `data/projects/*.json` so independent project syncs do not write directly into `index.html`.</p>
            <script id="project-manifest-config" type="application/json">{project_manifest_config_json}</script>
        </section>

        <section class="panel">
            <h2>Recovered Legacy Archives</h2>
            <div class="grid">
{chr(10).join(render_legacy_card(archive) for archive in LEGACY_ARCHIVES)}
            </div>
        </section>

{render_activity_chart(
    chart_id="coding",
    title="Recent Coding Activity",
    lead="Weekly commit counts on origin/main for the last 8 weeks across the three software project lines: Abtweak, CSP, and Aurora.",
    projects=CODING_ACTIVITY_PROJECTS,
    metric_label="commits",
)}

{render_activity_chart(
    chart_id="research",
    title="Recent Research Archive Activity",
    lead="Weekly path-scoped commit counts in the public archive repo for the last 8 weeks across the Steven Woods, Quack, and Kinitos / NeoEdge research lines.",
    projects=RESEARCH_ACTIVITY_PROJECTS,
    metric_label="commits",
)}

{render_style_guide_note()}
    </main>
</body>
</html>
"""


def main() -> None:
    OUTPUT.write_text(render())


if __name__ == "__main__":
    main()
