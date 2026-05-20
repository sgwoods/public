#!/usr/bin/env python3
"""Refresh shared public coordination surfaces from manifests and suite notes."""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path

import render_index
import render_project_suite_overview


ROOT = render_index.ROOT

VOLATILE_INDEX_PATTERNS = (
    (
        re.compile(
            r'(<span class="metaLabel">Homepage Rendered</span>\s*<span class="metaValue">).*?(</span>)',
            re.DOTALL,
        ),
        r"\1__VOLATILE_HOMEPAGE_RENDERED__\2",
    ),
    (
        re.compile(r"(<span data-activity-last-refreshed>).*?(</span>)", re.DOTALL),
        r"\1__VOLATILE_ACTIVITY_REFRESHED__\2",
    ),
    (
        re.compile(r'("generated_at":\s*")[^"]+(")'),
        r'\1__VOLATILE_GENERATED_AT__\2',
    ),
)


@dataclass(frozen=True)
class RenderedOutput:
    path: Path
    contents: str
    compare_mode: str = "exact"


def load_context() -> tuple[dict, list[render_index.ProjectStatus]]:
    notes = render_project_suite_overview.load_notes()
    projects = render_project_suite_overview.load_projects()
    render_project_suite_overview.validate(notes, projects)
    return notes, projects


def build_outputs(notes: dict, projects: list[render_index.ProjectStatus]) -> list[RenderedOutput]:
    return [
        RenderedOutput(
            path=render_project_suite_overview.MARKDOWN_OUTPUT,
            contents=render_project_suite_overview.render_markdown(notes, projects),
        ),
        RenderedOutput(
            path=render_project_suite_overview.HTML_OUTPUT,
            contents=render_project_suite_overview.render_html(notes, projects),
        ),
        RenderedOutput(
            path=render_index.OUTPUT,
            contents=render_index.render(),
            compare_mode="index",
        ),
    ]


def normalize_for_compare(contents: str, compare_mode: str) -> str:
    if compare_mode != "index":
        return contents

    normalized = contents
    for pattern, replacement in VOLATILE_INDEX_PATTERNS:
        normalized = pattern.sub(replacement, normalized)
    return normalized


def relative_path(path: Path) -> str:
    return str(path.relative_to(ROOT))


def stale_outputs(outputs: list[RenderedOutput]) -> list[Path]:
    stale: list[Path] = []
    for output in outputs:
        if not output.path.exists():
            stale.append(output.path)
            continue
        existing = output.path.read_text()
        if normalize_for_compare(existing, output.compare_mode) != normalize_for_compare(
            output.contents,
            output.compare_mode,
        ):
            stale.append(output.path)
    return stale


def write_outputs(outputs: list[RenderedOutput]) -> tuple[list[Path], list[Path]]:
    updated: list[Path] = []
    unchanged: list[Path] = []

    for output in outputs:
        existing = output.path.read_text() if output.path.exists() else None
        if existing == output.contents:
            unchanged.append(output.path)
            continue
        output.path.write_text(output.contents)
        updated.append(output.path)

    return updated, unchanged


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Validate the project-suite notes against active manifests and refresh "
            "the shared public coordination surfaces."
        )
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help=(
            "Do not write files; exit non-zero if PROJECT-SUITE-OVERVIEW.md, "
            "project-suite-overview.html, or index.html are out of sync."
        ),
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    notes, projects = load_context()
    outputs = build_outputs(notes, projects)

    print(
        "Validated project-suite notes against "
        f"{len(projects)} active project manifests."
    )

    if args.check:
        stale = stale_outputs(outputs)
        if stale:
            print("Generated coordination surfaces are out of sync:")
            for path in stale:
                print(f"  - {relative_path(path)}")
            raise SystemExit(1)
        print("Generated coordination surfaces are in sync.")
        return

    updated, unchanged = write_outputs(outputs)
    if updated:
        print("Updated:")
        for path in updated:
            print(f"  - {relative_path(path)}")
    if unchanged:
        print("Already current:")
        for path in unchanged:
            print(f"  - {relative_path(path)}")


if __name__ == "__main__":
    main()
