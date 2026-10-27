#!/usr/bin/env python3
"""Bind the person source registry and summary to committed semantic content."""
import argparse
import hashlib
import html
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = "steven-woods-research/source-manifest.json"
SUMMARY = "steven-woods-research.html"


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args], text=True).strip()


def semantic_bytes(payload):
    return json.dumps({key: value for key, value in payload.items() if key != "metadata"},
                      sort_keys=True, separators=(",", ":"), ensure_ascii=True).encode()


def metadata(root, payload):
    if git(root, "rev-parse", "--is-shallow-repository") != "false":
        raise ValueError("Full history is required for source registry provenance")
    content = semantic_bytes(payload)
    committed = json.loads(git(root, "show", "HEAD:" + MANIFEST))
    if content != semantic_bytes(committed):
        raise ValueError("Commit source registry content before recording its metadata")
    # Metadata and formatting commits must not pretend that sources were updated.
    revision = None
    for commit in git(root, "log", "--first-parent", "--format=%H", "HEAD", "--", MANIFEST).splitlines():
        previous = json.loads(git(root, "show", commit + ":" + MANIFEST))
        if semantic_bytes(previous) != content:
            break
        revision = commit
    if revision is None:
        raise ValueError("Cannot resolve the source registry content commit")
    return dict(schema_version="1.0", content_updated_at=git(root, "show", "-s", "--format=%cI", revision),
                content_commit=revision, content_sha256=hashlib.sha256(content).hexdigest(),
                content_hash_scope="Canonical JSON of all top-level fields except metadata",
                date_semantics="Last committed source-registry content change; not source publication, external verification or page rendering.",
                maintainer="sgwoods/public", consumer_role="read_and_request_updates")


def replace_region(page, name, content):
    pattern = r"(<!-- " + name + r":start -->).*?(<!-- " + name + r":end -->)"
    result, count = re.subn(pattern, lambda match: match[1] + "\n" + content + "\n            " + match[2], page, flags=re.S)
    if count != 1:
        raise ValueError("Expected exactly one summary region: " + name)
    return result


def render_summary(root, payload):
    meta = payload["metadata"]
    approved = [source for source in payload["sources"] if source.get("status") == "approved"]
    local = 0
    for source in approved:
        name = source.get("urls", {}).get("archive_local")
        if name:
            path = (root / Path(MANIFEST).parent / name).resolve()
            if not path.is_relative_to(root.resolve()) or not path.is_file():
                raise ValueError("Declared source capture is missing or outside the repository")
            local += 1
    timestamp = html.escape(meta["content_updated_at"])
    revision = meta["content_commit"]
    card = f'''                <div class="metaCard">
                    <span class="metaLabel">Source Registry Updated</span>
                    <span class="metaValue"><time datetime="{timestamp}">{timestamp[:10]}</time></span>
                    <div class="metaNote">Committed source-list change, not a fresh check of every external source. Revision <a href="https://github.com/sgwoods/public/commit/{revision}">{revision[:8]}</a>.</div>
                </div>'''
    panel = f'''        <section class="panel" aria-labelledby="content-freshness-title">
            <h2 id="content-freshness-title">Content Inventory and Freshness</h2>
            <p><strong>{local} of {len(approved)} approved sources have local public copies.</strong> A page capture or recording link is not a transcript. No unreviewed transcript or LinkedIn export is published here.</p>
            <p>This public-record maintainer owns source gathering, transcript production and review, indexes and publication. Other machines consume approved content and return update requests here; they do not maintain a second public archive.</p>
            <p>Historical publication dates, committed registry changes and successful external checks are separate. The source inventory records per-source verification dates, unknown checks and blocked access. A daily inventory refresh does not reverify every source.</p>
            <div class="links">
                <a class="button" href="CONTENT-INVENTORY.md">Read content inventory</a>
                <a class="button" href="data/content/catalog.json">Machine-readable catalog</a>
                <a class="button button--ghost" href="data/content/sources.json">Source freshness and transcript availability</a>
                <a class="button button--ghost" href="data/content/update-requests.json">Review and update requests</a>
                <a class="button button--ghost" href="CONTENT-REQUEST-TRIAGE.md">Maintainer decisions and next work</a>
                <a class="button button--ghost" href="CONTENT-TEXT-RECOVERY.md">Text recovery and private production status</a>
                <a class="button button--ghost" href="IMAC-CONTENT-HANDOFF.md">Consumer handoff</a>
            </div>
        </section>'''
    page = (root / SUMMARY).read_text()
    page = replace_region(page, "source-registry-date", card)
    return replace_region(page, "content-inventory", panel)


def outputs(root=ROOT):
    payload = json.loads((root / MANIFEST).read_text())
    expected = metadata(root, payload)
    result = {}
    if payload.get("metadata") != expected:
        payload["metadata"] = expected
        result[MANIFEST] = json.dumps(payload, indent=2) + "\n"
    page = render_summary(root, payload)
    if (root / SUMMARY).read_text() != page:
        result[SUMMARY] = page
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        changes = outputs()
        if args.check and changes:
            raise ValueError("Refresh person content metadata/summary: " + ", ".join(changes))
        for name, content in changes.items():
            (ROOT / name).write_text(content)
            print("Updated " + name)
        if not changes:
            print("Person registry metadata and summary match committed source content.")
    except (ValueError, subprocess.CalledProcessError) as error:
        parser.exit(1, str(error) + "\n")
