#!/usr/bin/env python3
"""Render public/index.html from project status manifests."""

from __future__ import annotations

import html
import json
import os
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


def first_existing_path(candidates: list[Path]) -> Path:
    for candidate in candidates:
        if candidate.exists():
            return candidate
    return candidates[0]


def env_or_candidates(env_name: str, candidates: list[Path]) -> Path:
    override_raw = os.environ.get(env_name)
    if override_raw:
        override = Path(override_raw).expanduser()
        return override
    return first_existing_path(candidates)


PROJECT_ORDER = [
    "aurora-galactica",
    "confidential-project",
    "ai-dystopia-quotes",
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
KNOWN_CODING_REPOS: dict[str, dict[str, Any]] = {
    "mmath-renovation": {
        "label": "Abtweak",
        "repo_path": env_or_candidates(
            "PUBLIC_MMATH_REPO_PATH",
            [
                Path.home() / "Projects-All" / "mmath-renovation-working",
                Path("/Users/steven/Projects-All/mmath-renovation-working"),
                Path.home() / "Documents" / "GitPages" / "mmath-renovation",
                Path("/Users/steven/Documents/GitPages/mmath-renovation"),
                Path("/Users/stevenwoods/mmath-renovation"),
            ],
        ),
        "ref": "origin/main",
        "api_ref": "main",
        "repo": "mmath-renovation",
    },
    "phd-renovation": {
        "label": "CSP",
        "repo_path": env_or_candidates(
            "PUBLIC_PHD_REPO_PATH",
            [
                Path.home() / "Projects-All" / "phd-renovation-working",
                Path("/Users/steven/Projects-All/phd-renovation-working"),
                Path.home() / "Documents" / "GitPages" / "phd-renovation",
                Path("/Users/steven/Documents/GitPages/phd-renovation"),
                Path("/Users/stevenwoods/phd-renovation"),
            ],
        ),
        "ref": "origin/main",
        "api_ref": "main",
        "repo": "phd-renovation",
    },
    "aurora-galactica": {
        "label": "Aurora",
        "repo_path": env_or_candidates(
            "PUBLIC_AURORA_REPO_PATH",
            [
                Path.home() / "Projects-All" / "Codex-Test1",
                Path("/Users/steven/Projects-All/Codex-Test1"),
                Path.home() / "Documents" / "Codex-Test1",
                Path.home() / "Documents" / "New project" / "Codex-Test1",
                Path("/Users/steven/Documents/Codex-Test1"),
                Path("/Users/stevenwoods/Documents/Codex-Test1"),
            ],
        ),
        "ref": "origin/main",
        "api_ref": "main",
        "repo": "Codex-Test1",
    },
}

ACTIVITY_COLOR_PALETTE = [
    ("rgba(103, 230, 168, 0.96)", "rgba(57, 181, 124, 0.96)"),
    ("rgba(121, 184, 255, 0.96)", "rgba(74, 126, 230, 0.96)"),
    ("rgba(255, 214, 107, 0.96)", "rgba(233, 157, 62, 0.96)"),
    ("rgba(255, 176, 82, 0.96)", "rgba(219, 116, 50, 0.96)"),
    ("rgba(246, 83, 20, 0.96)", "rgba(219, 68, 55, 0.96)"),
    ("rgba(162, 89, 255, 0.96)", "rgba(110, 56, 190, 0.96)"),
    ("rgba(54, 179, 126, 0.96)", "rgba(28, 120, 85, 0.96)"),
    ("rgba(159, 168, 218, 0.96)", "rgba(92, 107, 192, 0.96)"),
    ("rgba(98, 214, 202, 0.96)", "rgba(39, 166, 162, 0.96)"),
    ("rgba(244, 143, 177, 0.96)", "rgba(216, 27, 96, 0.96)"),
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
REFERENCE_PAGES = [
    {
        "title": "Project suite overview",
        "description": "Portfolio map, public/private surface guide, and reprioritization layer across the full project suite.",
        "page_path": "project-suite-overview.html",
        "button_label": "Open page",
    },
    {
        "title": "Profile",
        "description": "Compact executive profile with current links to LinkedIn, Inovia, and the open archive projects.",
        "page_path": "steven-woods-profile.html",
        "button_label": "Open page",
    },
    {
        "title": "Academic ancestry",
        "description": "Direct advisor lineage with links to the Mathematics Genealogy Project.",
        "page_path": "academic.html",
        "button_label": "Open page",
    },
    {
        "title": "Patents and publications",
        "description": "Selected books, patents, and academic publications.",
        "page_path": "patents-publications.html",
        "button_label": "Open page",
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
class ActivityBucket:
    start: datetime
    end: datetime
    label: str
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


def format_local_datetime(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%B %-d, %Y at %-I:%M %p")


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


def render_reference_card(page: dict[str, str]) -> str:
    return f"""                <article class="card">
                    <h3>{html.escape(page["title"])}</h3>
                    <p>{html.escape(page["description"])}</p>
                    <div class="links">
                        {render_button(page["page_path"], page["button_label"])}
                    </div>
                </article>"""


def git_datetime(value: datetime) -> str:
    return value.astimezone(LOCAL_TZ).strftime("%Y-%m-%dT%H:%M:%S%z")


def current_week_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    start_date = local_today - timedelta(days=local_today.weekday())
    return datetime.combine(start_date, time.min, tzinfo=LOCAL_TZ)


def current_day_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    return datetime.combine(local_today, time.min, tzinfo=LOCAL_TZ)


def git_rev_list_count(
    repo_path: Path,
    ref: str,
    start: datetime,
    end: datetime,
    pathspecs: list[str] | None = None,
) -> int:
    if not repo_path.exists():
        return 0
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

    try:
        result = subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return 0
    return int(result.stdout.strip() or "0")


def load_weekly_activity_buckets(projects: list[dict[str, Any]], num_weeks: int = 8) -> list[ActivityBucket]:
    start = current_week_start() - timedelta(weeks=num_weeks - 1)
    weeks: list[ActivityBucket] = []
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
        weeks.append(
            ActivityBucket(
                start=week_start,
                end=week_end,
                label=week_start.astimezone(LOCAL_TZ).strftime("%b %-d"),
                counts=counts,
            )
        )
    return weeks


def load_daily_activity_buckets(projects: list[dict[str, Any]], num_days: int = 7) -> list[ActivityBucket]:
    start = current_day_start() - timedelta(days=num_days - 1)
    days: list[ActivityBucket] = []
    for offset in range(num_days):
        day_start = start + timedelta(days=offset)
        day_end = day_start + timedelta(days=1)
        counts: dict[str, int] = {}
        for project in projects:
            counts[project["project_id"]] = git_rev_list_count(
                project["repo_path"],
                project["ref"],
                day_start,
                day_end,
                project.get("pathspecs"),
            )
        days.append(
            ActivityBucket(
                start=day_start,
                end=day_end,
                label=day_start.astimezone(LOCAL_TZ).strftime("%b %-d"),
                counts=counts,
            )
        )
    return days


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


def activity_color(index: int) -> tuple[str, str]:
    return ACTIVITY_COLOR_PALETTE[index % len(ACTIVITY_COLOR_PALETTE)]


def research_manifest_folder_by_id() -> dict[str, str]:
    mapping: dict[str, str] = {}
    for path in sorted(ROOT.glob("*/project-manifest.json")):
        payload = json.loads(path.read_text())
        project_id = payload.get("project_id")
        if project_id:
            mapping[project_id] = path.parent.name
    return mapping


def classify_projects(projects: list[ProjectStatus]) -> tuple[list[ProjectStatus], list[ProjectStatus]]:
    research_ids = set(research_manifest_folder_by_id())
    research_projects: list[ProjectStatus] = []
    coding_projects: list[ProjectStatus] = []

    for project in projects:
        if project.project_id in research_ids:
            research_projects.append(project)
        else:
            coding_projects.append(project)

    coding_projects.sort(key=sort_key)
    research_projects.sort(key=sort_key)
    return coding_projects, research_projects


def build_coding_activity_projects(projects: list[ProjectStatus]) -> list[dict[str, Any]]:
    activity_projects: list[dict[str, Any]] = []
    for index, project in enumerate(projects):
        color_top, color_bottom = activity_color(index)
        known = KNOWN_CODING_REPOS.get(project.project_id)
        if known:
            activity_projects.append(
                {
                    "label": known["label"],
                    "repo_path": known["repo_path"],
                    "ref": known["ref"],
                    "api_ref": known["api_ref"],
                    "project_id": project.project_id,
                    "repo": known["repo"],
                    "color_top": color_top,
                    "color_bottom": color_bottom,
                    "pathspecs": known.get("pathspecs", []),
                }
            )
            continue

        pathspecs = [project.project_page_href, f"data/projects/{project.project_id}.json"]
        related_data = ROOT / "data" / f"{project.project_id}.approved.json"
        if related_data.exists():
            pathspecs.append(f"data/{project.project_id}.approved.json")

        activity_projects.append(
            {
                "label": project.display_name,
                "repo_path": ROOT,
                "ref": "HEAD",
                "api_ref": "main",
                "project_id": project.project_id,
                "repo": "public",
                "pathspecs": pathspecs,
                "color_top": color_top,
                "color_bottom": color_bottom,
            }
        )
    return activity_projects


def build_research_activity_projects(projects: list[ProjectStatus]) -> list[dict[str, Any]]:
    activity_projects: list[dict[str, Any]] = []
    folder_by_id = research_manifest_folder_by_id()
    for index, project in enumerate(projects):
        color_top, color_bottom = activity_color(index)
        folder_name = folder_by_id.get(project.project_id)
        folder = ROOT / folder_name if folder_name else None
        pathspecs = [project.project_page_href]
        if folder and folder.exists():
            pathspecs.insert(0, folder_name)
        else:
            fallback_folder = project.project_page_href.removesuffix(".html")
            if (ROOT / fallback_folder).exists():
                pathspecs.insert(0, fallback_folder)

        activity_projects.append(
            {
                "label": project.display_name,
                "repo_path": ROOT,
                "ref": "HEAD",
                "api_ref": "main",
                "project_id": project.project_id,
                "repo": "public",
                "pathspecs": pathspecs,
                "color_top": color_top,
                "color_bottom": color_bottom,
            }
        )
    return activity_projects


def render_activity_chart(
    *,
    chart_id: str,
    title: str,
    lead: str,
    projects: list[dict[str, Any]],
    metric_label: str,
    buckets: list[ActivityBucket],
    bucket_mode: str,
) -> str:
    ceiling = nice_upper_bound(max(bucket.total for bucket in buckets))
    midpoint = ceiling // 2
    chart_config = {
        "chart_id": chart_id,
        "generated_at": datetime.now(LOCAL_TZ).isoformat(),
        "bucket_mode": bucket_mode,
        "buckets": [
            {
                "start": bucket.start.isoformat(),
                "end": bucket.end.isoformat(),
                "label": bucket.label,
            }
            for bucket in buckets
        ],
        "metric_label": metric_label,
        "projects": [
            {
                "label": project["label"],
                "project_id": project["project_id"],
                "repo": project.get("repo", project["repo_path"].name),
                "ref": project.get("api_ref", project["ref"].replace("origin/", "")),
                "paths": project.get("pathspecs", []),
                "color_top": project["color_top"],
                "color_bottom": project["color_bottom"],
            }
            for project in projects
        ],
    }
    legend = []
    for project in projects:
        total = sum(bucket.counts[project["project_id"]] for bucket in buckets)
        legend.append(
            f"""                <div class="activityLegendItem">
                    <span class="activityLegendSwatch" style="--activity-top: {project["color_top"]}; --activity-bottom: {project["color_bottom"]};"></span>
                    <span><strong>{html.escape(project["label"])}</strong> <span data-activity-legend-total="{project["project_id"]}">{total}</span> {html.escape(metric_label)} in this {html.escape(bucket_mode)} view</span>
                </div>"""
        )

    columns = []
    for bucket in buckets:
        segments = []
        for project in projects:
            count = bucket.counts[project["project_id"]]
            height = (count / ceiling) * 100
            segments.append(
                f"""                                <span class="activitySegment" data-activity-project="{project["project_id"]}" style="height: {height:.2f}%; --activity-top: {project["color_top"]}; --activity-bottom: {project["color_bottom"]};" title="{html.escape(project["label"])}: {count} {html.escape(metric_label)}"></span>"""
            )
        columns.append(
            f"""                    <div class="activityWeek" data-activity-week="{bucket.start.isoformat()}">
                        <div class="activityColumn">
                            <div class="activityStack" aria-label="{html.escape(bucket.label)}: {bucket.total} total {html.escape(metric_label)}">
{chr(10).join(segments)}
                            </div>
                        </div>
                        <div class="activityTotal" data-activity-total>{bucket.total}</div>
                        <div class="activityLabel">{html.escape(bucket.label)}</div>
                    </div>"""
        )

    chart_config_json = json.dumps(chart_config).replace("</", "<\\/")
    generated_label = format_local_datetime(parse_datetime(chart_config["generated_at"]))

    return f"""        <section class="panel" data-activity-chart data-activity-chart-id="{chart_id}">
            <h2>{html.escape(title)}</h2>
            <p class="lead">{html.escape(lead)}</p>
            <div class="activityChart" style="--activity-columns: {len(buckets)};">
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
            <p class="footer"><strong>Last refreshed:</strong> <span data-activity-last-refreshed>{html.escape(generated_label)}</span></p>
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
    coding_projects, research_projects = classify_projects(projects)
    coding_activity_projects = build_coding_activity_projects(coding_projects)
    research_activity_projects = build_research_activity_projects(research_projects)
    if not projects:
        raise SystemExit("No active project manifests found.")

    latest_project_repo_update = max(project.repo_pushed_at for project in projects)
    rendered_at = datetime.now(LOCAL_TZ)
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
                project status manifests in this repository. Project repo activity and page-render
                freshness are tracked separately below.
            </p>
            <div class="meta">
                <div class="metaCard">
                    <span class="metaLabel">Tracked Projects</span>
                    <span class="metaValue" data-project-count>{len(projects)}</span>
                    <div class="metaNote">Active projects currently publishing homepage status manifests.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Latest Project Repo Update</span>
                    <span class="metaValue" data-project-last-updated>{html.escape(format_local_date(latest_project_repo_update))}</span>
                    <div class="metaNote">Most recent `repo_pushed_at` represented by the active project manifests, not the homepage render date.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Homepage Rendered</span>
                    <span class="metaValue">{html.escape(format_local_datetime(rendered_at))}</span>
                    <div class="metaNote">When this index page was rendered from the manifests in this repository.</div>
                </div>
            </div>
        </section>

        <section class="panel">
            <h2>Reference Pages</h2>
            <div class="grid">
{chr(10).join(render_reference_card(page) for page in REFERENCE_PAGES)}
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
    chart_id="coding-daily",
    title="Recent Coding Activity: Last 7 Days",
    lead="Daily commit counts for the last 7 days across all active coding project lines currently represented on this homepage.",
    projects=coding_activity_projects,
    metric_label="commits",
    buckets=load_daily_activity_buckets(coding_activity_projects, num_days=7),
    bucket_mode="daily",
)}

{render_activity_chart(
    chart_id="coding-weekly",
    title="Recent Coding Activity: Weekly Summary",
    lead="Weekly commit counts on origin/main for the last 8 weeks across all active coding project lines currently represented on this homepage.",
    projects=coding_activity_projects,
    metric_label="commits",
    buckets=load_weekly_activity_buckets(coding_activity_projects, num_weeks=8),
    bucket_mode="weekly",
)}

{render_activity_chart(
    chart_id="research-daily",
    title="Recent Research Archive Activity: Last 7 Days",
    lead="Daily path-scoped commit counts for the last 7 days across all active research archive lines represented on this homepage.",
    projects=research_activity_projects,
    metric_label="commits",
    buckets=load_daily_activity_buckets(research_activity_projects, num_days=7),
    bucket_mode="daily",
)}

{render_activity_chart(
    chart_id="research-weekly",
    title="Recent Research Archive Activity: Weekly Summary",
    lead="Weekly path-scoped commit counts in the public archive repo for the last 8 weeks across all active research archive lines represented on this homepage.",
    projects=research_activity_projects,
    metric_label="commits",
    buckets=load_weekly_activity_buckets(research_activity_projects, num_weeks=8),
    bucket_mode="weekly",
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
