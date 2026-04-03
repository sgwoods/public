#!/usr/bin/env python3
"""Render a one-page Steven Woods executive CV in text, PostScript, and PDF."""

from __future__ import annotations

import json
import subprocess
import textwrap
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA_PATH = ROOT / "steven-woods-research" / "research" / "baseline-identity.json"
TXT_OUTPUT = ROOT / "steven-woods-cv.txt"
PS_OUTPUT = ROOT / "steven-woods-cv.ps"
PDF_OUTPUT = ROOT / "steven-woods-cv.pdf"

PAGE_WIDTH = 612
PAGE_HEIGHT = 792
LEFT = 48
RIGHT = 564
TOP_BAR_HEIGHT = 96
ACCENT = (0.16, 0.33, 0.56)
ACCENT_DARK = (0.07, 0.18, 0.31)
TEXT = (0.12, 0.15, 0.19)
TEXT_MUTED = (0.37, 0.42, 0.48)
WHITE = (1.0, 1.0, 1.0)
RULE = (0.82, 0.86, 0.9)
LINK = (0.12, 0.15, 0.19)


def wrap(text: str, width: int) -> list[str]:
    return textwrap.wrap(text, width=width, break_long_words=False, break_on_hyphens=False)


def ps_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def ps_string(value: str) -> str:
    return f"({ps_escape(value)})"


def color_cmd(rgb: tuple[float, float, float]) -> str:
    return f"{rgb[0]:.3f} {rgb[1]:.3f} {rgb[2]:.3f} setrgbcolor"


def build_cv(data: dict) -> dict:
    public_links = data["public_links"]
    summary = (
        "Canadian technology executive, founder, inventor, and investor. Investing Partner & CTO at "
        "Inovia Capital, former leader of Google Canada's engineering organization, and co-founder of "
        "Quack.com, Kinitos, and NeoEdge Networks. PhD and M.Math in Mathematics (Computer Science, AI), "
        "University of Waterloo."
    )

    experience = [
        {
            "years": "2021-present",
            "role": "Investing Partner & CTO, Inovia Capital",
            "detail": (
                "Leads investing, technical diligence, AI strategy, and portfolio company support."
            ),
        },
        {
            "years": "2008-2021",
            "role": "Google Canada engineering leadership",
            "detail": (
                "Led Google Canada's engineering organization from about 20 to more than 1,300 technical staff."
            ),
        },
        {
            "years": "2000-2008",
            "role": "Co-founder and executive, Kinitos / NeoEdge Networks",
            "detail": (
                "Built and deployed products across enterprise software, internet services, gaming, and advertising technology."
            ),
        },
        {
            "years": "1999-2000",
            "role": "Co-founder, Quack.com",
            "detail": "Built an early voice systems startup acquired by AOL in 2000.",
        },
        {
            "years": "1998-1999",
            "role": "Software Engineering Institute, Carnegie Mellon University",
            "detail": "Advanced software architecture, design recovery, and program understanding.",
        },
        {
            "years": "1991-1992",
            "role": "CSIRO, Canberra, Australia",
            "detail": "Research and development for CSIRO Australia; Canberra Knights semi-professional player.",
        },
    ]

    education = [
        "PhD, Mathematics (Computer Science, AI), University of Waterloo",
        "M.Math, Mathematics (Computer Science, AI), University of Waterloo",
        "B.Sc., Computer Science, University of Saskatchewan",
        "Postdoctoral studies, University of Hawai'i at Manoa",
    ]

    recognition = [
        "USask Lifetime Achievement Award (2021)",
        "J.W. Graham Medal, University of Waterloo (2010)",
        "IEEE Working Conference on Reverse Engineering Outstanding Contribution Award (1996)",
    ]

    outputs = [
        "Constraint-Based Design Recovery for Software Reengineering: Theory and Experiments (book, 1997)",
        "Selected inventor on patents spanning voice systems, web analysis, structured data, and gaming / adtech systems",
    ]

    focus_areas = data.get("current_focus_areas", [])

    links = [
        ("LinkedIn", "linkedin.com/in/stevenwoods", public_links["linkedin"]),
        ("Inovia", "inovia.vc/team/steve-woods", public_links["inovia"]),
        (
            "Profile",
            "sgwoods.github.io/public/steven-woods-profile.html",
            "https://sgwoods.github.io/public/steven-woods-profile.html",
        ),
        ("Public projects", "sgwoods.github.io/public", "https://sgwoods.github.io/public/"),
        (
            "Patents & publications",
            "sgwoods.github.io/public/patents-publications.html",
            "https://sgwoods.github.io/public/patents-publications.html",
        ),
    ]

    return {
        "name": data["preferred_name"],
        "headline": "Investing Partner & CTO, Inovia Capital",
        "location": "Waterloo, Ontario, Canada",
        "summary_lines": wrap(summary, 102),
        "experience": experience,
        "education": education,
        "recognition": recognition,
        "focus_areas": focus_areas,
        "outputs": outputs,
        "links": links,
    }


def build_txt(cv: dict) -> str:
    lines = [
        cv["name"],
        f'{cv["headline"]}  |  {cv["location"]}',
        "",
    ]
    lines.extend(cv["summary_lines"])
    lines.extend(["", "LEADERSHIP EXPERIENCE"])
    for item in cv["experience"]:
        first = f'{item["years"]}  {item["role"]}: {item["detail"]}'
        wrapped = wrap(first, 102)
        lines.append(f"- {wrapped[0]}")
        for line in wrapped[1:]:
            lines.append(f"  {line}")

    lines.extend(["", "EDUCATION"])
    for item in cv["education"]:
        lines.append(f"- {item}")

    lines.extend(["", "RECOGNITION"])
    for item in cv["recognition"]:
        lines.append(f"- {item}")

    lines.extend(["", "BOARD / ADVISORY / INVESTMENT FOCUS"])
    for item in cv["focus_areas"]:
        lines.append(f"- {item}")

    lines.extend(["", "SELECTED PUBLICATIONS & PATENTS"])
    for item in cv["outputs"]:
        wrapped = wrap(item, 100)
        lines.append(f"- {wrapped[0]}")
        for line in wrapped[1:]:
            lines.append(f"  {line}")

    lines.extend(["", "PUBLIC LINKS"])
    for label, display, url in cv["links"]:
        lines.append(f"- {label}: {display} ({url})")

    return "\n".join(lines) + "\n"


def render_ps(cv: dict) -> str:
    lines = [
        "%!PS-Adobe-3.0",
        "<< /PageSize [612 792] >> setpagedevice",
        "",
        "/showline {",
        "  /text exch def /size exch def /fontname exch def /rgbB exch def /rgbG exch def /rgbR exch def /y exch def /x exch def",
        "  gsave",
        "  rgbR rgbG rgbB setrgbcolor",
        "  fontname findfont size scalefont setfont",
        "  x y moveto text show",
        "  grestore",
        "} def",
        "",
        "/showlink {",
        "  /url exch def /text exch def /size exch def /fontname exch def /rgbB exch def /rgbG exch def /rgbR exch def /y exch def /x exch def",
        "  gsave",
        "  rgbR rgbG rgbB setrgbcolor",
        "  fontname findfont size scalefont setfont",
        "  x y moveto text show",
        "  text stringwidth pop /w exch def",
        "  [ /Rect [ x y 2 sub x w add y size add ]",
        "    /Border [0 0 0]",
        "    /Action << /Subtype /URI /URI url >>",
        "    /Subtype /Link",
        "    /ANN",
        "  pdfmark",
        "  grestore",
        "} def",
        "",
        "/rule {",
        "  /y exch def /x2 exch def /x1 exch def",
        "  gsave",
        f"  {color_cmd(RULE)}",
        "  0.8 setlinewidth",
        "  newpath x1 y moveto x2 y lineto stroke",
        "  grestore",
        "} def",
        "",
        "[ /Title (Steven Gregory Woods Executive CV) /Author (Steven Gregory Woods) /Subject (Executive one-page CV) /Creator (render_steven_cv.py) /DOCINFO pdfmark",
        "",
        "gsave",
        f"{color_cmd(ACCENT_DARK)}",
        f"0 {PAGE_HEIGHT - TOP_BAR_HEIGHT} {PAGE_WIDTH} {TOP_BAR_HEIGHT} rectfill",
        "grestore",
        "gsave",
        f"{color_cmd(ACCENT)}",
        f"0 {PAGE_HEIGHT - TOP_BAR_HEIGHT - 6} {PAGE_WIDTH} 6 rectfill",
        "grestore",
    ]

    # Header
    lines.extend(
        [
            f'48 746 {WHITE[0]:.3f} {WHITE[1]:.3f} {WHITE[2]:.3f} /Helvetica-Bold 24 {ps_string(cv["name"])} showline',
            f'48 721 0.900 0.950 0.990 /Helvetica-Bold 11 {ps_string(cv["headline"])} showline',
            f'48 704 0.840 0.900 0.950 /Helvetica 10 {ps_string(cv["location"])} showline',
            f'402 721 0.840 0.900 0.950 /Helvetica-Bold 9 {ps_string("Executive CV")} showline',
            f'402 704 0.840 0.900 0.950 /Helvetica 8 {ps_string("Updated April 2026")} showline',
        ]
    )

    y = 664
    for line in cv["summary_lines"]:
        lines.append(
            f"{LEFT} {y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 10.5 {ps_string(line)} showline"
        )
        y -= 14

    section_y = y - 10

    def add_section(title: str, start_y: int) -> int:
        lines.append(
            f"{LEFT} {start_y - 8} {ACCENT[0]:.3f} {ACCENT[1]:.3f} {ACCENT[2]:.3f} /Helvetica-Bold 9 {ps_string(title)} showline"
        )
        return start_y - 34

    y = add_section("LEADERSHIP EXPERIENCE", section_y)
    detail_width = 76
    for item in cv["experience"]:
        lines.append(
            f"{LEFT} {y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica-Bold 10 {ps_string(item['years'])} showline"
        )
        lines.append(
            f"136 {y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica-Bold 10 {ps_string(item['role'])} showline"
        )
        y -= 12
        for line in wrap(item["detail"], detail_width):
            lines.append(
                f"136 {y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 9.3 {ps_string(line)} showline"
            )
            y -= 11
        y -= 5

    column_top = y - 2
    left_x1 = LEFT
    left_x2 = 292
    right_x1 = 320
    right_x2 = RIGHT

    def add_column_heading(title: str, x1: int, x2: int, start_y: int) -> int:
        lines.append(
            f"{x1} {start_y - 10} {ACCENT[0]:.3f} {ACCENT[1]:.3f} {ACCENT[2]:.3f} /Helvetica-Bold 8.5 {ps_string(title)} showline"
        )
        return start_y - 24

    left_y = add_column_heading("EDUCATION", left_x1, left_x2, column_top)
    for item in cv["education"]:
        wrapped = wrap(item, 42)
        lines.append(
            f"{left_x1} {left_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string('-  ' + wrapped[0])} showline"
        )
        left_y -= 10
        for line in wrapped[1:]:
            lines.append(
                f"{left_x1 + 10} {left_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string(line)} showline"
            )
            left_y -= 10
        left_y -= 1

    left_y = add_column_heading("RECOGNITION", left_x1, left_x2, left_y - 2)
    for item in cv["recognition"]:
        wrapped = wrap(item, 42)
        lines.append(
            f"{left_x1} {left_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string('-  ' + wrapped[0])} showline"
        )
        left_y -= 10
        for line in wrapped[1:]:
            lines.append(
                f"{left_x1 + 10} {left_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string(line)} showline"
            )
            left_y -= 10

    right_y = add_column_heading("BOARD / ADVISORY / INVESTMENT FOCUS", right_x1, right_x2, column_top)
    for item in cv["focus_areas"]:
        wrapped = wrap(item, 42)
        lines.append(
            f"{right_x1} {right_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string('-  ' + wrapped[0])} showline"
        )
        right_y -= 10
        for line in wrapped[1:]:
            lines.append(
                f"{right_x1 + 10} {right_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string(line)} showline"
            )
            right_y -= 10

    right_y = add_column_heading("PUBLICATIONS & PATENTS", right_x1, right_x2, right_y - 2)
    for item in cv["outputs"]:
        wrapped = wrap(item, 42)
        lines.append(
            f"{right_x1} {right_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string('-  ' + wrapped[0])} showline"
        )
        right_y -= 10
        for line in wrapped[1:]:
            lines.append(
                f"{right_x1 + 10} {right_y} {TEXT[0]:.3f} {TEXT[1]:.3f} {TEXT[2]:.3f} /Helvetica 8.7 {ps_string(line)} showline"
            )
            right_y -= 10
        right_y -= 1

    right_y = add_column_heading("PUBLIC LINKS", right_x1, right_x2, right_y - 2)
    for label, display, url in cv["links"]:
        lines.append(
            f"{right_x1} {right_y} {LINK[0]:.3f} {LINK[1]:.3f} {LINK[2]:.3f} /Helvetica 7.9 {ps_string(label + ': ' + display)} {ps_string(url)} showlink"
        )
        right_y -= 10

    lines.extend(["showpage", "%%EOF"])
    return "\n".join(lines) + "\n"


def main() -> None:
    data = json.loads(DATA_PATH.read_text())
    cv = build_cv(data)
    version_stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    versioned_pdf_output = ROOT / f"steven-woods-cv-{version_stamp}.pdf"

    TXT_OUTPUT.write_text(build_txt(cv))
    PS_OUTPUT.write_text(render_ps(cv))
    pdf_command = [
        "gs",
        "-dBATCH",
        "-dNOPAUSE",
        "-dCompressPages=false",
        "-dCompressFonts=false",
        "-dCompressStreams=false",
        "-sDEVICE=pdfwrite",
        f"-sOutputFile={PDF_OUTPUT}",
        str(PS_OUTPUT),
    ]
    subprocess.run(
        pdf_command,
        check=True,
    )
    subprocess.run(
        [
            "gs",
            "-dBATCH",
            "-dNOPAUSE",
            "-dCompressPages=false",
            "-dCompressFonts=false",
            "-dCompressStreams=false",
            "-sDEVICE=pdfwrite",
            f"-sOutputFile={versioned_pdf_output}",
            str(PS_OUTPUT),
        ],
        check=True,
    )


if __name__ == "__main__":
    main()
