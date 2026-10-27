#!/usr/bin/env python3
"""Index versioned public content without fetching, executing or approving it."""
from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from datetime import date, datetime
import hashlib
from html import unescape
from html.parser import HTMLParser
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tempfile
from urllib.parse import parse_qsl, quote, urlsplit
from zoneinfo import ZoneInfo

from render_publications import latex_to_text, parse_entries

ROOT = Path(__file__).resolve().parents[1]
POLICY = "data/content/curation.json"
OUTPUTS = (
    "data/content/catalog.json", "data/content/artifacts.jsonl",
    "data/content/sources.json", "data/content/update-requests.json", "CONTENT-INVENTORY.md",
)
SENSITIVE_QUERY = {"token", "access_token", "auth", "authorization", "signature", "sig", "key", "api_key", "code"}
TEXT_SUFFIXES = {".md", ".txt", ".json", ".jsonl", ".xml", ".bib", ".tex", ".csv", ".vtt", ".srt"}
CODE_SUFFIXES = {".c", ".h", ".cc", ".py", ".sh", ".js", ".cjs", ".css", ".lsp", ".lisp", ".pl", ".yml"}
MIME_TYPES = {
    ".html": "text/html", ".htm": "text/html", ".html~": "text/html",
    ".md": "text/markdown", ".txt": "text/plain", ".json": "application/json",
    ".jsonl": "application/x-ndjson", ".xml": "application/xml", ".csv": "text/csv",
    ".pdf": "application/pdf", ".ps": "application/postscript", ".wav": "audio/wav",
    ".mp3": "audio/mpeg", ".m4a": "audio/mp4", ".mp4": "video/mp4", ".webm": "video/webm",
    ".gif": "image/gif", ".jpg": "image/jpeg", ".png": "image/png",
    ".zip": "application/zip", ".gz": "application/gzip", ".z": "application/x-compress",
    ".vtt": "text/vtt", ".srt": "text/plain",
}


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args])


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def dumps(data):
    return json.dumps(data, ensure_ascii=True, indent=2, sort_keys=True) + "\n"


def safe_local(root, value):
    path = PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts or "\\" in value:
        raise ValueError("Expected a repository-relative path without traversal")
    resolved = (root / value).resolve()
    if not resolved.is_relative_to(root.resolve()):
        raise ValueError("Path escapes repository")
    return resolved


def safe_url(value):
    if not value:
        return None
    parsed = urlsplit(unescape(value))
    if parsed.scheme not in {"http", "https"} or not parsed.hostname or parsed.username or parsed.password:
        raise ValueError("Unsupported or credential-bearing URL in curated metadata")
    if any(key.casefold() in SENSITIVE_QUERY or key.casefold().endswith(("token", "signature")) for key, _ in parse_qsl(parsed.query)):
        raise ValueError("Token-like query parameter in curated metadata; URL omitted from error")
    # Access-token links from this service must never enter this inventory.
    if parsed.hostname == "stratechery.com" or parsed.hostname.endswith(".stratechery.com"):
        raise ValueError("Stratechery links are excluded from this public inventory")
    return value


def private_path(path):
    parts = {part.casefold() for part in PurePosixPath(path).parts}
    return bool(parts & {".private", "private", "private-transcripts", "linkedin-exports", ".venv-voice"}) or PurePosixPath(path).name.casefold() in {"shares.csv", "cookies.txt"}


def history(root):
    # NUL-delimited Git output preserves spaces, tabs and non-ASCII path names.
    tokens = git(root, "log", "--format=%x00%H%x00%cI", "--name-only", "-z", "--no-renames", "--diff-merges=first-parent").decode().split("\0")
    result, revision, timestamp = {}, None, None
    i = 0
    while i < len(tokens):
        token = tokens[i]
        if not token and i + 2 < len(tokens) and re.fullmatch(r"[0-9a-f]{40,64}", tokens[i + 1]):
            revision, timestamp = tokens[i + 1], tokens[i + 2]
            i += 3
            continue
        name = token.removeprefix("\n")
        if name and revision:
            result.setdefault(name, {"revision": revision, "committed_at": timestamp})
        i += 1
    return result


def classify(path, raw):
    suffix = PurePosixPath(path).suffix.lower()
    # Do not use the host MIME registry: Mac and Linux must produce identical catalogs.
    mime = MIME_TYPES.get(suffix, "text/plain" if suffix in TEXT_SUFFIXES | CODE_SUFFIXES else "application/octet-stream")
    if suffix in {".html", ".htm", ".html~"}:
        return "html", "local_html_extractable", mime
    if raw.startswith(b"%PDF"):
        return "pdf", "requires_local_pdf_extraction", "application/pdf"
    if suffix in {".ps", ".eps", ".dvi"}:
        return "legacy_document", "requires_reviewed_conversion", mime
    if suffix in {".wav", ".mp3", ".m4a", ".ogg", ".mp4", ".webm"}:
        return "recording", "transcript_not_inferred", mime
    if suffix in {".gz", ".z", ".zip", ".zoo"}:
        return "compressed_archive", "requires_safe_private_inspection", mime
    if suffix in {".gif", ".jpg", ".jpeg", ".png", ".xbm"}:
        return "image", "ocr_not_verified", mime
    if suffix in {".srt", ".vtt"} and re.search(rb"\d\d:\d\d:\d\d[,.]\d+\s*-->", raw[:65536]):
        return "caption_candidate", "local_text_unreviewed", mime
    if b"\0" not in raw[:8192]:
        if suffix in CODE_SUFFIXES:
            return "code", "read_as_data_never_execute", mime
        if suffix in TEXT_SUFFIXES:
            return "structured_data" if suffix in {".json", ".jsonl", ".xml", ".bib", ".csv"} else "text", "local_text", mime
        try:
            raw[:8192].decode("utf-8")
            return "legacy_text", "local_text_encoding_review", mime
        except UnicodeDecodeError:
            pass
    return "binary", "bytes_only_not_extracted", mime


class ReadableHTML(HTMLParser):
    """Text only; exclude executable payloads and never follow embedded links."""
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.skip = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag in {"script", "style", "noscript", "svg", "template"}:
            self.skip += 1
        if not self.skip and tag in {"p", "div", "section", "li", "br", "h1", "h2", "h3", "tr"}:
            self.parts.append("\n")

    def handle_endtag(self, tag):
        if tag in {"script", "style", "noscript", "svg", "template"} and self.skip:
            self.skip -= 1

    def handle_data(self, value):
        if not self.skip:
            self.parts.append(value)

    def text(self):
        return "\n".join(line.strip() for line in "".join(self.parts).splitlines() if line.strip())


def extract_text(path, kind):
    if kind == "html":
        parser = ReadableHTML()
        parser.feed(path.read_text(encoding="utf-8", errors="replace"))
        return parser.text()
    if kind == "pdf":
        try:
            from pypdf import PdfReader
        except ImportError as exc:
            raise ValueError("Install pypdf in your private working environment; no automatic installation") from exc
        return "\n".join(page.extract_text() or "" for page in PdfReader(path).pages)
    if kind in {"code", "text", "structured_data", "legacy_text", "caption_candidate"}:
        return path.read_text(encoding="utf-8", errors="replace")
    raise ValueError("No automatic extraction for this format; inspect safely in private staging")


def artifact_inventory(root, policy, allow_dirty=False):
    if git(root, "rev-parse", "--is-shallow-repository").strip() == b"true":
        raise ValueError("Full Git history is required for per-file provenance; fetch --unshallow first")
    tracked = {}
    for entry in git(root, "ls-files", "--stage", "-z").decode().split("\0"):
        if entry:
            info, name = entry.split("\t", 1)
            mode, oid, stage = info.split()
            if stage != "0":
                raise ValueError("Resolve unmerged files before building an inventory")
            tracked[name] = (mode, oid)
    allowed_transcripts = set(policy.get("approved_public_transcript_paths", []))
    revisions = history(root)
    dirty = set(git(root, "diff", "HEAD", "--name-only", "-z").decode().split("\0")) - set(OUTPUTS) - {""}
    if dirty and not allow_dirty:
        raise ValueError("Commit catalog inputs first; changed paths: " + ", ".join(sorted(dirty)))
    rows = []
    for name in sorted(set(tracked) | set(OUTPUTS)):
        if name in OUTPUTS:
            rows.append(dict(artifact_id="file:" + name, path=name, kind="generated_inventory",
                             sha256=None, byte_size=None, text_access="derived_metadata",
                             provenance={"basis": "self_output_excluded_from_hash_to_avoid_recursion"}))
            continue
        if private_path(name) or ("transcripts" in PurePosixPath(name).parts and name not in allowed_transcripts):
            raise ValueError("Private/unreviewed content must not be tracked in public: " + name)
        full = safe_local(root, name)
        mode, oid = tracked[name]
        if mode not in {"100644", "100755"} or not full.is_file():
            raise ValueError("Inventory supports existing regular versioned files only: " + name)
        raw = full.read_bytes()
        blob_bytes = f"blob {len(raw)}\0".encode() + raw
        actual_oid = (hashlib.sha1(blob_bytes) if len(oid) == 40 else hashlib.sha256(blob_bytes)).hexdigest()
        if actual_oid != oid:
            if not allow_dirty:
                raise ValueError("Working bytes do not match the Git index; inspect filters or local changes: " + name)
            dirty.add(name)
        kind, access, mime = classify(name, raw)
        provenance = dict(revisions.get(name, {}))
        provenance["basis"] = "git_content_change_not_source_publication_or_external_check"
        if not provenance.get("revision") and name not in dirty:
            raise ValueError("Cannot resolve committed file provenance; inspect Git history: " + name)
        if name in dirty:
            provenance.update(revision=None, committed_at=None, state="uncommitted")
        else:
            provenance["state"] = "committed"
        rows.append(dict(artifact_id="file:" + name, path=name, kind=kind, text_access=access,
                         mime_type=mime, byte_size=len(raw), sha256=digest(raw), git_blob_oid=oid,
                         provenance=provenance, style_eligible=False,
                         raw_url=("https://raw.githubusercontent.com/sgwoods/public/" + provenance["revision"] + "/" + quote(name, safe="/")) if provenance.get("revision") else None))
    return rows


def source_inventory(root, policy, artifacts):
    by_path = {item["path"]: item for item in artifacts}
    sources = []

    def paths(paths):
        result = []
        for path in paths:
            safe_local(root, path)
            if path not in by_path:
                raise ValueError("Source points outside versioned inventory: " + path)
            result.append(path)
        return result

    for manifest in sorted(root.glob("*/source-manifest.json")):
        payload = json.loads(manifest.read_text())
        scope = manifest.parent.name
        for source in payload["sources"]:
            identifier = scope + "/" + source["source_id"]
            local = source.get("urls", {}).get("archive_local")
            local_paths = paths([str(PurePosixPath(scope) / local)]) if local else []
            record = dict(content_id=identifier, source_id=source["source_id"], owner=scope,
                          title=source["title"], source_type=source["source_type"],
                          source_status=source["status"], source_manifest=manifest.relative_to(root).as_posix(),
                          source_date=source.get("date"),
                          canonical_url=safe_url(source.get("urls", {}).get("canonical")),
                          related_external_url=safe_url(source.get("urls", {}).get("archive_web")),
                          local_artifacts=local_paths, supporting_artifacts=[], recordings=[],
                          text_role="captured_page_not_reviewed_for_voice" if local else "metadata_only",
                          identity_review="not_assessed_for_voice", authorship="not_verified_for_voice",
                          transcript={"state": "not_catalogued", "public_artifacts": []},
                          freshness={"policy": "current_profile" if "-current-" in source["source_id"] else "historical", "last_successful_external_check": None},
                          style_eligible=False)
            for path in local_paths:
                sidecar = root / (path + ".capture.json")
                if sidecar.exists():
                    capture = json.loads(sidecar.read_text())
                    record["freshness"]["last_successful_external_check"] = capture.get("checked_on")
                    record["supporting_artifacts"].append(path + ".capture.json")
            sources.append(record)

    for entry in parse_entries((root / "data/publications.bib").read_text()):
        fields = entry.fields
        local = paths([fields[key] for key in ("archive_landing", "archive_pdf", "archive_ps") if fields.get(key)])
        sources.append(dict(content_id="publication:" + entry.key, source_id=entry.key,
                            owner="publications", title=latex_to_text(fields.get("title", entry.key)),
                            source_type=entry.entry_type, source_status="bibliography_record_not_voice_approval",
                            source_manifest="data/publications.bib", source_date={"display": fields.get("year"), "precision": "year"},
                            authors=fields.get("author"), doi=fields.get("doi"),
                            canonical_url=safe_url(fields.get("url") or ("https://doi.org/" + fields["doi"] if fields.get("doi") else None)),
                            related_external_url=None, local_artifacts=local, supporting_artifacts=[], recordings=[],
                            text_role="coauthored_or_authorship_review_required", identity_review="bibliographic_attribution_only",
                            authorship="coauthors_must_be_preserved", style_eligible=False,
                            transcript={"state": "not_applicable", "public_artifacts": []},
                            freshness={"policy": "historical", "last_successful_external_check": None}))

    ledger_name = "steven-woods-research/research/media-sources-review.md"
    ledger = root / ledger_name
    if ledger.exists():
        by_url = defaultdict(list)
        def url_key(value):
            parsed = urlsplit(value)
            return parsed.netloc.casefold() + parsed.path.rstrip("/") + ("?" + parsed.query if parsed.query else "")
        for record in sources:
            if record.get("canonical_url"):
                by_url[url_key(record["canonical_url"])].append(record)
        for line_number, line in enumerate(ledger.read_text().splitlines(), 1):
            if not line.startswith("| "):
                continue
            columns = [part.strip() for part in re.split(r"(?<!\\)\|", line)[1:-1]]
            if len(columns) != 6 or not columns[3].startswith("https://"):
                continue
            canonical = safe_url(columns[3])
            reference = dict(path=ledger_name, line=line_number)
            if url_key(canonical) in by_url:
                for record in by_url[url_key(canonical)]:
                    record.setdefault("review_ledger_refs", []).append(reference)
                continue
            captures = ["steven-woods-research/historic/artifacts/" + value for value in re.findall(r"`(archive-html/[^`]+)`", columns[5])]
            captures += [str(PurePosixPath(value).relative_to("../../")) for value in re.findall(r"\]\((\.\./\.\./[^)]+)\)", columns[5])]
            record = dict(content_id="ledger:" + digest(canonical.encode())[:20], source_id="ledger-" + digest(canonical.encode())[:20],
                          owner="steven-woods-research", title=columns[1].replace("\\|", "|"), source_type=columns[0],
                          source_status="review_ledger_only_not_approved", source_manifest=ledger_name,
                          source_date={"display": columns[2], "sort": None, "precision": "approximate"},
                          canonical_url=canonical, related_external_url=None, local_artifacts=paths(captures),
                          supporting_artifacts=[], recordings=[], text_role="support_capture_not_reviewed_for_voice" if captures else "metadata_only",
                          identity_review="not_assessed_for_voice", authorship="not_verified_for_voice", style_eligible=False,
                          transcript={"state": "not_catalogued", "public_artifacts": []},
                          freshness={"policy": "historical", "last_successful_external_check": None},
                          review_ledger_refs=[reference])
            sources.append(record)
            by_url[url_key(canonical)].append(record)
    sources.extend(policy.get("supplemental_sources", []))
    by_id = {record["content_id"]: record for record in sources}
    if len(by_id) != len(sources):
        raise ValueError("Content IDs must be unique")
    for identifier, override in policy.get("source_overrides", {}).items():
        if identifier not in by_id:
            raise ValueError("Unknown override ID: " + identifier)
        if not set(override) <= {"supporting_artifacts", "text_role", "identity_review", "authorship", "recordings", "freshness", "research_note"}:
            raise ValueError("Unsupported curation override field for " + identifier)
        by_id[identifier].update(override)
    for record in sources:
        paths([record["source_manifest"]])
        paths(record["local_artifacts"] + record.get("supporting_artifacts", []))
        paths(record.get("transcript", {}).get("public_artifacts", []))
        safe_url(record.get("canonical_url"))
        safe_url(record.get("related_external_url"))
        if record["freshness"]["policy"] not in {"historical", "current_profile"}:
            raise ValueError("Unknown freshness policy")
        if record["freshness"].get("review_after_days", 30) < 1:
            raise ValueError("Review intervals must be positive")
        if record.get("style_eligible"):
            raise ValueError("This baseline has no reviewed style excerpts; explicit future interface review is required")
        for recording in record.get("recordings", []):
            if recording.get("url"):
                safe_url(recording["url"])
            if recording.get("local_path"):
                paths([recording["local_path"]])
            if recording.get("evidence_path"):
                paths([recording["evidence_path"]])
        record["text_availability"] = [dict(path=path, method=by_path[path]["text_access"],
                                             extraction_quality="not_verified") for path in record["local_artifacts"]]
        record["artifact_provenance"] = [dict(path=path, sha256=by_path[path]["sha256"],
                                              **by_path[path]["provenance"]) for path in record["local_artifacts"]]
    return sorted(sources, key=lambda record: record["content_id"])


def update_requests(sources, as_of):
    requests = []

    def add(source, reason, action, priority="normal"):
        requests.append(dict(request_id=digest((source["content_id"] + ":" + reason).encode())[:20],
                             content_id=source["content_id"], owner=source["owner"], reason=reason,
                             suggested_action=action, priority=priority, state="proposed_not_sent",
                             target="source_owner_or_private_research_working_repo",
                             automatic_fetch=False, changes_release_status=False))

    for source in sources:
        if source.get("source_status") == "rejected":
            continue
        freshness = source["freshness"]
        if source.get("identity_review") == "needs_identity_verification":
            add(source, "identity_unresolved", "Verify the subject before transcription, quotation or style use.", "high")
        if freshness.get("access_state") == "blocked":
            add(source, "public_access_blocked", "Request a user-approved public-only copy in private staging; do not use account UI or browser cookies.")
        elif freshness["policy"] == "current_profile":
            checked = freshness.get("last_successful_external_check")
            if not checked:
                add(source, "external_check_unknown", "Ask the owning researcher to check the public source; Git commit/review dates are not external checks.")
            elif (as_of - date.fromisoformat(checked[:10])).days >= freshness.get("review_after_days", 30):
                add(source, "external_review_due", "Recheck the public source and record evidence/outcome; retain historical captures and release labels.")
        if source.get("recordings") and source["transcript"]["state"] == "not_catalogued":
            add(source, "transcript_gap", "First recover prior private work; if needed transcribe in a private repo, verify speakers and request review before any public export.")
        if source["source_type"] == "appearance" and source.get("text_role") == "event_listing_not_talk_transcript" and not source.get("recordings"):
            add(source, "recording_link_gap", "Ask the organizer/source owner whether a public recording, slides or notes exist; a channel link is not this talk's recording.")
        if not source["local_artifacts"] and freshness.get("access_state") != "blocked":
            add(source, "local_content_gap", "Check related archive editions first; request a permitted public-safe copy from the source owner. Do not bypass access controls.")
    return dict(schema_version="1.0", evaluated_on=as_of.isoformat(),
                semantics="Review signals, not claims that a historical source is out of date. No requests have been sent.",
                requests=sorted(requests, key=lambda item: item["request_id"]))


def build(root=ROOT, allow_dirty=False, as_of=None):
    policy = json.loads((root / POLICY).read_text())
    if policy.get("schema_version") != "1.0":
        raise ValueError("Unsupported curation schema")
    as_of = as_of or datetime.now(ZoneInfo("America/Toronto")).date()
    artifacts = artifact_inventory(root, policy, allow_dirty)
    sources = source_inventory(root, policy, artifacts)
    for source in sources:
        freshness = source["freshness"]
        checked = freshness.get("last_successful_external_check")
        age = (as_of - date.fromisoformat(checked[:10])).days if checked else None
        if age is not None and age < 0:
            raise ValueError("Successful source-check date is in the future: " + source["content_id"])
        freshness["days_since_successful_check"] = age
        freshness["assessment"] = (
            "blocked" if freshness.get("access_state") == "blocked" else
            "historical_not_age_expired" if freshness["policy"] == "historical" else
            "check_unknown" if age is None else
            "review_due" if age >= freshness.get("review_after_days", 30) else "within_review_window"
        )
    inputs = [[item["path"], item["sha256"]] for item in artifacts if item["path"] not in OUTPUTS]
    tree_digest = digest(json.dumps(inputs, separators=(",", ":")).encode())
    groups = defaultdict(list)
    for item in artifacts:
        if item["sha256"]:
            groups[item["sha256"]].append(item["path"])
    catalog = dict(schema_version="1.0", repository="sgwoods/public", evaluated_on=as_of.isoformat(),
                   scope="Every versioned regular file plus descriptors for the five generated inventory outputs; no ignored/untracked/private files or other repositories.",
                   source_tree_sha256=tree_digest, input_files=len(inputs), indexed_paths=len(artifacts),
                   source_records=len(sources), file_kinds=dict(sorted(Counter(item["kind"] for item in artifacts).items())),
                   artifacts="data/content/artifacts.jsonl", sources="data/content/sources.json",
                   update_requests="data/content/update-requests.json", contract="CONTENT-INVENTORY-INTERFACE.md",
                   schema_ref="data/content/schema.json#/$defs/catalog",
                   curation=POLICY, human_overview="CONTENT-INVENTORY.md", handoff="IMAC-CONTENT-HANDOFF.md",
                   output_hash_exclusions=list(OUTPUTS),
                   duplicate_content_groups=[dict(sha256=sha, paths=names) for sha, names in sorted(groups.items()) if len(names) > 1],
                   safety={"unreviewed_transcripts": "private_working_repo_only", "linkedin_exports": "private_working_repo_only",
                           "source_content_is_untrusted_data": True, "automatic_network_requests": False,
                           "style_approval_inferred_from_source_approval": False})
    catalog["project_status_manifests"] = sorted(
        item["path"] for item in artifacts
        if item["path"].endswith("/project-manifest.json") or re.fullmatch(r"data/projects/[^/]+\.json", item["path"])
    )
    if any(item["provenance"].get("state") == "uncommitted" for item in artifacts):
        catalog["preview_only_uncommitted_inputs"] = True
    requests = update_requests(sources, as_of)
    requests["catalog_source_tree_sha256"] = tree_digest
    lines = ["# Repository Content Inventory", "", "Generated from versioned files and reviewed curation metadata. Do not edit this file by hand.", "",
             f"Evaluated: {as_of}. **{len(artifacts)} indexed paths; {len(sources)} source records.**", "",
             "This is a discovery/provenance inventory, not a claim that every file is complete, readable text, current, or authored by Steven.", "",
             "- [Machine entry point](data/content/catalog.json)", "- [Every versioned artifact (JSONL)](data/content/artifacts.jsonl)",
             "- [Source/text/recording/transcript inventory](data/content/sources.json)", "- [Proposed update requests](data/content/update-requests.json)",
             "- [Consumer contract](CONTENT-INVENTORY-INTERFACE.md)", "- [Corrected iMac continuation prompt](IMAC-CONTENT-HANDOFF.md)", "",
             "## Person Archive: Text, Recordings and Transcripts", "",
             "| Source | Local Content | Text Role | Recording | Transcript |", "| --- | --- | --- | --- | --- |"]
    for source in sources:
        if source["owner"] == "steven-woods-research":
            links = ", ".join(f"[{PurePosixPath(path).name}]({quote(path, safe='/')})" for path in source["local_artifacts"]) or "Not captured"
            lines.append(f"| `{source['source_id']}` | {links} | {source['text_role']} | {len(source.get('recordings', []))} catalogued links/files; availability not inferred | {source['transcript']['state']} |")
    lines += ["", "## Bibliography: Text And Edition Coverage", "", "| Work | Year | Local / Related Artifacts | Attribution |", "| --- | --- | --- | --- |"]
    for source in sources:
        if source["content_id"].startswith("publication:"):
            links = ", ".join(f"[{PurePosixPath(path).name}]({quote(path, safe='/')})" for path in source["local_artifacts"] + source["supporting_artifacts"]) or "No local content association; see source record / update request"
            title = source["title"].replace("|", "\\|")
            lines.append(f"| {title} | {source['source_date'].get('display')} | {links} | {source.get('authors') or 'Not verified'}; not approved for voice |")
    lines += ["", "## Writings and Legacy Media", "", "Bibliography entries retain authors/co-authors and publication years. Thesis editions, CV and the legacy welcome recording have explicit supplemental entries. Every Spectra file is discoverable by relative path and checksum, including compressed archives and legacy source code; none is automatically executed or unpacked.", "",
              "No unreviewed transcript, LinkedIn export, machine-wide cache or private-repository inventory is included. Existing HTML is extractable as data; PDF text quality/completeness is not asserted without extraction review. Historical publication dates, Git content-change dates and successful external checks remain separate.", "",
              f"There are **{len(requests['requests'])} proposed review/update requests**. Evaluate them dynamically with `python3 tools/content_inventory.py requests --as-of YYYY-MM-DD`; nothing is sent automatically.", ""]
    outputs = {OUTPUTS[1]: "".join(json.dumps(item, ensure_ascii=True, sort_keys=True) + "\n" for item in artifacts),
               OUTPUTS[2]: dumps(dict(schema_version="1.0", sources=sources)), OUTPUTS[3]: dumps(requests), OUTPUTS[4]: "\n".join(lines)}
    catalog["outputs_sha256"] = {name: digest(value.encode()) for name, value in outputs.items()}
    return {OUTPUTS[0]: dumps(catalog), **outputs}


def verify_bundle(root=ROOT):
    catalog = json.loads((root / OUTPUTS[0]).read_text())
    if set(catalog.get("outputs_sha256", {})) != set(OUTPUTS[1:]):
        raise ValueError("Inventory bundle has missing/unexpected output references")
    for name, expected in catalog["outputs_sha256"].items():
        path = root / name
        if not path.exists() or digest(path.read_bytes()) != expected:
            raise ValueError("Inventory bundle mismatch; refresh from one Git revision before consuming: " + name)
    return catalog


def validate_schema(outputs, root=ROOT):
    try:
        import jsonschema
    except ImportError as exc:
        raise ValueError("Optional schema validation needs tools/requirements-content-tests.txt in a working environment") from exc
    schema = json.loads((root / "data/content/schema.json").read_text())
    jsonschema.Draft202012Validator.check_schema(schema)
    for name, kind in ((OUTPUTS[0], "catalog"), (OUTPUTS[2], "sources"), (OUTPUTS[3], "requests")):
        validator = jsonschema.Draft202012Validator({**schema, "$ref": "#/$defs/" + kind}, format_checker=jsonschema.FormatChecker())
        validator.validate(json.loads(outputs[name]))
    validator = jsonschema.Draft202012Validator({**schema, "$ref": "#/$defs/artifact"})
    for item in map(json.loads, outputs[OUTPUTS[1]].splitlines()):
        validator.validate(item)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    build_args = sub.add_parser("build")
    build_args.add_argument("--allow-dirty", action="store_true", help="Development preview only, never a committed baseline")
    build_args.add_argument("--as-of", type=date.fromisoformat)
    check_args = sub.add_parser("check")
    check_args.add_argument("--schema", action="store_true", help="Also run optional JSON Schema validation")
    request_args = sub.add_parser("requests")
    request_args.add_argument("--as-of", type=date.fromisoformat)
    text_args = sub.add_parser("text")
    text_args.add_argument("--path", required=True)
    args = parser.parse_args()
    if args.command == "text":
        verify_bundle()
        catalogued = {item["path"]: item for item in map(json.loads, (ROOT / OUTPUTS[1]).read_text().splitlines())}
        item = catalogued.get(args.path)
        if not item or args.path in OUTPUTS:
            raise ValueError("Choose a versioned content path from artifacts.jsonl")
        path = safe_local(ROOT, args.path)
        if digest(path.read_bytes()) != item["sha256"]:
            raise ValueError("Content differs from catalog; request an inventory refresh before extraction")
        print(extract_text(path, item["kind"]))
        return
    if args.command == "requests":
        catalog = verify_bundle()
        sources = json.loads((ROOT / OUTPUTS[2]).read_text())["sources"]
        requests = update_requests(sources, args.as_of or datetime.now(ZoneInfo("America/Toronto")).date())
        requests["catalog_source_tree_sha256"] = catalog["source_tree_sha256"]
        print(dumps(requests), end="")
        return
    if args.command == "check":
        old = json.loads((ROOT / OUTPUTS[0]).read_text())
        outputs = build(as_of=date.fromisoformat(old["evaluated_on"]))
        stale = [name for name, value in outputs.items() if not (ROOT / name).exists() or (ROOT / name).read_text() != value]
        if stale:
            raise ValueError("Inventory needs regeneration: " + ", ".join(stale))
        if args.schema:
            validate_schema(outputs)
        print("Content inventory matches all versioned inputs, source mappings and committed provenance.")
        return
    outputs = build(allow_dirty=args.allow_dirty, as_of=args.as_of)
    # Publish the descriptor last; hash checks reject any interrupted mixed bundle.
    for name in (*OUTPUTS[1:], OUTPUTS[0]):
        value = outputs[name]
        path = ROOT / name
        path.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent, delete=False) as handle:
            handle.write(value)
            temporary = Path(handle.name)
        temporary.replace(path)
    print("Updated five content inventory outputs; no source fetched, transcribed or approved.")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError) as exc:
        raise SystemExit(str(exc))
