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


@dataclass
class ProjectStatus:
    project_id: str
    display_name: str
    project_page_path: str
    dashboard_url: str | None
    experience_url: str | None
    repo_pushed_at: datetime
    status_label: str
    status_value: str
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
        dashboard_url=payload.get("dashboard_url"),
        experience_url=payload.get("experience_url"),
        repo_pushed_at=parse_datetime(payload["repo_pushed_at"]),
        status_label=payload["status_label"],
        status_value=payload["status_value"],
        active=bool(payload["active"]),
    )


def project_sentence(project: ProjectStatus) -> str:
    prefix = PROJECT_DESCRIPTIONS[project.project_id]
    parts = [
        prefix,
        f"Last repo update: {format_local_date(project.repo_pushed_at)}.",
        f"{project.status_label}: {project.status_value}.",
    ]
    if project.dashboard_url:
        parts.append(f"Dashboard: {project.dashboard_url}.")
    if project.experience_url:
        parts.append(f"Live experience: {project.experience_url}.")
    return " ".join(parts)


def render() -> str:
    manifests = {
        path.stem: load_project(path)
        for path in sorted(DATA_DIR.glob("*.json"))
    }
    projects = [
        manifests[project_id]
        for project_id in PROJECT_ORDER
        if project_id in manifests and manifests[project_id].active
    ]
    if not projects:
        raise SystemExit("No active project manifests found.")

    last_updated = max(project.repo_pushed_at for project in projects)
    project_items = "\n".join(
        f"""        <li>
            <a href="{html.escape(project.project_page_path)}">{html.escape(project.display_name)}</a>
            <span class="label">{html.escape(project_sentence(project))}</span>
        </li>"""
        for project in projects
    )

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Steven Woods Public Pages</title>
    <style>
        body {{
            font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
            line-height: 1.6;
            color: #333;
            max-width: 760px;
            margin: 40px auto;
            padding: 0 20px;
            background: #faf8f2;
        }}
        h1 {{
            margin-bottom: 0.4em;
            color: #1f2b1f;
        }}
        p {{
            margin-bottom: 1.2em;
        }}
        ul {{
            padding-left: 1.2rem;
        }}
        li {{
            margin-bottom: 1rem;
        }}
        a {{
            color: #0056b3;
        }}
        .label {{
            display: block;
            font-size: 0.95em;
            color: #666;
        }}
        .note {{
            padding: 14px 16px;
            margin-bottom: 1.4em;
            background: #f1eee5;
            border-left: 4px solid #b0a58c;
        }}
    </style>
</head>
<body>
    <h1>Steven Woods Public Pages</h1>
    <p>
        This site collects public documents and project links.
    </p>
    <p class="note">
        Repository work last updated: {html.escape(format_local_date(last_updated))}.
    </p>

    <ul>
        <li>
            <a href="academic.html">Academic ancestry</a>
            <span class="label">Direct advisor lineage with links to the Mathematics Genealogy Project.</span>
        </li>
        <li>
            <a href="patents-publications.html">Patents and publications</a>
            <span class="label">Selected books, patents, and academic publications.</span>
        </li>
{project_items}
    </ul>
</body>
</html>
"""


def main() -> None:
    OUTPUT.write_text(render())


if __name__ == "__main__":
    main()
