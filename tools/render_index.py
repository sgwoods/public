#!/usr/bin/env python3
"""Render public/index.html from project status manifests."""

from __future__ import annotations

import html
import json
from dataclasses import dataclass
from datetime import date, datetime, time, timedelta, timezone
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

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
    "star-swarm",
    "confidential-project",
    "financial-planner",
    "woods-financial-dashboard",
    "ai-dystopia-quotes",
    "ai-briefing",
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
CODING_LABELS = {"mmath-renovation": "Abtweak", "phd-renovation": "CSP", "aurora-galactica": "Aurora"}

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
    repo_pushed_at: datetime | None
    status_generated_at: datetime
    status_label: str
    status_value: str
    focus_label: str
    focus_value: str
    person_context: str | None
    timeline_label: str | None
    active: bool
    source_commit: str | None = None
    source_dirty: bool = False
    private_metadata: dict | None = None


@dataclass
class ActivityBucket:
    start: datetime
    end: datetime
    label: str
    counts: dict[str, int | None]

    @property
    def total(self) -> int | None:
        return None if None in self.counts.values() else self.known_total

    @property
    def known_total(self) -> int:
        return sum(value for value in self.counts.values() if value is not None)


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
    import private_status
    if (payload.get("status_sync") == "private-summary-v1"
            or payload.get("project_id") in private_status.PROJECT_PAGES
            or "private_metadata" in payload):
        private_status.validate(payload)
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
        repo_pushed_at=parse_datetime(payload["repo_pushed_at"]) if payload["repo_pushed_at"] else None,
        status_generated_at=parse_datetime(payload["status_generated_at"]),
        status_label=status_label,
        status_value=status_value,
        focus_label=focus_label,
        focus_value=focus_value,
        person_context=payload.get("person_context"),
        timeline_label=timeline_span.get("label"),
        active=bool(payload["active"]),
        source_commit=payload.get("source_commit"),
        source_dirty=bool(payload.get("source_dirty")),
        private_metadata=payload.get("private_metadata"),
    )

def sort_key(project: ProjectStatus) -> tuple[int, str]:
    if project.project_id in PROJECT_ORDER:
        return (PROJECT_ORDER.index(project.project_id), project.display_name.lower())
    return (len(PROJECT_ORDER), project.display_name.lower())


def project_rank(project: ProjectStatus) -> tuple[datetime, datetime, int, int, str]:
    return (
        project.status_generated_at,
        project.repo_pushed_at or datetime.min.replace(tzinfo=timezone.utc),
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
            project.repo_pushed_at or datetime.min.replace(tzinfo=timezone.utc),
            project.project_id,
        ) > (
            existing.status_generated_at,
            existing.repo_pushed_at or datetime.min.replace(tzinfo=timezone.utc),
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


def current_week_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    start_date = local_today - timedelta(days=local_today.weekday())
    return datetime.combine(start_date, time.min, tzinfo=LOCAL_TZ)


def current_day_start(today: date | None = None) -> datetime:
    local_today = today or datetime.now(LOCAL_TZ).date()
    return datetime.combine(local_today, time.min, tzinfo=LOCAL_TZ)


def load_activity_snapshot() -> dict:
    path = ROOT / "data/shared/repository-activity.json"
    return json.loads(path.read_text()) if path.exists() else {"projects": {}}


def activity_count(snapshot: dict, project: dict, start: datetime, end: datetime) -> int | None:
    row = snapshot.get("projects", {}).get(project["project_id"], {})
    if (row.get("state") != "ok" or row.get("repo") != project["repo"]
            or row.get("paths") != project["pathspecs"]
            or row.get("exclude_paths", []) != project.get("exclude_paths", [])):
        return None
    if parse_datetime(row["window_start"]) > start or parse_datetime(row["checked_at"]) < start:
        return None
    return sum(start <= parse_datetime(commit["date"]) < end for commit in row["commits"])


def load_weekly_activity_buckets(projects: list[dict[str, Any]], num_weeks: int = 8) -> list[ActivityBucket]:
    start = current_week_start() - timedelta(weeks=num_weeks - 1)
    weeks: list[ActivityBucket] = []
    snapshot = load_activity_snapshot()
    for offset in range(num_weeks):
        week_start = start + timedelta(weeks=offset)
        week_end = week_start + timedelta(weeks=1)
        counts: dict[str, int | None] = {}
        for project in projects:
            counts[project["project_id"]] = activity_count(snapshot, project, week_start, week_end)
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
    snapshot = load_activity_snapshot()
    for offset in range(num_days):
        day_start = start + timedelta(days=offset)
        day_end = day_start + timedelta(days=1)
        counts: dict[str, int | None] = {}
        for project in projects:
            counts[project["project_id"]] = activity_count(snapshot, project, day_start, day_end)
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
        if project.repo_url and urlparse(project.repo_url).netloc == "github.com":
            repo = urlparse(project.repo_url).path.strip("/").removesuffix(".git")
            activity_projects.append({
                "label": CODING_LABELS.get(project.project_id, project.display_name), "project_id": project.project_id,
                "repo": repo, "pathspecs": [], "color_top": color_top, "color_bottom": color_bottom,
            })
    return activity_projects


def build_research_activity_projects(projects: list[ProjectStatus]) -> list[dict[str, Any]]:
    activity_projects: list[dict[str, Any]] = []
    folder_by_id = research_manifest_folder_by_id()
    for index, project in enumerate(projects):
        color_top, color_bottom = activity_color(index)
        folder_name = folder_by_id.get(project.project_id)
        folder = ROOT / folder_name if folder_name else None
        page_path = urlparse(project.project_page_href).path.removeprefix("/public/").lstrip("/")
        pathspecs = [page_path]
        if folder and folder.exists():
            pathspecs.insert(0, folder_name)
        else:
            fallback_folder = page_path.removesuffix(".html")
            if (ROOT / fallback_folder).exists():
                pathspecs.insert(0, fallback_folder)

        activity_projects.append(
            {
                "label": project.display_name,
                "project_id": project.project_id,
                "repo": "sgwoods/public",
                "pathspecs": pathspecs,
                "exclude_paths": [f"{folder_name}/project-manifest.json"] if folder_name else [],
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
    ceiling = nice_upper_bound(max(bucket.known_total for bucket in buckets))
    midpoint = ceiling // 2
    snapshot = load_activity_snapshot()
    checks = [row["checked_at"] for project in projects
              if (row := snapshot.get("projects", {}).get(project["project_id"], {})).get("checked_at")]
    chart_config = {
        "chart_id": chart_id,
        "generated_at": min(checks, key=parse_datetime) if checks else None,
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
                "repo": project["repo"],
                "paths": project.get("pathspecs", []),
                "exclude_paths": project.get("exclude_paths", []),
                "color_top": project["color_top"],
                "color_bottom": project["color_bottom"],
            }
            for project in projects
        ],
    }
    legend = []
    for project in projects:
        values = [bucket.counts[project["project_id"]] for bucket in buckets]
        total = "Unavailable" if None in values else str(sum(values))
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
            height = ((count or 0) / ceiling) * 100
            count_label = "Unavailable" if count is None else str(count)
            segments.append(
                f"""                                <span class="activitySegment" data-activity-project="{project["project_id"]}" style="height: {height:.2f}%; --activity-top: {project["color_top"]}; --activity-bottom: {project["color_bottom"]};" title="{html.escape(project["label"])}: {count_label} {html.escape(metric_label)}"></span>"""
            )
        total_label = "N/A" if bucket.total is None else str(bucket.total)
        columns.append(
            f"""                    <div class="activityWeek" data-activity-week="{bucket.start.isoformat()}">
                        <div class="activityColumn">
                            <div class="activityStack" aria-label="{html.escape(bucket.label)}: {total_label} total {html.escape(metric_label)}">
{chr(10).join(segments)}
                            </div>
                        </div>
                        <div class="activityTotal" data-activity-total>{total_label}</div>
                        <div class="activityLabel">{html.escape(bucket.label)}</div>
                    </div>"""
        )

    chart_config_json = json.dumps(chart_config).replace("</", "<\\/")
    generated_label = format_local_datetime(parse_datetime(chart_config["generated_at"])) if chart_config["generated_at"] else "Not yet measured"

    return f"""        <section class="panel" id="activity-{chart_id}" data-activity-chart data-activity-chart-id="{chart_id}">
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
            <p class="footer"><strong>History checked:</strong> <span data-activity-last-refreshed>{html.escape(generated_label)}</span> (America/Toronto)</p>
            <p class="footer" data-activity-status>Published GitHub history snapshot. Unavailable history is N/A, never zero. Current periods are partial; commits are not a measure of effort, quality, or releases.</p>
            <p class="footer"><a href="data/shared/repository-activity.json">History data</a> · <a href="PORTFOLIO-METRICS.md">Metric definitions</a> · <a href="PORTFOLIO-AUDIT-2026-10-22.md">October 22 audit</a></p>
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
    observation_path = ROOT / "data/shared/repository-observations.json"
    observations = json.loads(observation_path.read_text()).get("projects", {}) if observation_path.exists() else {}
    observation = observations.get(project.project_id, {})
    checked = observation.get("checked_at")
    checked_text = format_local_datetime(parse_datetime(checked)) if checked else "Not observed"
    comparison = observation_label(observation)
    if project.source_dirty and observation.get("state") != "check_failed":
        comparison = "Export included uncommitted changes; review source"
    elif project.source_commit and observation.get("state") not in {"check_failed", "not_observed"} and observation.get("snapshot_commit") != project.source_commit:
        comparison = "New snapshot; repository comparison pending"
    source_label = "Snapshot source date" if project.source_commit else "Reported snapshot date"
    details = [
        f"<div><strong>{source_label}</strong> {html.escape(format_local_date(project.repo_pushed_at)) if project.repo_pushed_at else 'Not reported'}</div>",
        f"<div><strong>Status exported</strong> {html.escape(format_local_datetime(project.status_generated_at))}</div>",
        f"<div><strong>Repository checked</strong> {html.escape(checked_text)}</div>",
        f"<div><strong>Source comparison</strong> {html.escape(comparison)}</div>",
        f"<div><strong>{html.escape(project.status_label)}</strong> {html.escape(project.status_value)}</div>",
        f"<div><strong>{html.escape(project.focus_label)}</strong> {html.escape(project.focus_value)}</div>",
    ]
    if project.private_metadata:
        import private_status
        private_details = private_status.details(project.private_metadata, format_local_datetime)
        details = [f"<div><strong>{html.escape(label)}</strong> {html.escape(value)}</div>"
                   for label, value in private_details] + [details[1], details[-2], details[-1]]
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


def observation_label(observation: dict) -> str:
    state = observation.get("state", "not_observed")
    labels = {"matches": "Matches exported source", "different_commit": "Different source commit; review export",
              "content_matches": "Archive content matches snapshot", "content_changed": "Archive content changed; review snapshot",
              "dirty_snapshot": "Export included uncommitted changes; review source",
              "newer_commit": "Newer than reported snapshot", "legacy_unverified": "Legacy snapshot; commit identity unavailable",
              "awaiting_export": "Awaiting first published export",
              "not_observed": "No public repository observation", "check_failed": "Check failed; retained observation"}
    checked = observation.get("checked_at")
    stale = not checked or datetime.now(timezone.utc) - parse_datetime(checked) > timedelta(days=8)
    return labels.get(state, "Comparison unavailable") + (" (check over eight days old)" if stale and state != "not_observed" else "")


def render_observations() -> str:
    path = ROOT / "data/shared/repository-observations.json"
    if not path.exists():
        return ""
    data = json.loads(path.read_text())
    rows = []
    dates = []
    for observation in data.get("projects", {}).values():
        state = observation["state"]
        checked = observation.get("checked_at")
        label = observation_label(observation)
        date_value = observation.get("commit_date")
        if date_value:
            dates.append(parse_datetime(date_value))
        activity = html.escape(format_local_date(parse_datetime(date_value))) if date_value else ("Excluded" if state == "not_observed" else "Unknown")
        if observation.get("commit_url"):
            activity = f'<a href="{html.escape(observation["commit_url"], quote=True)}">{activity}</a>'
        checked_text = html.escape(format_local_datetime(parse_datetime(checked))) if checked else "Not observed"
        rows.append(f"<tr><td>{html.escape(observation['display_name'])}</td><td>{activity}</td><td>{html.escape(label)}</td><td>{checked_text}</td></tr>")
    latest = html.escape(format_local_date(max(dates))) if dates else "Unknown"
    return f'''<section class="panel" id="repository-activity">
            <h2>Repository Activity</h2>
            <p>Latest observed public commit: <strong>{latest}</strong>. Observations track public default branches and archive-specific paths, independently of published releases. Scoped commits can include metadata edits; they are not evidence of new research. Checks older than eight days are marked stale. All times use America/Toronto.</p>
            <div class="repositoryTable"><table><thead><tr><th>Project</th><th>Commit date</th><th>Snapshot comparison</th><th>Last successful check</th></tr></thead><tbody>{''.join(rows)}</tbody></table></div>
            <p><a href="data/shared/repository-observations.json">Observation data</a> · <a href="PROJECT-STATUS-CONTRACT.md">Status contract and maintenance</a></p>
        </section>'''


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

    source_dates = [project.repo_pushed_at for project in projects if project.repo_pushed_at]
    latest_project_repo_update = max(source_dates) if source_dates else None
    rendered_at = datetime.now(LOCAL_TZ)
    project_cards = "\n".join(render_project_card(project) for project in projects)
    project_manifest_config = {
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
                    <span class="metaLabel">Latest Published Snapshot Source</span>
                    <span class="metaValue" data-project-last-updated>{html.escape(format_local_date(latest_project_repo_update)) if latest_project_repo_update else 'Not reported'}</span>
                    <div class="metaNote">Newest source date among the published snapshots, not a freshness claim for every project. Each card shows its own source, export, and check dates. See the <a href="project-suite-overview.html">portfolio review</a>.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Homepage Rendered</span>
                    <span class="metaValue">{html.escape(format_local_datetime(rendered_at))}</span>
                    <div class="metaNote">When this index page was rendered from the manifests in this repository.</div>
                </div>
            </div>
        </section>

        {render_observations()}

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
    lead="Daily committer-date counts from public source repositories. Private project summaries are excluded. Current periods are partial.",
    projects=coding_activity_projects,
    metric_label="commits",
    buckets=load_daily_activity_buckets(coding_activity_projects, num_days=7),
    bucket_mode="daily",
)}

{render_activity_chart(
    chart_id="coding-weekly",
    title="Recent Coding Activity: Weekly Summary",
    lead="Last 8 weeks of public default-branch commits, counted by committer date. Includes merges; source code activity is separate from release publication.",
    projects=coding_activity_projects,
    metric_label="commits",
    buckets=load_weekly_activity_buckets(coding_activity_projects, num_weeks=8),
    bucket_mode="weekly",
)}

{render_activity_chart(
    chart_id="research-daily",
    title="Recent Research Archive Activity: Last 7 Days",
    lead="Daily commits changing archive files or their public pages. Archive project-manifest-only edits are excluded. Counts are not a measure of research progress.",
    projects=research_activity_projects,
    metric_label="commits",
    buckets=load_daily_activity_buckets(research_activity_projects, num_days=7),
    bucket_mode="daily",
)}

{render_activity_chart(
    chart_id="research-weekly",
    title="Recent Research Archive Activity: Weekly Summary",
    lead="Last 8 weeks of archive file commits, excluding project-manifest-only edits and deduplicating overlapping paths within each archive. One shared commit may touch several archives.",
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
