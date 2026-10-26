#!/usr/bin/env python3
"""Create inert, attributed text-and-link captures from explicitly reviewed HTML.

Fetching and permission review are separate. Never use this to bless a login,
challenge page, search snippet or a summary as a complete source capture.
"""
import argparse
from datetime import date
import hashlib
import html
from html.parser import HTMLParser
import json
from pathlib import Path
import re
from urllib.parse import urljoin, urlsplit

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param", "source", "track", "wbr"}
BLOCK = {"p", "div", "section", "article", "li", "tr", "h1", "h2", "h3", "h4", "br", "hr", "dt", "dd", "blockquote"}
SKIP = {"script", "style", "noscript", "iframe", "svg", "form", "button", "template"}


class ContentText(HTMLParser):
    def __init__(self, tag, attribute, value, base):
        super().__init__(convert_charrefs=True)
        self.tag, self.attribute, self.value, self.base = tag, attribute, value, base
        self.stack, self.parts = [], []
        self.root_depth = None
        self.matches = 0

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        match = tag == self.tag and (
            not self.attribute or (self.value in attrs.get("class", "").split()
                                   if self.attribute == "class" else attrs.get(self.attribute) == self.value)
        )
        if self.root_depth is None and match:
            self.matches += 1
            self.root_depth = len(self.stack)
        blocked = tag in SKIP or bool(self.stack and self.stack[-1][1])
        href = None
        if self.root_depth is not None and not blocked:
            if tag in BLOCK:
                self.parts.append("\n\n")
            if tag == "a" and attrs.get("href"):
                candidate = urljoin(self.base, attrs["href"])
                if urlsplit(candidate).scheme in {"http", "https"}:
                    href = candidate
        if tag not in VOID:
            self.stack.append((tag, blocked, href))
        elif self.root_depth == len(self.stack):
            self.root_depth = None

    def handle_endtag(self, tag):
        index = next((i for i in range(len(self.stack) - 1, -1, -1) if self.stack[i][0] == tag), None)
        if index is None:
            return
        if self.root_depth is not None:
            _, blocked, href = self.stack[index]
            if not blocked:
                if href:
                    self.parts.append(f" ({href}) ")
                if tag in BLOCK:
                    self.parts.append("\n\n")
            if index <= self.root_depth:
                self.root_depth = None
        del self.stack[index:]

    def handle_data(self, text):
        if self.root_depth is not None and not (self.stack and self.stack[-1][1]):
            self.parts.append(re.sub(r"\s+", " ", text))

    def text(self):
        lines = "\n".join(line.strip() for line in "".join(self.parts).splitlines())
        return re.sub(r"\n{3,}", "\n\n", lines).strip()


def render_capture(raw, *, title, source_url, retrieved_url, checked_on, tag,
                   attribute=None, value=None, expected=(), license_note, method, revision=None):
    date.fromisoformat(checked_on)
    for url in (source_url, retrieved_url):
        if urlsplit(url).scheme != "https":
            raise ValueError("Capture provenance requires HTTPS source URLs")
    parser = ContentText(tag, attribute, value, retrieved_url)
    parser.feed(raw.decode("utf-8"))
    text = parser.text()
    if parser.matches != 1 or len(text) < 100:
        raise ValueError(f"Expected one substantive content region; found {parser.matches}")
    for phrase in expected:
        if phrase.casefold() not in text.casefold():
            raise ValueError(f"Required source evidence missing: {phrase}")
    metadata = dict(schema_version="1.0", title=title, source_url=source_url, retrieved_url=retrieved_url,
                    checked_on=checked_on, method=method,
                    selector=dict(tag=tag, attribute=attribute, value=value),
                    capture_kind="content-only-text-and-links", source_revision=revision,
                    license_note=license_note, input_sha256=hashlib.sha256(raw).hexdigest(),
                    limitations="Not a byte-for-byte page, image, styling or script archive. Capture date is not the source publication date.")
    esc = html.escape
    page = f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; form-action 'none'">
<title>{esc(title)} - preserved content</title>
<style>body{{max-width:75ch;margin:3rem auto;padding:0 1rem;font:18px/1.6 Georgia,serif}}pre{{white-space:pre-wrap;overflow-wrap:anywhere;font:inherit}}aside{{border:1px solid #888;padding:1rem}}</style></head>
<body><h1>{esc(title)}</h1><aside><p>Content-only archive capture. Checked {esc(checked_on)}; this is not the source publication date.</p>
<p>Source: <a href="{esc(source_url, quote=True)}">{esc(source_url)}</a></p>
<p>Retrieved from: <a href="{esc(retrieved_url, quote=True)}">{esc(retrieved_url)}</a></p>
<p>{esc(license_note)}</p><p>{esc(metadata['limitations'])}</p></aside>
<main><pre>{esc(text)}</pre></main></body></html>
'''
    metadata["capture_sha256"] = hashlib.sha256(page.encode()).hexdigest()
    return page, metadata


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("input", "output", "title", "source-url", "retrieved-url", "checked-on", "tag", "license-note"):
        parser.add_argument("--" + name, required=True)
    parser.add_argument("--attribute", choices=["id", "class"])
    parser.add_argument("--value")
    parser.add_argument("--expect", action="append", default=[])
    parser.add_argument("--method", choices=["public-http", "public-browser-transcription"], default="public-http")
    parser.add_argument("--revision")
    args = parser.parse_args()
    if bool(args.attribute) != bool(args.value):
        parser.error("--attribute and --value must be supplied together")
    output = Path(args.output)
    sidecar = output.with_suffix(output.suffix + ".capture.json")
    if output.exists() or sidecar.exists():
        parser.error("Refusing to overwrite an existing capture; review a new dated capture instead")
    page, metadata = render_capture(
        Path(args.input).read_bytes(), title=args.title, source_url=args.source_url,
        retrieved_url=args.retrieved_url, checked_on=args.checked_on, tag=args.tag,
        attribute=args.attribute, value=args.value, expected=args.expect,
        license_note=args.license_note, method=args.method, revision=args.revision,
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(page, encoding="utf-8")
    sidecar.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(output)


if __name__ == "__main__":
    main()
