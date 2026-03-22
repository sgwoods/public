#!/usr/bin/env python3
"""Render patents-publications.html from a BibTeX source file."""

from __future__ import annotations

import html
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "data" / "publications.bib"
OUTPUT = ROOT / "patents-publications.html"


SECTION_ORDER = [
    ("books", "Books"),
    ("patents", "Patents"),
    ("publications", "Academic Publications"),
]

TYPE_TO_SECTION = {
    "book": "books",
    "booklet": "books",
    "patent": "patents",
    "article": "publications",
    "conference": "publications",
    "inbook": "publications",
    "incollection": "publications",
    "inproceedings": "publications",
    "manual": "publications",
    "mastersthesis": "publications",
    "misc": "publications",
    "phdthesis": "publications",
    "proceedings": "publications",
    "techreport": "publications",
    "unpublished": "publications",
}


LATEX_REPLACEMENTS = [
    (r"\\&", "&"),
    (r"\\%", "%"),
    (r"\\_", "_"),
    (r"\\#", "#"),
    (r"\\textendash", "-"),
    (r"\\textemdash", "--"),
    (r"\\textquotesingle", "'"),
    (r"\\textquotedbl", '"'),
    (r"\\ss\b", "ss"),
    (r"\\ae\b", "ae"),
    (r"\\AE\b", "AE"),
    (r"\\oe\b", "oe"),
    (r"\\OE\b", "OE"),
    (r"\\aa\b", "aa"),
    (r"\\AA\b", "AA"),
    (r"\\o\b", "o"),
    (r"\\O\b", "O"),
    (r"\\l\b", "l"),
    (r"\\L\b", "L"),
    (r"~", " "),
]

ACCENT_MAP = {
    "'": {
        "a": "a", "A": "A", "e": "e", "E": "E", "i": "i", "I": "I",
        "o": "o", "O": "O", "u": "u", "U": "U", "y": "y", "Y": "Y",
        "c": "c", "C": "C", "n": "n", "N": "N",
    },
    "`": {
        "a": "a", "A": "A", "e": "e", "E": "E", "i": "i", "I": "I",
        "o": "o", "O": "O", "u": "u", "U": "U",
    },
    "^": {
        "a": "a", "A": "A", "e": "e", "E": "E", "i": "i", "I": "I",
        "o": "o", "O": "O", "u": "u", "U": "U",
    },
    '"': {
        "a": "a", "A": "A", "e": "e", "E": "E", "i": "i", "I": "I",
        "o": "o", "O": "O", "u": "u", "U": "U", "y": "y", "Y": "Y",
    },
    "~": {
        "a": "a", "A": "A", "n": "n", "N": "N", "o": "o", "O": "O",
    },
    "c": {"c": "c", "C": "C"},
    "v": {
        "c": "c", "C": "C", "s": "s", "S": "S", "z": "z", "Z": "Z",
    },
}


@dataclass
class BibEntry:
    entry_type: str
    key: str
    fields: dict[str, str]


def skip_ws(text: str, index: int) -> int:
    while index < len(text) and text[index].isspace():
        index += 1
    return index


def read_balanced(text: str, index: int, opener: str, closer: str) -> tuple[str, int]:
    depth = 0
    start = index
    while index < len(text):
        char = text[index]
        if char == opener:
            depth += 1
        elif char == closer:
            depth -= 1
            if depth == 0:
                return text[start + 1:index], index + 1
        elif char == "\\":
            index += 1
        index += 1
    raise ValueError(f"Unterminated {opener}{closer} block in BibTeX source.")


def read_quoted(text: str, index: int) -> tuple[str, int]:
    start = index
    index += 1
    escaped = False
    while index < len(text):
        char = text[index]
        if char == '"' and not escaped:
            return text[start + 1:index], index + 1
        escaped = char == "\\" and not escaped
        if char != "\\":
            escaped = False
        index += 1
    raise ValueError("Unterminated quoted BibTeX string.")


def read_bare(text: str, index: int) -> tuple[str, int]:
    start = index
    while index < len(text) and text[index] not in ",}\n":
        index += 1
    return text[start:index].strip(), index


def parse_value(text: str, index: int) -> tuple[str, int]:
    index = skip_ws(text, index)
    if index >= len(text):
        return "", index
    if text[index] == "{":
        return read_balanced(text, index, "{", "}")
    if text[index] == '"':
        return read_quoted(text, index)
    return read_bare(text, index)


def parse_entries(text: str) -> list[BibEntry]:
    entries: list[BibEntry] = []
    index = 0
    while True:
        at = text.find("@", index)
        if at == -1:
            break
        type_match = re.match(r"@([A-Za-z]+)\s*([{(])", text[at:])
        if not type_match:
            index = at + 1
            continue
        entry_type = type_match.group(1).lower()
        opener = type_match.group(2)
        closer = "}" if opener == "{" else ")"
        cursor = at + type_match.end()
        body, index = read_balanced(text, cursor - 1, opener, closer)
        if entry_type in {"comment", "preamble", "string"}:
            continue
        comma = body.find(",")
        if comma == -1:
            continue
        key = body[:comma].strip()
        fields_text = body[comma + 1:]
        fields: dict[str, str] = {}
        pos = 0
        while pos < len(fields_text):
            pos = skip_ws(fields_text, pos)
            if pos >= len(fields_text):
                break
            if fields_text[pos] == ",":
                pos += 1
                continue
            name_match = re.match(r"([A-Za-z][A-Za-z0-9_-]*)\s*=", fields_text[pos:])
            if not name_match:
                next_comma = fields_text.find(",", pos)
                if next_comma == -1:
                    break
                pos = next_comma + 1
                continue
            name = name_match.group(1).lower()
            pos += name_match.end()
            value, pos = parse_value(fields_text, pos)
            fields[name] = value.strip()
            pos = skip_ws(fields_text, pos)
            if pos < len(fields_text) and fields_text[pos] == ",":
                pos += 1
        entries.append(BibEntry(entry_type=entry_type, key=key, fields=fields))
    return entries


def strip_outer_braces(value: str) -> str:
    trimmed = value.strip()
    while trimmed.startswith("{") and trimmed.endswith("}"):
        depth = 0
        balanced = True
        for index, char in enumerate(trimmed):
            if char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
                if depth == 0 and index != len(trimmed) - 1:
                    balanced = False
                    break
        if balanced and depth == 0:
            trimmed = trimmed[1:-1].strip()
        else:
            break
    return trimmed


def latex_to_text(value: str) -> str:
    text = strip_outer_braces(value)
    text = re.sub(r"\\([`'^\"~=.Hcuv])\s*\{([A-Za-z])\}", lambda m: ACCENT_MAP.get(m.group(1), {}).get(m.group(2), m.group(2)), text)
    text = re.sub(r"\\([`'^\"~=.Hcuv])\s*([A-Za-z])", lambda m: ACCENT_MAP.get(m.group(1), {}).get(m.group(2), m.group(2)), text)
    for pattern, replacement in LATEX_REPLACEMENTS:
        text = re.sub(pattern, replacement, text)
    text = re.sub(r"[{}]", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def format_person(name: str) -> str:
    clean = latex_to_text(name)
    if "," not in clean:
        return clean
    parts = [part.strip() for part in clean.split(",") if part.strip()]
    if len(parts) == 2:
        return f"{parts[1]} {parts[0]}"
    if len(parts) >= 3:
        return f"{parts[1]} {parts[2]} {parts[0]}".strip()
    return clean


def format_authors(value: str) -> str:
    names = [format_person(part) for part in re.split(r"\s+and\s+", value) if part.strip()]
    return ", ".join(names)


def section_for(entry: BibEntry) -> str:
    explicit = latex_to_text(entry.fields.get("section", "")).lower()
    if explicit in {"books", "patents", "publications"}:
        return explicit
    return TYPE_TO_SECTION.get(entry.entry_type, "publications")


def primary_link(entry: BibEntry) -> tuple[str, str] | None:
    url = latex_to_text(entry.fields.get("url", ""))
    doi = latex_to_text(entry.fields.get("doi", ""))
    label = latex_to_text(entry.fields.get("url_label", ""))
    if url:
        return url, label or default_link_label(entry)
    if doi:
        return f"https://doi.org/{doi}", label or "View publication"
    return None


def secondary_link(entry: BibEntry) -> tuple[str, str] | None:
    url = latex_to_text(entry.fields.get("secondary_url", ""))
    label = latex_to_text(entry.fields.get("secondary_url_label", ""))
    if url and label:
        return url, label
    return None


def archive_link(entry: BibEntry, field: str) -> tuple[str, str] | None:
    url = latex_to_text(entry.fields.get(field, ""))
    if not url:
        return None
    label = {
        "archive_pdf": "Archive PDF",
        "archive_ps": "Archive PS",
        "archive_landing": "Archive landing",
    }.get(field, "Archive link")
    return url, label


def default_link_label(entry: BibEntry) -> str:
    if section_for(entry) == "patents":
        return "View patent"
    if section_for(entry) == "books":
        return "View book"
    return "View publication"


def venue_text(entry: BibEntry) -> str:
    for field in ("journal", "booktitle", "publisher", "school", "institution", "howpublished", "note", "series"):
        value = latex_to_text(entry.fields.get(field, ""))
        if value:
            return value
    number = latex_to_text(entry.fields.get("number", ""))
    if number:
        return number
    return entry.entry_type.title()


def render_button_link(href: str, label: str, ghost: bool = False) -> str:
    classes = "button button--ghost" if ghost else "button"
    return f'                        <a class="{classes}" href="{html.escape(href)}">{html.escape(label)}</a>'


def render_button_note(label: str) -> str:
    return f'                        <span class="button button--ghost button--disabled">{html.escape(label)}</span>'


def render_entry(entry: BibEntry) -> str:
    title = html.escape(latex_to_text(entry.fields.get("title", entry.key)))
    authors = html.escape(format_authors(entry.fields.get("author", "")))
    venue = html.escape(venue_text(entry))
    year = html.escape(latex_to_text(entry.fields.get("year", "")))
    primary = primary_link(entry)
    secondary = secondary_link(entry)
    archive_pdf = archive_link(entry, "archive_pdf")
    archive_ps = archive_link(entry, "archive_ps")
    archive_landing = archive_link(entry, "archive_landing")

    links: list[str] = []
    if primary:
        href, label = primary
        links.append(render_button_link(href, label))
    if secondary:
        href, label = secondary
        links.append(render_button_link(href, label, ghost=True))

    archive_links: list[str] = []
    if section_for(entry) == "publications":
        if archive_landing:
            href, label = archive_landing
            archive_links.append(render_button_link(href, label, ghost=True))
        if archive_pdf:
            href, label = archive_pdf
            archive_links.append(render_button_link(href, label, ghost=True))
        else:
            archive_links.append(render_button_note("PDF n/a"))
        if archive_ps:
            href, label = archive_ps
            archive_links.append(render_button_link(href, label, ghost=True))
        else:
            archive_links.append(render_button_note("PS n/a"))

    blocks = [
        '                <article class="entry">',
        f'                    <h3 class="entryTitle">{title}</h3>',
        f'                    <span class="entryMeta">{authors}. <em>{venue}</em> <strong>{year}</strong>.</span>',
    ]
    if links:
        blocks.extend([
            '                    <div class="entryLinks">',
            *links,
            '                    </div>',
        ])
    if archive_links:
        blocks.extend([
            '                    <div class="entryLinks">',
            *archive_links,
            '                    </div>',
        ])
    blocks.append('                </article>')
    return "\n".join(blocks)


def render_section(entries: list[BibEntry], section_id: str, label: str) -> str:
    if not entries:
        return ""
    items = "\n".join(render_entry(entry) for entry in entries)
    return "\n".join(
        [
            '        <section class="panel">',
            f"            <h2>{label}</h2>",
            '            <div class="entryGrid">',
            items,
            '            </div>',
            '        </section>',
        ]
    )


def render_page(entries: list[BibEntry]) -> str:
    grouped = {
        section_id: [entry for entry in entries if section_for(entry) == section_id]
        for section_id, _ in SECTION_ORDER
    }
    sections = "\n\n".join(
        render_section(grouped[section_id], section_id, label)
        for section_id, label in SECTION_ORDER
        if grouped[section_id]
    )
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Steven Gregory Woods - Publications &amp; Patents</title>
    <link rel="stylesheet" href="assets/public-site.css">
</head>
<body>
    <main class="shell shell--narrow">
        <!-- Generated by tools/render_publications.py from data/publications.bib -->
        <section class="hero">
            <div class="heroTop">
                <span class="eyebrow">Reference Page</span>
                <a class="heroHomeLink" href="index.html">Steven Woods</a>
            </div>
            <h1>Patents and Publications</h1>
            <p class="lead">
                Curated active reference page for selected books, patents, and academic publications associated with Steven Gregory Woods.
            </p>
            <div class="breadcrumbs">
                <a class="button button--ghost" href="style-guide.html">Open style guide</a>
                <a class="button button--ghost" href="https://www.researchgate.net/profile/Steven-Woods">Open ResearchGate</a>
                <a class="button button--ghost" href="Spectra/Html/Publication-Archive/index.html">Open archive reference</a>
            </div>
        </section>

        <section class="panel">
            <div class="notePanel">
                <strong>Source of truth:</strong> This page is rebuilt from <code>public/data/publications.bib</code>.
                Canonical publisher or DOI links remain primary, while recovered Spectra archive PS/PDF artifacts are surfaced here when they are available.
            </div>
        </section>

{sections}

        <section class="panel">
            <p class="footer">
                Active publications are rendered from a shared bibliography source and linked back to the recovered Spectra archive when matching artifacts exist, so the active page and archive references do not drift separately.
            </p>
        </section>
    </main>
</body>
</html>
"""


def main() -> None:
    entries = parse_entries(SOURCE.read_text())
    OUTPUT.write_text(render_page(entries))


if __name__ == "__main__":
    main()
