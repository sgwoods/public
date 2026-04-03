#!/usr/bin/env python3
"""Render browsable source indexes for the Steven Woods research project."""

from __future__ import annotations

import html
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
PROJECT_DIR = ROOT / "steven-woods-research"
MANIFEST_PATH = PROJECT_DIR / "source-manifest.json"
OUTPUT_DIR = PROJECT_DIR / "sources"

CATEGORY_META = {
    "appearance": {
        "slug": "appearances",
        "title": "Talks, Interviews, and Podcasts",
        "description": "Public appearances including podcasts, event talks, keynote videos, and interview pieces centered on Steven Woods.",
    },
    "profile": {
        "slug": "profiles",
        "title": "Profiles and Recognition",
        "description": "Institutional profiles, awards, transition pieces, and other biographical sources that frame Steven Woods directly.",
    },
    "media-mention": {
        "slug": "media-mentions",
        "title": "Media Mentions",
        "description": "Third-party coverage and feature pieces that mention or feature Steven Woods in company or ecosystem context.",
    },
}


@dataclass
class SourceRecord:
    source_id: str
    title: str
    source_type: str
    company_context: str
    person_relevance: str
    date_display: str
    date_sort: str
    canonical_url: str | None
    archive_local: str | None
    archive_web: str | None
    notes: str
    tags: list[str]


def load_sources() -> list[SourceRecord]:
    payload: dict[str, Any] = json.loads(MANIFEST_PATH.read_text())
    records = []
    for item in payload["sources"]:
        if item.get("status") != "approved":
            continue
        records.append(
            SourceRecord(
                source_id=item["source_id"],
                title=item["title"],
                source_type=item["source_type"],
                company_context=item.get("company_context") or "Cross-company",
                person_relevance=item.get("person_relevance") or "",
                date_display=item["date"]["display"],
                date_sort=item["date"]["sort"],
                canonical_url=item.get("urls", {}).get("canonical"),
                archive_local=item.get("urls", {}).get("archive_local"),
                archive_web=item.get("urls", {}).get("archive_web"),
                notes=item.get("notes") or "",
                tags=item.get("tags") or [],
            )
        )
    return sorted(records, key=lambda record: (record.date_sort, record.title.lower()), reverse=True)


def link_button(href: str, label: str, ghost: bool = False, new_tab: bool = False) -> str:
    classes = "button button--ghost" if ghost else "button"
    extra = ' target="_blank" rel="noopener noreferrer"' if new_tab else ""
    return f'<a class="{classes}" href="{html.escape(href)}"{extra}>{html.escape(label)}</a>'


def viewer_button(href: str, label: str, ghost: bool = False) -> str:
    classes = "button button--ghost inlineViewerTrigger" if ghost else "button inlineViewerTrigger"
    return (
        f'<button class="{classes}" type="button" '
        f'data-inline-src="{html.escape(href)}" data-inline-title="{html.escape(label)}">'
        f"{html.escape(label)}</button>"
    )


def render_entry(record: SourceRecord, prefix: str = "../") -> str:
    buttons = []
    if record.archive_local:
        archive_href = prefix + record.archive_local
        buttons.append(viewer_button(archive_href, "View archived copy here"))
        buttons.append(link_button(archive_href, "Open archived copy", ghost=True, new_tab=True))
    if record.archive_web:
        buttons.append(viewer_button(record.archive_web, "View archive here", ghost=bool(record.archive_local)))
        buttons.append(link_button(record.archive_web, "Open archive", ghost=True, new_tab=True))
    if record.canonical_url:
        buttons.append(viewer_button(record.canonical_url, "View source here", ghost=bool(record.archive_local or record.archive_web)))
        buttons.append(link_button(record.canonical_url, "Open source", ghost=True, new_tab=True))

    tags = " ".join(
        f'<span class="tag">{html.escape(tag)}</span>'
        for tag in record.tags
    )
    notes = f'<p class="footer">{html.escape(record.notes)}</p>' if record.notes else ""
    tags_row = f'<div class="tagRow">{tags}</div>' if tags else ""
    return f"""                <article class="entry">
                    <h3 class="entryTitle">{html.escape(record.title)}</h3>
                    <span class="entryMeta"><strong>Date</strong> {html.escape(record.date_display)} <strong>Context</strong> {html.escape(record.company_context)}</span>
                    <p>{html.escape(record.person_relevance)}</p>
                    {tags_row}
                    {notes}
                    <div class="entryLinks">
                        {' '.join(buttons)}
                    </div>
                </article>"""


def render_category_page(source_type: str, records: list[SourceRecord]) -> str:
    meta = CATEGORY_META[source_type]
    entries = "\n".join(render_entry(record) for record in records)
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{html.escape(meta["title"])} | Steven Woods Research</title>
    <link rel="stylesheet" href="../../assets/public-site.css">
    <style>
        :root {{
            --bg: #0f1118;
            --bg2: #1d2f45;
            --panel-bg: rgba(16, 20, 29, 0.76);
            --panel-glow: rgba(104, 205, 255, 0.18);
            --card-bg: rgba(255, 255, 255, 0.05);
            --card-border: rgba(196, 225, 255, 0.14);
            --panel-border: rgba(124, 181, 255, 0.22);
            --text: #f3f7ff;
            --muted: #c8d6ea;
            --muted-strong: #f5fbff;
        }}

        body {{
            background:
                radial-gradient(circle at top left, rgba(124, 181, 255, 0.18), transparent 24%),
                radial-gradient(circle at top right, rgba(98, 214, 202, 0.14), transparent 28%),
                linear-gradient(160deg, var(--bg), var(--bg2));
        }}

        .tagRow {{
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 12px;
        }}

        .tag {{
            display: inline-flex;
            align-items: center;
            padding: 7px 11px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(196, 225, 255, 0.14);
            color: var(--muted-strong);
            font-size: 12px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }}

        .inlineViewer {{
            width: min(1100px, calc(100vw - 32px));
            border: 1px solid rgba(124, 181, 255, 0.22);
            border-radius: 24px;
            padding: 0;
            background:
                linear-gradient(160deg, rgba(16, 20, 29, 0.96), rgba(11, 16, 24, 0.92)),
                radial-gradient(circle at 20% 0%, rgba(104, 205, 255, 0.12), transparent 32%);
            color: var(--text);
        }}

        .inlineViewer::backdrop {{
            background: rgba(2, 7, 14, 0.72);
        }}

        .inlineViewerHeader {{
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 18px 22px;
            border-bottom: 1px solid rgba(196, 225, 255, 0.12);
        }}

        .inlineViewerTitle {{
            margin: 0;
            font-size: 16px;
            color: var(--muted-strong);
        }}

        .inlineViewerActions {{
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }}

        .inlineViewerFrame {{
            display: block;
            width: 100%;
            height: min(78vh, 920px);
            border: 0;
            background: white;
            border-bottom-left-radius: 24px;
            border-bottom-right-radius: 24px;
        }}
    </style>
</head>
<body>
    <main class="shell shell--narrow">
        <section class="hero">
            <div class="heroTop">
                <div>
                    <span class="eyebrow">Collected Content</span>
                    <h1>{html.escape(meta["title"])}</h1>
                </div>
                <a class="heroHomeLink" href="../index.html">Steven Woods Research</a>
            </div>
            <p class="lead">{html.escape(meta["description"])}</p>
            <div class="meta">
                <div class="metaCard">
                    <span class="metaLabel">Entries</span>
                    <span class="metaValue">{len(records)}</span>
                    <div class="metaNote">Approved items currently surfaced from the project source manifest.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Source Type</span>
                    <span class="metaValue">{html.escape(source_type)}</span>
                    <div class="metaNote">Each entry carries a date, a short summary, and direct source/archive links.</div>
                </div>
            </div>
            <div class="links">
                {link_button("index.html", "All source indexes")}
                {link_button("../source-manifest.json", "Source manifest", ghost=True)}
            </div>
        </section>

        <section class="panel">
            <h2>Collected Items</h2>
            <div class="entryGrid">
{entries}
            </div>
        </section>
    </main>
    <dialog class="inlineViewer" id="inline-viewer">
        <div class="inlineViewerHeader">
            <h2 class="inlineViewerTitle" id="inline-viewer-title">Content viewer</h2>
            <div class="inlineViewerActions">
                <a class="button button--ghost" id="inline-viewer-open" href="#" target="_blank" rel="noopener noreferrer">Open separately</a>
                <button class="button button--ghost" type="button" id="inline-viewer-close">Close</button>
            </div>
        </div>
        <iframe class="inlineViewerFrame" id="inline-viewer-frame" title="Inline content viewer" loading="lazy"></iframe>
    </dialog>
    <script>
        const viewer = document.getElementById("inline-viewer");
        const viewerFrame = document.getElementById("inline-viewer-frame");
        const viewerTitle = document.getElementById("inline-viewer-title");
        const viewerOpen = document.getElementById("inline-viewer-open");
        const viewerClose = document.getElementById("inline-viewer-close");

        for (const trigger of document.querySelectorAll(".inlineViewerTrigger")) {{
            trigger.addEventListener("click", () => {{
                const src = trigger.dataset.inlineSrc;
                const title = trigger.dataset.inlineTitle || "Content viewer";
                viewerTitle.textContent = title;
                viewerFrame.src = src;
                viewerOpen.href = src;
                viewer.showModal();
            }});
        }}

        viewerClose.addEventListener("click", () => {{
            viewer.close();
            viewerFrame.src = "";
        }});

        viewer.addEventListener("close", () => {{
            viewerFrame.src = "";
        }});
    </script>
</body>
</html>
"""


def render_index_page(sources_by_type: dict[str, list[SourceRecord]]) -> str:
    cards = []
    for source_type, meta in CATEGORY_META.items():
        records = sources_by_type.get(source_type, [])
        cards.append(
            f"""                <article class="card">
                    <h3>{html.escape(meta["title"])}</h3>
                    <p>{html.escape(meta["description"])}</p>
                    <div class="detailList">
                        <div><strong>Entries</strong> {len(records)}</div>
                        <div><strong>Format</strong> Date, summary, inline view when possible, and separate-open links</div>
                    </div>
                    <div class="links">
                        {link_button(f'{meta["slug"]}.html', "Open index")}
                    </div>
                </article>"""
        )

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collected Content Indexes | Steven Woods Research</title>
    <link rel="stylesheet" href="../../assets/public-site.css">
</head>
<body>
    <main class="shell shell--narrow">
        <section class="hero">
            <div class="heroTop">
                <div>
                    <span class="eyebrow">Collected Content</span>
                    <h1>Steven Woods Research Indexes</h1>
                </div>
                <a class="heroHomeLink" href="../index.html">Steven Woods Research</a>
            </div>
            <p class="lead">Browsable category indexes for the approved Steven Woods source set. Each category page exposes dates, short summaries, inline viewing where practical, and direct source or archive links.</p>
            <div class="links">
                {link_button("../source-manifest.json", "Source manifest")}
                {link_button("../research/media-sources-review.md", "Review ledger", ghost=True)}
            </div>
        </section>

        <section class="panel">
            <h2>Categories</h2>
            <div class="grid">
{''.join(cards)}
            </div>
        </section>
    </main>
</body>
</html>
"""


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    sources = load_sources()
    sources_by_type: dict[str, list[SourceRecord]] = {key: [] for key in CATEGORY_META}
    for source in sources:
        if source.source_type in sources_by_type:
            sources_by_type[source.source_type].append(source)

    (OUTPUT_DIR / "index.html").write_text(render_index_page(sources_by_type))
    for source_type, records in sources_by_type.items():
        slug = CATEGORY_META[source_type]["slug"]
        (OUTPUT_DIR / f"{slug}.html").write_text(render_category_page(source_type, records))


if __name__ == "__main__":
    main()
