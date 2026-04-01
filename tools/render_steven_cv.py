#!/usr/bin/env python3
"""Render a one-page Steven Woods CV in text, PostScript, and PDF."""

from __future__ import annotations

import json
import subprocess
import textwrap
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "steven-woods-research" / "research" / "baseline-identity.json"
TXT_OUTPUT = ROOT / "steven-woods-cv.txt"
PS_OUTPUT = ROOT / "steven-woods-cv.ps"
PDF_OUTPUT = ROOT / "steven-woods-cv.pdf"


def wrap(text: str, width: int) -> list[str]:
    return textwrap.wrap(text, width=width, break_long_words=False, break_on_hyphens=False)


def build_sections(data: dict) -> list[tuple[str, str]]:
    sections: list[tuple[str, str]] = []
    sections.append(("name", data["preferred_name"]))
    current = data["current_role"]
    sections.append(
        (
            "subtitle",
            f'{current["title"]}, {current["organization"]}  |  Waterloo, Ontario  |  linkedin.com/in/stevenwoods',
        )
    )
    for line in wrap(data["summary"], 92):
        sections.append(("body", line))

    sections.append(("spacer", ""))
    sections.append(("section", "EXPERIENCE"))
    for phase in [
        f'2021-present  {data["career_phases"][5]["label"]}: {data["career_phases"][5]["note"]}',
        f'2008-2021     {data["career_phases"][4]["label"]}: {data["career_phases"][4]["note"]}',
        "1999-2008     Co-founder and builder across Quack.com, Kinitos, and NeoEdge Networks.",
        "1998-1999     Software Engineering Institute, Pittsburgh.",
    ]:
        wrapped = wrap(phase, 92)
        sections.append(("bullet", wrapped[0]))
        for line in wrapped[1:]:
            sections.append(("cont", line))

    sections.append(("spacer", ""))
    sections.append(("section", "EDUCATION"))
    for item in data["education"][:4]:
        line = f'{item["credential"]}, {item["institution"]} ({item["year"]})'
        sections.append(("bullet", line))

    sections.append(("spacer", ""))
    sections.append(("section", "RECOGNITION"))
    for item in data["selected_recognition"]:
        sections.append(("bullet", f'{item["label"]} ({item["year"]})'))

    sections.append(("spacer", ""))
    sections.append(("section", "SELECTED OUTPUTS"))
    sections.append(("bullet", data["selected_publications"][0]))
    sections.append(("bullet", data["selected_publications"][1]))
    sections.append(("bullet", "Selected patents in voice systems, web analysis, structured data, and gaming/adtech."))

    sections.append(("spacer", ""))
    sections.append(("footer", "Profiles: Inovia | LinkedIn | Wikipedia | Research archive at sgwoods.github.io/public/"))
    return sections


def render_txt(sections: list[tuple[str, str]]) -> str:
    lines = []
    for kind, text in sections:
        if kind == "spacer":
            lines.append("")
        elif kind == "section":
            lines.append(text)
        elif kind == "bullet":
            lines.append(f"- {text}")
        elif kind == "cont":
            lines.append(f"  {text}")
        else:
            lines.append(text)
    return "\n".join(lines) + "\n"


def ps_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def render_ps(sections: list[tuple[str, str]]) -> str:
    y = 756
    lines = [
        "%!PS-Adobe-3.0",
        "<< /PageSize [612 792] >> setpagedevice",
        "/Helvetica findfont 10 scalefont setfont",
    ]

    for kind, text in sections:
        if kind == "spacer":
            y -= 8
            continue
        if kind == "name":
            font = "/Helvetica-Bold findfont 20 scalefont setfont"
            x = 36
            gap = 24
        elif kind == "subtitle":
            font = "/Helvetica findfont 11 scalefont setfont"
            x = 36
            gap = 15
        elif kind == "section":
            font = "/Helvetica-Bold findfont 11 scalefont setfont"
            x = 36
            gap = 16
        elif kind == "footer":
            font = "/Helvetica-Oblique findfont 9 scalefont setfont"
            x = 36
            gap = 12
        elif kind == "cont":
            font = "/Helvetica findfont 10 scalefont setfont"
            x = 54
            gap = 12
        elif kind == "bullet":
            font = "/Helvetica findfont 10 scalefont setfont"
            x = 44
            text = f"\267  {text}"
            gap = 12
        else:
            font = "/Helvetica findfont 10 scalefont setfont"
            x = 36
            gap = 12

        lines.append(font)
        lines.append(f"{x} {y} moveto ({ps_escape(text)}) show")
        y -= gap

    lines.extend(["showpage", "%%EOF"])
    return "\n".join(lines) + "\n"


def main() -> None:
    data = json.loads(DATA_PATH.read_text())
    sections = build_sections(data)

    TXT_OUTPUT.write_text(render_txt(sections))
    PS_OUTPUT.write_text(render_ps(sections))

    subprocess.run(
        ["ps2pdf", str(PS_OUTPUT), str(PDF_OUTPUT)],
        check=True,
    )


if __name__ == "__main__":
    main()
