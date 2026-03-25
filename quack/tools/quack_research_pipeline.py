#!/usr/bin/env python3
"""Batch-first research pipeline for the Quack archive."""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import os
import re
import shutil
import sys
import urllib.error
import urllib.parse
import urllib.request
from collections import defaultdict
from copy import deepcopy
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
PUBLIC_ROOT = ROOT.parent
RESEARCH_DIR = ROOT / "research"
TOPIC_BRIEFS_DIR = RESEARCH_DIR / "topic-briefs"
CAMPAIGNS_DIR = RESEARCH_DIR / "campaigns"
ARCHIVE_HTML_DIR = ROOT / "historic" / "artifacts" / "archive-html"
SEARCH_PACKS_PATH = RESEARCH_DIR / "search-packs.json"
SOURCE_LEADS_PATH = RESEARCH_DIR / "source-leads.json"
TIMELINE_PATH = RESEARCH_DIR / "timeline.json"
ENTITIES_PATH = RESEARCH_DIR / "entities.json"
RUN_REPORT_PATH = RESEARCH_DIR / "run-report.md"
NEXT_STEPS_PATH = RESEARCH_DIR / "next-steps-from-kinitos.md"
PROJECT_MANIFEST_PATH = ROOT / "project-manifest.json"
SOURCE_MANIFEST_PATH = ROOT / "source-manifest.json"
PUBLIC_HANDOFF_PATH = ROOT / "public-handoff.json"
PUBLIC_PROJECT_CARD_MANIFEST_PATH = PUBLIC_ROOT / "data" / "projects" / "quack-com.json"
PROJECT_PAGE_OUTPUT = PUBLIC_ROOT / "quack-com.html"
MEDIA_SOURCES_REVIEW = PUBLIC_ROOT / "steven-woods-research" / "research" / "media-sources-review.md"

NOW = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

TRUSTED_APPROVED_DOMAINS = {
    "internetnews.com",
    "sfgate.com",
    "uwaterloo.ca",
    "alumni.usask.ca",
    "patents.google.com",
    "thecasecentre.org",
    "books.apple.com",
    "sei.cmu.edu",
    "ecommercetimes.com",
}

FRAGILE_ARCHIVE_DOMAINS = {
    "internetnews.com",
    "sfgate.com",
    "ecommercetimes.com",
    "uwaterloo.ca",
    "alumni.usask.ca",
    "thecasecentre.org",
    "books.apple.com",
}

SOURCE_FAMILY_THEME_MAP = {
    "first-party-company-partner": "speechworks-and-partners",
    "reputable-third-party-press": "company-history",
    "university-and-academic-ecosystem": "waterloo-canada-relationship",
    "investor-and-financing-context": "investors-and-outcomes",
    "patent-and-ip": "patents-and-ip",
    "retrospective-and-anecdotal": "anecdotes-and-cultural-footprint",
    "secondary-graph": "key-individuals",
}

SOURCE_FAMILY_TYPE_MAP = {
    "first-party-company-partner": "press-release",
    "reputable-third-party-press": "media-mention",
    "university-and-academic-ecosystem": "appearance",
    "investor-and-financing-context": "media-mention",
    "patent-and-ip": "artifact",
    "retrospective-and-anecdotal": "profile",
    "secondary-graph": "profile",
}

THEME_TITLES = {
    "company-history": "Company History",
    "product-and-technology": "Product and Technology",
    "speechworks-and-partners": "SpeechWorks and Partners",
    "investors-and-outcomes": "Investors and Outcomes",
    "waterloo-canada-relationship": "Waterloo and Canada Relationship",
    "key-individuals": "Key Individuals",
    "patents-and-ip": "Patents and IP",
    "anecdotes-and-cultural-footprint": "Anecdotes and Cultural Footprint",
}

ENTITY_DEFS = [
    {
        "entity_id": "person-steven-woods",
        "name": "Steven Woods",
        "type": "person",
        "aliases": ["Steven Gregory Woods", "Steve Woods"],
        "roles": ["co-founder", "CTO", "entrepreneur"],
        "relationship": "Co-founded Quack.com and anchors the Steven-centric public handoff.",
    },
    {
        "entity_id": "person-alex-quilici",
        "name": "Alex Quilici",
        "type": "person",
        "aliases": ["Alexander Quilici"],
        "roles": ["co-founder", "CEO"],
        "relationship": "Co-founded Quack.com and served as chief executive.",
    },
    {
        "entity_id": "person-jeromy-carriere",
        "name": "Jeromy Carriere",
        "type": "person",
        "aliases": ["Steven Jeromy Carriere", "Jeromy Carrière"],
        "roles": ["co-founder", "architect"],
        "relationship": "Co-founded Quackware / Quack.com and later Kinitos.",
    },
    {
        "entity_id": "person-qiang-yang",
        "name": "Qiang Yang",
        "type": "person",
        "aliases": [],
        "roles": ["academic advisor"],
        "relationship": "University of Waterloo advisor in the background story around Steven Woods.",
    },
    {
        "entity_id": "person-ted-leonsis",
        "name": "Ted Leonsis",
        "type": "person",
        "aliases": [],
        "roles": ["AOL executive"],
        "relationship": "Associated with AOL's broader voice and AOL Anywhere push after the acquisition.",
    },
    {
        "entity_id": "org-quack",
        "name": "Quack.com",
        "type": "organization",
        "aliases": ["Quackware"],
        "roles": ["voice portal company"],
        "relationship": "Canonical company archive subject.",
    },
    {
        "entity_id": "org-speechworks",
        "name": "SpeechWorks",
        "type": "organization",
        "aliases": ["SpeechWorks International"],
        "roles": ["speech recognition partner"],
        "relationship": "Technology partner / stack component in the Quack and AOL by Phone story.",
    },
    {
        "entity_id": "org-aol",
        "name": "America Online",
        "type": "organization",
        "aliases": ["AOL", "AOL Interactive", "AOL Inc.", "Netscape"],
        "roles": ["acquirer"],
        "relationship": "Acquired Quack.com in 2000 and integrated Quack technology into AOL by Phone / AOL Anywhere.",
    },
    {
        "entity_id": "org-lycos",
        "name": "Lycos",
        "type": "organization",
        "aliases": ["Lycos Inc."],
        "roles": ["portal partner"],
        "relationship": "Partnered with Quack on a voice-accessed portal initiative in 2000.",
    },
    {
        "entity_id": "org-uwaterloo",
        "name": "University of Waterloo",
        "type": "organization",
        "aliases": ["Waterloo", "Faculty of Mathematics"],
        "roles": ["talent pipeline", "institutional context"],
        "relationship": "Important institutional context for founders, alumni ties, and later Waterloo-Toronto talent narrative.",
    },
    {
        "entity_id": "org-usask",
        "name": "University of Saskatchewan",
        "type": "organization",
        "aliases": ["USask"],
        "roles": ["retrospective source"],
        "relationship": "Retrospective alumni profile source for the Quack era.",
    },
    {
        "entity_id": "org-sei",
        "name": "Software Engineering Institute",
        "type": "organization",
        "aliases": ["SEI", "Carnegie Mellon Software Engineering Institute"],
        "roles": ["pre-Quack background context"],
        "relationship": "Background institutional context connecting founders to pre-Quack work.",
    },
    {
        "entity_id": "org-bid-com",
        "name": "Bid.com",
        "type": "organization",
        "aliases": ["Bid.Com International Inc.", "Bid.com International"],
        "roles": ["shareholder"],
        "relationship": "Named shareholder in the AOL acquisition coverage with a disclosed stock outcome.",
    },
    {
        "entity_id": "org-e-lab",
        "name": "e-Lab Technology Ventures",
        "type": "organization",
        "aliases": [],
        "roles": ["investor"],
        "relationship": "Named in Quack's initial financing coverage.",
    },
    {
        "entity_id": "org-jefferson-partners",
        "name": "Jefferson Partners",
        "type": "organization",
        "aliases": ["Jefferson Partners Technology Fund LP"],
        "roles": ["investor"],
        "relationship": "Named in Quack's initial financing and later cited in secondary investment-outcome references.",
    },
    {
        "entity_id": "org-hdl-capital",
        "name": "HDL Capital",
        "type": "organization",
        "aliases": ["HDL Capital Corporation"],
        "roles": ["investor"],
        "relationship": "Named in Quack's initial financing coverage and secondary history references.",
    },
    {
        "entity_id": "org-rbc-elab",
        "name": "Royal Bank of Canada e-Lab Technology Ventures",
        "type": "organization",
        "aliases": ["Royal Bank of Canada", "RBC e-Lab Technology Ventures"],
        "roles": ["investor"],
        "relationship": "Named as part of the initial financing round in press coverage.",
    },
]


def ensure_dirs() -> None:
    for path in (RESEARCH_DIR, TOPIC_BRIEFS_DIR, CAMPAIGNS_DIR, ARCHIVE_HTML_DIR):
        path.mkdir(parents=True, exist_ok=True)


def read_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return deepcopy(default)
    return json.loads(path.read_text())


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n")


def now_iso() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def human_readable_today() -> str:
    return datetime.now().strftime("%B %d, %Y").replace(" 0", " ")


def normalize_whitespace(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def strip_tags(value: str) -> str:
    return normalize_whitespace(html.unescape(re.sub(r"<[^>]+>", " ", value)))


def canonicalize_url(url: str | None) -> str:
    if not url:
        return ""
    url = url.strip()
    if not url:
        return url
    parsed = urllib.parse.urlsplit(url)
    scheme = parsed.scheme or "https"
    netloc = parsed.netloc.lower()
    path = parsed.path or "/"
    if path != "/" and path.endswith("/"):
        path = path[:-1]
    return urllib.parse.urlunsplit((scheme, netloc, path, parsed.query, ""))


def domain_of(url: str) -> str:
    netloc = urllib.parse.urlsplit(url).netloc.lower()
    if netloc.startswith("www."):
        return netloc[4:]
    return netloc


def rel_to_root(path: Path) -> str:
    return str(path.relative_to(ROOT))


def rel_to_public(path: Path) -> str:
    return str(path.relative_to(PUBLIC_ROOT))


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or "item"


def sha_suffix(value: str) -> str:
    return hashlib.sha1(value.encode("utf-8")).hexdigest()[:8]


def archive_filename_for_url(url: str, title_hint: str | None = None) -> str:
    parsed = urllib.parse.urlsplit(url)
    source = title_hint or parsed.path.rsplit("/", 1)[-1] or parsed.netloc
    slug = slugify(source)
    if not slug.endswith(".html"):
        slug = f"{slug}.html"
    if len(slug) > 90:
        stem = slug[:-5][:75].rstrip("-")
        slug = f"{stem}-{sha_suffix(url)}.html"
    return slug


def load_search_packs() -> dict[str, Any]:
    return read_json(SEARCH_PACKS_PATH, {"schema_version": "1.0", "packs": []})


def load_leads() -> dict[str, Any]:
    return read_json(
        SOURCE_LEADS_PATH,
        {
            "schema_version": "1.0",
            "project_id": "quack-com",
            "generated_at": None,
            "leads": [],
        },
    )


def extract_quack_review_sources() -> list[dict[str, Any]]:
    text = MEDIA_SOURCES_REVIEW.read_text()
    match = re.search(
        r"## Quack\.com / AOL era media mentions\n\n\| Type \| Title \| Approx\. date \| URL \| Evidence / notes \| Local archive \|\n\| --- \| --- \| --- \| --- \| --- \| --- \|\n(?P<table>(?:\|.*\|\n)+)",
        text,
    )
    if not match:
        return []
    rows = []
    for raw_line in match.group("table").strip().splitlines():
        cols = [part.strip() for part in raw_line.strip().strip("|").split("|")]
        if len(cols) != 6:
            continue
        source_type, title, approx_date, url, notes, local_archive = cols
        entry: dict[str, Any] = {
            "title": title,
            "canonical_url": url if url != "none" else "",
            "source_type_hint": source_type,
            "date_hint": approx_date,
            "notes_hint": notes,
            "source_family": "reputable-third-party-press",
            "research_theme": "company-history",
            "discovered_from": ["media-sources-review"],
            "tags_hint": ["quack", "press"],
        }
        archive_match = re.search(r"`([^`]+)`", local_archive)
        if archive_match:
            entry["existing_local_path"] = str((PUBLIC_ROOT / "data" / "media-appearances" / archive_match.group(1)).resolve())
        rows.append(entry)
    return rows


def load_existing_manifest_sources() -> list[dict[str, Any]]:
    payload = read_json(SOURCE_MANIFEST_PATH, {"sources": []})
    return payload.get("sources", [])


def resolve_existing_archive_path(raw_path: str | None) -> str | None:
    if not raw_path:
        return None
    candidate = Path(raw_path)
    if candidate.is_absolute():
        return str(candidate)
    root_candidate = (ROOT / raw_path).resolve()
    if root_candidate.exists():
        return str(root_candidate)
    public_candidate = (PUBLIC_ROOT / raw_path).resolve()
    if public_candidate.exists():
        return str(public_candidate)
    return str(root_candidate)


def merge_list_unique(existing: list[str], additions: list[str]) -> list[str]:
    seen = set(existing)
    merged = list(existing)
    for item in additions:
        if item not in seen:
            merged.append(item)
            seen.add(item)
    return merged


def lead_key(url: str, title: str) -> str:
    if url:
        return canonicalize_url(url)
    return f"title:{slugify(title)}"


def base_lead_record(source: dict[str, Any]) -> dict[str, Any]:
    canonical_url = canonicalize_url(source.get("canonical_url", ""))
    title_hint = source.get("title") or source.get("title_hint") or ""
    key = lead_key(canonical_url, title_hint)
    return {
        "lead_id": f"lead-{slugify(source.get('lead_id') or title_hint or canonical_url)}",
        "key": key,
        "canonical_url": canonical_url or None,
        "title_hint": title_hint or None,
        "source_family": source.get("source_family", "reputable-third-party-press"),
        "research_theme": source.get(
            "research_theme",
            SOURCE_FAMILY_THEME_MAP.get(source.get("source_family", ""), "company-history"),
        ),
        "source_type_hint": source.get(
            "source_type_hint",
            SOURCE_FAMILY_TYPE_MAP.get(source.get("source_family", ""), "media-mention"),
        ),
        "person_relevance_hint": source.get("person_relevance_hint"),
        "notes_hint": source.get("notes_hint"),
        "date_hint": source.get("date_hint"),
        "quality_hint": source.get("quality_hint", "moderate"),
        "priority": source.get("priority", "medium"),
        "query_pack_id": source.get("query_pack_id"),
        "discovered_from": list(source.get("discovered_from", [])),
        "tags_hint": list(source.get("tags_hint", [])),
        "existing_local_paths": [source["existing_local_path"]] if source.get("existing_local_path") else [],
        "timeline_event": source.get("timeline_event"),
        "entity_mentions_hint": list(source.get("entity_mentions_hint", [])),
        "state": "discovered",
        "duplicate_of": None,
        "fetch": {
            "status": "pending",
            "last_attempt": None,
            "archive_local": None,
            "shared_local": None,
            "http_status": None,
            "error": None,
        },
        "analysis": None,
        "classification": None,
        "manifested": False,
    }


def discover() -> dict[str, Any]:
    ensure_dirs()
    existing = load_leads()
    by_key = {lead["key"]: lead for lead in existing.get("leads", [])}

    def upsert(source: dict[str, Any]) -> None:
        record = base_lead_record(source)
        key = record["key"]
        if key in by_key:
            lead = by_key[key]
            lead["discovered_from"] = merge_list_unique(lead["discovered_from"], record["discovered_from"])
            lead["tags_hint"] = merge_list_unique(lead["tags_hint"], record["tags_hint"])
            lead["existing_local_paths"] = merge_list_unique(lead["existing_local_paths"], record["existing_local_paths"])
            lead["entity_mentions_hint"] = merge_list_unique(
                lead.get("entity_mentions_hint", []),
                record["entity_mentions_hint"],
            )
            for field in (
                "title_hint",
                "source_family",
                "research_theme",
                "source_type_hint",
                "person_relevance_hint",
                "notes_hint",
                "date_hint",
                "quality_hint",
                "priority",
                "query_pack_id",
                "timeline_event",
            ):
                if not lead.get(field) and record.get(field):
                    lead[field] = record[field]
            return
        if record["canonical_url"]:
            for existing_key, lead in list(by_key.items()):
                if not existing_key.startswith("title:"):
                    continue
                same_title = (lead.get("title_hint") or "").strip().lower() == (record.get("title_hint") or "").strip().lower()
                same_path = bool(
                    set(lead.get("existing_local_paths", []))
                    and set(lead.get("existing_local_paths", [])) & set(record.get("existing_local_paths", []))
                )
                if same_title or same_path:
                    lead["key"] = record["key"]
                    lead["canonical_url"] = record["canonical_url"]
                    lead["discovered_from"] = merge_list_unique(lead["discovered_from"], record["discovered_from"])
                    lead["tags_hint"] = merge_list_unique(lead["tags_hint"], record["tags_hint"])
                    lead["existing_local_paths"] = merge_list_unique(lead["existing_local_paths"], record["existing_local_paths"])
                    lead["entity_mentions_hint"] = merge_list_unique(
                        lead.get("entity_mentions_hint", []),
                        record["entity_mentions_hint"],
                    )
                    for field in (
                        "source_family",
                        "research_theme",
                        "source_type_hint",
                        "person_relevance_hint",
                        "notes_hint",
                        "date_hint",
                        "quality_hint",
                        "priority",
                        "query_pack_id",
                        "timeline_event",
                    ):
                        if record.get(field):
                            lead[field] = record[field]
                    del by_key[existing_key]
                    by_key[record["key"]] = lead
                    return
        by_key[key] = record

    for source in extract_quack_review_sources():
        upsert(source)

    for source in load_existing_manifest_sources():
        upsert(
            {
                "title": source["title"],
                "canonical_url": source["urls"].get("canonical"),
                "source_family": "reputable-third-party-press",
                "research_theme": "company-history",
                "source_type_hint": source["source_type"],
                "person_relevance_hint": source.get("person_relevance"),
                "notes_hint": source.get("notes"),
                "date_hint": source["date"]["display"],
                "quality_hint": "strong" if source["status"] == "approved" else "moderate",
                "priority": "high" if source["status"] == "approved" else "medium",
                "discovered_from": ["source-manifest"],
                "tags_hint": source.get("tags", []),
                "existing_local_path": resolve_existing_archive_path(source["urls"].get("archive_local")),
                "lead_id": source["source_id"],
            }
        )

    for pack in load_search_packs().get("packs", []):
        for seed in pack.get("seed_results", []):
            merged = dict(seed)
            merged.setdefault("source_family", pack["source_family"])
            merged.setdefault("research_theme", pack["research_theme"])
            merged.setdefault("query_pack_id", pack["pack_id"])
            merged.setdefault("discovered_from", [f"search-pack:{pack['pack_id']}"])
            upsert(merged)

    leads = sorted(by_key.values(), key=lambda item: (item["research_theme"], item["canonical_url"] or item["title_hint"] or ""))
    payload = {
        "schema_version": "1.0",
        "project_id": "quack-com",
        "generated_at": now_iso(),
        "leads": leads,
    }
    write_json(SOURCE_LEADS_PATH, payload)
    return payload


def local_path_for_lead(lead: dict[str, Any]) -> Path | None:
    archive_local = lead["fetch"].get("archive_local")
    if archive_local:
        path = ROOT / archive_local
        if path.exists():
            return path
    for raw_path in lead.get("existing_local_paths", []):
        path = Path(raw_path)
        if path.exists():
            return path
    return None


def fetch_lead(lead: dict[str, Any], allow_network: bool) -> None:
    lead["fetch"]["last_attempt"] = now_iso()
    existing_path = local_path_for_lead(lead)
    if existing_path and existing_path.exists():
        destination = ARCHIVE_HTML_DIR / existing_path.name
        if existing_path.resolve() != destination.resolve():
            shutil.copy2(existing_path, destination)
        lead["fetch"]["status"] = "local-copy"
        lead["fetch"]["archive_local"] = rel_to_root(destination)
        if str(existing_path).startswith(str(PUBLIC_ROOT)):
            lead["fetch"]["shared_local"] = rel_to_public(existing_path)
        lead["state"] = "fetched"
        return

    canonical_url = lead.get("canonical_url")
    if not canonical_url or not allow_network:
        lead["fetch"]["status"] = "skipped"
        lead["fetch"]["error"] = None if canonical_url else "no-canonical-url"
        return

    domain = domain_of(canonical_url)
    should_archive = domain in FRAGILE_ARCHIVE_DOMAINS or lead["quality_hint"] == "strong"
    request = urllib.request.Request(
        canonical_url,
        headers={"User-Agent": "QuackResearchBot/0.1 (+https://sgwoods.github.io/public/quack/)"},
    )
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            raw = response.read()
            charset = response.headers.get_content_charset() or "utf-8"
            text = raw.decode(charset, errors="replace")
            lead["fetch"]["http_status"] = getattr(response, "status", None)
            lead["fetch"]["status"] = "fetched-remote"
            if should_archive:
                filename = archive_filename_for_url(canonical_url, lead.get("title_hint"))
                destination = ARCHIVE_HTML_DIR / filename
                destination.write_text(text)
                lead["fetch"]["archive_local"] = rel_to_root(destination)
            lead["state"] = "fetched"
    except urllib.error.HTTPError as exc:
        lead["fetch"]["status"] = "blocked"
        lead["fetch"]["http_status"] = exc.code
        lead["fetch"]["error"] = f"http-{exc.code}"
    except Exception as exc:  # noqa: BLE001
        lead["fetch"]["status"] = "failed"
        lead["fetch"]["error"] = str(exc)


def fetch_all(allow_network: bool) -> dict[str, Any]:
    payload = load_leads()
    for lead in payload.get("leads", []):
        fetch_lead(lead, allow_network=allow_network)
    payload["generated_at"] = now_iso()
    write_json(SOURCE_LEADS_PATH, payload)
    return payload


def extract_title(text: str) -> str | None:
    patterns = [
        r'<meta[^>]+property=["\']og:title["\'][^>]+content=["\']([^"\']+)["\']',
        r'<meta[^>]+name=["\']title["\'][^>]+content=["\']([^"\']+)["\']',
        r"<title[^>]*>(.*?)</title>",
        r"<h1[^>]*>(.*?)</h1>",
    ]
    for pattern in patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            return strip_tags(match.group(1))
    return None


def extract_description(text: str) -> str | None:
    patterns = [
        r'<meta[^>]+name=["\']description["\'][^>]+content=["\']([^"\']+)["\']',
        r'<meta[^>]+property=["\']og:description["\'][^>]+content=["\']([^"\']+)["\']',
        r"<p[^>]*>(.*?)</p>",
    ]
    for pattern in patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            return strip_tags(match.group(1))
    return None


def parse_date_info(text: str, date_hint: str | None) -> dict[str, str]:
    patterns = [
        (r'property=["\']article:published_time["\'][^>]+content=["\']([^"\']+)["\']', "day"),
        (r'name=["\']date.release["\'][^>]+content=["\']([^"\']+)["\']', "day"),
        (r'"datePublished":"([^"]+)"', "day"),
        (r"Published:\s*([A-Z][a-z]{2,9}\s+\d{1,2},\s+\d{4})", "day"),
    ]
    for pattern, precision in patterns:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            raw = match.group(1).replace("Z", "+00:00")
            try:
                dt = datetime.fromisoformat(raw)
                display = dt.strftime("%B %-d, %Y")
                sort = dt.date().isoformat()
                return {"display": display, "sort": sort, "precision": precision}
            except ValueError:
                try:
                    dt = datetime.strptime(raw, "%B %d, %Y")
                    return {"display": dt.strftime("%B %-d, %Y"), "sort": dt.date().isoformat(), "precision": precision}
                except ValueError:
                    pass
    if date_hint:
        text_hint = date_hint.strip()
        if re.fullmatch(r"\d{4}-\d{2}-\d{2}", text_hint):
            return {"display": datetime.strptime(text_hint, "%Y-%m-%d").strftime("%B %-d, %Y"), "sort": text_hint, "precision": "day"}
        if re.fullmatch(r"\d{4}-\d{2}", text_hint):
            return {"display": datetime.strptime(text_hint, "%Y-%m").strftime("%B %Y"), "sort": f"{text_hint}-01", "precision": "month"}
        year_match = re.search(r"(19|20)\d{2}", text_hint)
        if year_match:
            year = year_match.group(0)
            precision = "year" if text_hint == year or text_hint.endswith(year) else "approximate"
            return {"display": text_hint, "sort": f"{year}-01-01", "precision": precision}
    return {"display": "Unknown", "sort": "1900-01-01", "precision": "approximate"}


def entity_mentions_from_text(text: str, hints: list[str]) -> list[str]:
    lower = text.lower()
    found: list[str] = []
    for entity in ENTITY_DEFS:
        variants = [entity["name"], *entity["aliases"]]
        if any(variant.lower() in lower for variant in variants):
            found.append(entity["entity_id"])
    for hint in hints:
        for entity in ENTITY_DEFS:
            if hint.lower() == entity["entity_id"].lower() or hint.lower() == entity["name"].lower():
                if entity["entity_id"] not in found:
                    found.append(entity["entity_id"])
    return found


def source_id_for_lead(lead: dict[str, Any], analysis: dict[str, Any]) -> str:
    if lead["lead_id"].startswith("lead-src-"):
        return lead["lead_id"][5:]
    if lead["lead_id"].startswith("src-"):
        return lead["lead_id"]
    year = analysis["date"]["sort"][:4]
    url = lead.get("canonical_url")
    if url:
        parsed = urllib.parse.urlsplit(url)
        path_slug = slugify(parsed.path.rsplit("/", 1)[-1] or parsed.netloc)
    else:
        path_slug = slugify(analysis["title"])
    return f"src-quack-{year}-{path_slug}"


def analyze_all() -> dict[str, Any]:
    payload = load_leads()
    seen_by_source_id: dict[str, str] = {}
    seen_by_local_title: dict[tuple[str, str], str] = {}
    for lead in payload.get("leads", []):
        path = local_path_for_lead(lead)
        text = ""
        if path and path.exists():
            text = path.read_text(errors="replace")
        extracted_title = extract_title(text)
        title_hint = lead.get("title_hint")
        title = extracted_title or title_hint or "Untitled source"
        if title_hint and extracted_title:
            if extracted_title.lower() in title_hint.lower() and len(title_hint) > len(extracted_title):
                title = title_hint
        description = extract_description(text) or lead.get("notes_hint") or ""
        date_info = parse_date_info(text, lead.get("date_hint"))
        entities = entity_mentions_from_text(text + " " + title + " " + description, lead.get("entity_mentions_hint", []))
        analysis = {
            "title": title,
            "description": description,
            "date": date_info,
            "source_type": lead.get("source_type_hint") or SOURCE_FAMILY_TYPE_MAP.get(lead["source_family"], "media-mention"),
            "entities": entities,
            "archive_local": lead["fetch"].get("archive_local"),
            "canonical_url": lead.get("canonical_url"),
        }
        source_id = source_id_for_lead(lead, analysis)
        if source_id in seen_by_source_id:
            lead["duplicate_of"] = source_id
        else:
            seen_by_source_id[source_id] = lead["lead_id"]
        archive_local = analysis.get("archive_local")
        if archive_local:
            local_key = (archive_local, slugify(title))
            if local_key in seen_by_local_title:
                lead["duplicate_of"] = seen_by_local_title[local_key]
            else:
                seen_by_local_title[local_key] = source_id
        analysis["source_id"] = source_id
        lead["analysis"] = analysis
        lead["state"] = "analyzed"
    payload["generated_at"] = now_iso()
    write_json(SOURCE_LEADS_PATH, payload)
    return payload


def auto_classify_status(lead: dict[str, Any]) -> tuple[str, str]:
    analysis = lead["analysis"]
    if lead.get("duplicate_of"):
        return "rejected", "Duplicate lead resolved to an existing source record."

    domain = domain_of(analysis.get("canonical_url") or "")
    archive_local = bool(analysis.get("archive_local"))
    has_clear_date = analysis["date"]["display"] != "Unknown"
    source_family = lead["source_family"]
    if source_family == "secondary-graph":
        return "deferred", "Secondary graph source kept only as a lead and cross-reference, not as sole authority."
    if archive_local and domain in TRUSTED_APPROVED_DOMAINS and has_clear_date:
        return "approved", "Well-attributed source with clear provenance and a local archive copy."
    if domain in {"patents.google.com", "uwaterloo.ca", "alumni.usask.ca"} and has_clear_date:
        return "approved", "Strong official or institutional source with clear date and provenance."
    if lead["fetch"]["status"] in {"blocked", "failed", "skipped"}:
        return "deferred", "Promising lead, but not yet strong enough for approval because local preservation or fetch confirmation is incomplete."
    if domain in TRUSTED_APPROVED_DOMAINS and has_clear_date:
        return "approved", "Reputable source with clear attribution and stable canonical metadata."
    return "deferred", "Useful source lead, but kept deferred under the conservative approval policy."


def infer_lane(lead: dict[str, Any]) -> str:
    theme = lead["research_theme"]
    if theme == "patents-and-ip":
        return "artifacts"
    if theme == "anecdotes-and-cultural-footprint":
        return "memories"
    if theme == "speechworks-and-partners" and "demo" in lead.get("tags_hint", []):
        return "demos"
    return "artifacts"


def infer_person_relevance(lead: dict[str, Any]) -> str:
    hint = lead.get("person_relevance_hint")
    if hint:
        return hint
    title = lead["analysis"]["title"]
    if "Steven Woods" in title:
        return f"{title} helps connect Steven Woods directly to the Quack.com story."
    if "Quack.com" in title:
        return f"This source contributes company-context material for Steven Woods' Quack.com era."
    return "This source helps contextualize Steven Woods' Quack.com era."


def classify_all() -> dict[str, Any]:
    payload = load_leads()
    for lead in payload.get("leads", []):
        if not lead.get("analysis"):
            continue
        status, note = auto_classify_status(lead)
        tags = merge_list_unique(["quack"], lead.get("tags_hint", []))
        classification = {
            "research_theme": lead["research_theme"],
            "archive_lane": infer_lane(lead),
            "status": status,
            "person_hub_use": "summary-ok" if status == "approved" and lead["source_family"] != "secondary-graph" else "do-not-surface-yet",
            "company_deep_link": "preferred",
            "tags": tags,
            "person_relevance": infer_person_relevance(lead),
            "notes": normalize_whitespace(" ".join(filter(None, [lead.get("notes_hint"), note]))),
        }
        lead["classification"] = classification
        lead["state"] = "classified"
    payload["generated_at"] = now_iso()
    write_json(SOURCE_LEADS_PATH, payload)
    return payload


def make_source_manifest(leads: list[dict[str, Any]]) -> dict[str, Any]:
    sources = []
    for lead in leads:
        if not lead.get("analysis") or not lead.get("classification"):
            continue
        status = lead["classification"]["status"]
        if status == "rejected":
            continue
        analysis = lead["analysis"]
        classification = lead["classification"]
        source = {
            "source_id": analysis["source_id"],
            "title": analysis["title"],
            "source_type": analysis["source_type"],
            "company_context": "Quack.com",
            "person_relevance": classification["person_relevance"],
            "date": analysis["date"],
            "urls": {
                "canonical": analysis["canonical_url"],
                "archive_local": analysis["archive_local"],
                "archive_web": None,
            },
            "ownership": {
                "canonical_repo": "quack-com",
                "person_hub_use": classification["person_hub_use"],
                "company_deep_link": classification["company_deep_link"],
            },
            "tags": classification["tags"],
            "status": status,
            "notes": classification["notes"],
        }
        sources.append(source)
        lead["manifested"] = True
        lead["state"] = "manifested"
    sources.sort(key=lambda item: (item["date"]["sort"], item["source_id"]))
    return {
        "schema_version": "1.0",
        "project_id": "quack-com",
        "sources": sources,
    }


def make_public_handoff(sources: list[dict[str, Any]]) -> dict[str, Any]:
    items = []
    for source in sources:
        if source["status"] != "approved":
            continue
        if source["ownership"]["person_hub_use"] != "summary-ok":
            continue
        items.append(
            {
                "source_id": source["source_id"],
                "reason": source["person_relevance"],
                "recommended_section": "career-timeline" if "acquisition" in source["tags"] or "investor" in source["tags"] else "public-appearances",
                "summary": source["notes"][:220],
            }
        )
    return {
        "schema_version": "1.0",
        "project_id": "quack-com",
        "handoff_generated_at": now_iso(),
        "items_for_public": items[:6],
        "open_questions": [
            {
                "question": "Quack remains staged inside the public repo, so the archive repo URL is still unset."
            },
            {
                "question": "Some investor-outcome and Waterloo brain-drain claims still need stronger primary sourcing."
            },
        ],
    }


def build_timeline(leads: list[dict[str, Any]]) -> dict[str, Any]:
    events = []
    seen = set()
    for lead in leads:
        timeline_event = lead.get("timeline_event")
        if not timeline_event or not lead.get("analysis") or lead.get("classification", {}).get("status") == "rejected":
            continue
        source_id = lead["analysis"]["source_id"]
        event_id = timeline_event["event_id"]
        if event_id in seen:
            continue
        seen.add(event_id)
        events.append(
            {
                "event_id": event_id,
                "date": timeline_event["date"],
                "date_confidence": timeline_event.get("date_confidence", "supported"),
                "description": timeline_event["description"],
                "source_ids": [source_id],
            }
        )
    events.sort(key=lambda item: item["date"]["sort"])
    return {
        "schema_version": "1.0",
        "project_id": "quack-com",
        "generated_at": now_iso(),
        "events": events,
    }


def build_entities(leads: list[dict[str, Any]]) -> dict[str, Any]:
    sources_by_entity: dict[str, list[str]] = defaultdict(list)
    for lead in leads:
        analysis = lead.get("analysis")
        if not analysis:
            continue
        for entity_id in analysis["entities"]:
            sources_by_entity[entity_id].append(analysis["source_id"])

    entities = []
    for entity in ENTITY_DEFS:
        entities.append(
            {
                "entity_id": entity["entity_id"],
                "name": entity["name"],
                "type": entity["type"],
                "aliases": entity["aliases"],
                "roles": entity["roles"],
                "relationship": entity["relationship"],
                "source_ids": sorted(set(sources_by_entity.get(entity["entity_id"], []))),
            }
        )
    return {
        "schema_version": "1.0",
        "project_id": "quack-com",
        "generated_at": now_iso(),
        "entities": entities,
    }


def write_topic_briefs(leads: list[dict[str, Any]]) -> None:
    by_theme: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for lead in leads:
        if not lead.get("classification") or lead["classification"]["status"] == "rejected":
            continue
        by_theme[lead["classification"]["research_theme"]].append(lead)

    for theme, title in THEME_TITLES.items():
        items = sorted(
            by_theme.get(theme, []),
            key=lambda lead: (lead["analysis"]["date"]["sort"], lead["analysis"]["source_id"]) if lead.get("analysis") else ("9999", ""),
        )
        lines = [f"# {title}", "", f"Updated: {now_iso()}", ""]
        if items:
            lines.extend(
                [
                    "## Summary",
                    "",
                    f"This brief currently tracks {len(items)} Quack-related source(s) in the `{theme}` lane.",
                    "",
                    "## Source Highlights",
                    "",
                ]
            )
            for lead in items[:8]:
                analysis = lead["analysis"]
                classification = lead["classification"]
                lines.append(
                    f"- `{analysis['source_id']}` ({analysis['date']['display']}, {classification['status']}): {analysis['title']}."
                )
            lines.extend(["", "## Open Questions", ""])
            open_items = [lead for lead in items if lead["classification"]["status"] == "deferred"]
            if open_items:
                for lead in open_items[:5]:
                    lines.append(f"- {lead['analysis']['title']}: {lead['classification']['notes']}")
            else:
                lines.append("- No major open questions in this theme from the current batch.")
        else:
            lines.extend(["No sources are classified into this theme yet.", ""])
        path = TOPIC_BRIEFS_DIR / f"{theme}.md"
        path.write_text("\n".join(lines) + "\n")


def update_project_manifest(source_manifest: dict[str, Any]) -> dict[str, Any]:
    manifest = read_json(PROJECT_MANIFEST_PATH, {})
    approved_sources = [source for source in source_manifest["sources"] if source["status"] == "approved"]
    featured = [source["source_id"] for source in approved_sources[:6]]
    notable_items = [
        {"label": source["title"], "url": source["urls"]["canonical"] or source["urls"]["archive_local"]}
        for source in approved_sources[:4]
    ]
    manifest["project_page_url"] = "https://sgwoods.github.io/public/quack-com.html"
    manifest["repo_pushed_at"] = now_iso()
    manifest["status_generated_at"] = now_iso()
    manifest["status_label"] = "Current phase"
    manifest["status_value"] = "Active research archive"
    manifest["focus_label"] = "Current focus"
    manifest["current_focus"] = "Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press"
    manifest["featured_source_ids"] = featured
    manifest["notable_items"] = notable_items
    return manifest


def write_run_report(leads: list[dict[str, Any]], source_manifest: dict[str, Any], timeline: dict[str, Any]) -> None:
    approved = [lead for lead in leads if lead.get("classification", {}).get("status") == "approved"]
    deferred = [lead for lead in leads if lead.get("classification", {}).get("status") == "deferred"]
    archived = [lead for lead in leads if lead["fetch"].get("archive_local")]
    campaign_cards = read_campaign_cards()
    lines = [
        "# Quack research batch report",
        "",
        f"Generated: {now_iso()}",
        "",
        "## Batch summary",
        "",
        f"- Leads tracked: {len(leads)}",
        f"- Approved manifest sources: {len(source_manifest['sources']) - sum(1 for s in source_manifest['sources'] if s['status'] == 'deferred')}",
        f"- Deferred manifest sources: {sum(1 for s in source_manifest['sources'] if s['status'] == 'deferred')}",
        f"- Locally archived copies in Quack layer: {len(archived)}",
        f"- Timeline events captured: {len(timeline['events'])}",
        "",
        "## What the batch found",
        "",
        "- Strong contemporaneous acquisition, partnership, financing, and market-context coverage from InternetNews, SFGate, and related sources.",
        "- Better visibility into the SpeechWorks relationship, the Lycos partnership, the initial financing round, and the later AOL by Phone / AOL Anywhere story.",
        "- Research leads for investor outcomes, Waterloo recruiting / Canada context, and case-study material that still need stronger sourcing or local preservation.",
        "- Patent pages that support the IP and product-history lane directly from Google Patents.",
        "",
        "## Active campaigns",
        "",
    ]
    if campaign_cards:
        for card in campaign_cards:
            lines.append(f"- {card['title']}: {card['summary']}")
    else:
        lines.append("- No named campaigns are recorded yet.")
    lines.extend(
        [
            "",
        "## Still needs manual follow-up",
        "",
        ]
    )
    for lead in deferred[:8]:
        lines.append(f"- {lead['analysis']['title']}: {lead['classification']['notes']}")
    RUN_REPORT_PATH.write_text("\n".join(lines) + "\n")


def read_next_steps_bullets() -> list[str]:
    if not NEXT_STEPS_PATH.exists():
        return []
    bullets = []
    for line in NEXT_STEPS_PATH.read_text().splitlines():
        stripped = line.strip()
        if stripped.startswith("- "):
            bullets.append(stripped[2:])
    return bullets


def read_campaign_cards() -> list[dict[str, Any]]:
    if not CAMPAIGNS_DIR.exists():
        return []
    cards = []
    for path in sorted(CAMPAIGNS_DIR.glob("*.md")):
        fallback_title = path.stem.replace("-", " ").title()
        title = fallback_title
        summary = ""
        bullets = []
        for raw_line in path.read_text().splitlines():
            line = raw_line.strip()
            if not line:
                continue
            if line.startswith("# "):
                title = line[2:].strip()
                continue
            if not summary and not line.startswith("#") and not line.startswith("- "):
                summary = line
                continue
            if line.startswith("- "):
                bullets.append(line[2:].strip())
        cards.append(
            {
                "title": title,
                "summary": summary,
                "bullets": bullets[:3],
                "path": f"quack/research/campaigns/{path.name}",
            }
        )
    return cards


def render_project_page(project_manifest: dict[str, Any], source_manifest: dict[str, Any], timeline: dict[str, Any], entities: dict[str, Any]) -> None:
    approved = [source for source in source_manifest["sources"] if source["status"] == "approved"]
    deferred = [source for source in source_manifest["sources"] if source["status"] == "deferred"]
    archived_count = sum(1 for source in source_manifest["sources"] if source["urls"].get("archive_local"))
    theme_counts = defaultdict(int)
    tag_counts = defaultdict(int)
    for lead in load_leads().get("leads", []):
        classification = lead.get("classification")
        if classification and classification["status"] != "rejected":
            theme_counts[classification["research_theme"]] += 1
            for tag in classification.get("tags", []):
                tag_counts[tag] += 1

    source_by_tag: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for source in source_manifest["sources"]:
        for tag in source.get("tags", []):
            source_by_tag[tag].append(source)

    def first_linked_source(*tags: str) -> dict[str, Any] | None:
        for tag in tags:
            candidates = sorted(
                source_by_tag.get(tag, []),
                key=lambda source: (
                    0 if source["status"] == "approved" else 1,
                    0 if source["urls"].get("archive_local") else 1,
                    source["date"]["sort"],
                ),
            )
            for source in candidates:
                if source["urls"].get("canonical") or source["urls"].get("archive_local"):
                    return source
        return None

    def source_button(source: dict[str, Any] | None, ghost: bool = False, label: str | None = None) -> str:
        if not source:
            return ""
        href = source["urls"].get("canonical")
        if not href and source["urls"].get("archive_local"):
            href = f'quack/{source["urls"]["archive_local"]}'
        if not href:
            return ""
        button_class = "button button--ghost" if ghost else "button"
        text = label or source["title"]
        return f'<a class="{button_class}" href="{html.escape(href)}">{html.escape(text)}</a>'

    entity_cards = []
    for entity in entities["entities"]:
        if not entity["source_ids"]:
            continue
        entity_cards.append(
            f"""                <article class="card">
                    <h3>{html.escape(entity["name"])}</h3>
                    <p>{html.escape(entity["relationship"])}</p>
                    <div class="detailList">
                        <div><strong>Type</strong> {html.escape(entity["type"])}</div>
                        <div><strong>Linked sources</strong> {len(entity["source_ids"])}</div>
                    </div>
                </article>"""
        )
        if len(entity_cards) == 6:
            break
    source_cards = []
    for source in approved[:6]:
        buttons = []
        if source["urls"].get("canonical"):
            buttons.append(f'<a class="button" href="{html.escape(source["urls"]["canonical"])}">Open canonical source</a>')
        if source["urls"].get("archive_local"):
            buttons.append(f'<a class="button button--ghost" href="quack/{html.escape(source["urls"]["archive_local"])}">Open local archive copy</a>')
        source_cards.append(
            f"""                <article class="card">
                    <h3>{html.escape(source["title"])}</h3>
                    <p>{html.escape(source["person_relevance"])}</p>
                    <div class="detailList">
                        <div><strong>Date</strong> {html.escape(source["date"]["display"])}</div>
                        <div><strong>Status</strong> {html.escape(source["status"])}</div>
                    </div>
                    <div class="links">
                        {' '.join(buttons)}
                    </div>
                </article>"""
        )
    timeline_cards = []
    for event in timeline["events"][:6]:
        timeline_cards.append(
            f"""                <article class="timelineCard">
                    <span class="timelineYear">{html.escape(event["date"]["display"])}</span>
                    <h3>{html.escape(event["description"])}</h3>
                    <p>{len(event["source_ids"])} linked source(s) in the current Quack research batch.</p>
                </article>"""
        )
    next_steps = "".join(f"<li>{html.escape(item)}</li>" for item in read_next_steps_bullets())
    campaign_cards = []
    for card in read_campaign_cards():
        bullet_html = "".join(f"<li>{html.escape(item)}</li>" for item in card["bullets"])
        campaign_cards.append(
            f"""                <article class="card">
                    <h3>{html.escape(card["title"])}</h3>
                    <p>{html.escape(card["summary"])}</p>
                    <ol class="checkpointList">
                        {bullet_html}
                    </ol>
                    <div class="links">
                        <a class="button button--ghost" href="{html.escape(card["path"])}">Open campaign note</a>
                    </div>
                </article>"""
        )
    tag_row = "".join(
        f'<span class="tag">{html.escape(label)}</span>'
        for label in [
            "Voice portals",
            "SpeechWorks",
            "AOL acquisition",
            "Waterloo ties",
            "Patents and IP",
        ]
    )
    lane_cards = []
    lane_info = [
        ("company-history", "Company history"),
        ("speechworks-and-partners", "SpeechWorks and partners"),
        ("investors-and-outcomes", "Investors and outcomes"),
        ("waterloo-canada-relationship", "Waterloo and Canada relationship"),
        ("patents-and-ip", "Patents and IP"),
        ("key-individuals", "Key individuals"),
    ]
    for theme_id, label in lane_info:
        lane_cards.append(
            f"""                <article class="card">
                    <h3>{html.escape(label)}</h3>
                    <p>Current tracked sources in this lane.</p>
                    <div class="detailList">
                        <div><strong>Tracked sources</strong> {theme_counts.get(theme_id, 0)}</div>
                        <div><strong>Brief</strong> <code>public/quack/research/topic-briefs/{html.escape(theme_id)}.md</code></div>
                    </div>
                </article>"""
        )
    current_state_cards = [
        {
            "title": "Research workspace is now active",
            "body": "Quack now has a repeatable research batch with source leads, timeline output, entity extraction, topic briefs, and a machine-assisted run report living inside the archive layer.",
            "details": [
                f"<strong>Internal outputs</strong> 5 core research surfaces",
                "<strong>Formal exports</strong> project, source, and public handoff manifests",
            ],
        },
        {
            "title": "The company story is broader than the exit",
            "body": "The current batch no longer treats Quack as only an AOL acquisition footnote. It now tracks the Lycos partnership, SpeechWorks stack, financing trail, Waterloo context, and patent footprint.",
            "details": [
                f"<strong>Partner-linked sources</strong> {tag_counts.get('speechworks', 0) + tag_counts.get('lycos', 0) + tag_counts.get('partner', 0)}",
                f"<strong>Investor-linked sources</strong> {tag_counts.get('investors', 0) + tag_counts.get('venture', 0) + tag_counts.get('investor-outcome', 0)}",
            ],
        },
        {
            "title": "Local preservation has started",
            "body": "Strong or fragile sources are now being copied into the Quack layer, which keeps the archive useful even when older web coverage disappears or changes.",
            "details": [
                f"<strong>Local archive copies</strong> {archived_count}",
                "<strong>Demo lane seeded</strong> video and retrospective leads file created",
            ],
        },
        {
            "title": "Archive coordination is explicit",
            "body": "Quack remains staged inside the public repo, but the contract boundary is now visible: company-specific interpretation stays here and only short Steven-relevant summaries flow upward.",
            "details": [
                "<strong>Ownership split</strong> Quack archive deep, public hub summary",
                "<strong>Open issue</strong> eventual repo split still deferred",
            ],
        },
    ]
    current_state_html = []
    for card in current_state_cards:
        detail_lines = "".join(f"<div>{detail}</div>" for detail in card["details"])
        current_state_html.append(
            f"""                <article class="card">
                    <h3>{html.escape(card["title"])}</h3>
                    <p>{html.escape(card["body"])}</p>
                    <div class="detailList">
                        {detail_lines}
                    </div>
                </article>"""
        )
    phase_cards = [
        {
            "heading": "1998 to 1999: Quackware to Quack.com",
            "body": "The earliest lane now includes financing and founder-context leads that help explain how the company emerged from the Waterloo and SEI-adjacent background into the late dot-com voice-portal market.",
            "buttons": [
                source_button(first_linked_source("investors", "venture"), label="Financing lead"),
                source_button(first_linked_source("waterloo", "alumni"), ghost=True, label="Waterloo / alumni context"),
            ],
        },
        {
            "heading": "May 2000: Voice-portal market moment",
            "body": "Lycos partnership coverage and broader market reporting show Quack pushing the idea of web information by phone at the same moment voice portals were briefly becoming a visible internet category.",
            "buttons": [
                source_button(first_linked_source("lycos"), label="Lycos partnership"),
                source_button(first_linked_source("market", "voice-portal"), ghost=True, label="Voice-portal feature"),
            ],
        },
        {
            "heading": "August 2000: AOL acquisition and product integration",
            "body": "Acquisition coverage plus the AOL Anywhere and AOL by Phone leads connect Quack to a larger platform strategy where SpeechWorks and Quack technology became part of AOL's voice access push.",
            "buttons": [
                source_button(first_linked_source("acquisition"), label="AOL acquisition"),
                source_button(first_linked_source("aol-by-phone", "speechworks"), ghost=True, label="AOL by Phone lead"),
            ],
        },
        {
            "heading": "Aftermath: patents, retrospectives, and open questions",
            "body": "The archive now reaches beyond the sale through patents, later alumni profiles, and retrospective talks, while investor outcomes, business-case material, and stronger primary sourcing remain active follow-up campaigns.",
            "buttons": [
                source_button(first_linked_source("patent"), label="Patent record"),
                source_button(first_linked_source("retrospective", "appearance"), ghost=True, label="Retrospective source"),
            ],
        },
    ]
    phase_html = []
    for phase in phase_cards:
        buttons = " ".join(button for button in phase["buttons"] if button)
        phase_html.append(
            f"""                <article class="timelineStep">
                    <h3>{html.escape(phase["heading"])}</h3>
                    <p>{html.escape(phase["body"])}</p>
                    <div class="links">
                        {buttons}
                    </div>
                </article>"""
        )
    preservation_cards = [
        (
            "Provenance first",
            "Keep the original source path, date confidence, and archive status visible so later interpretation stays auditable.",
        ),
        (
            "Runnable when possible",
            "Demo, audio, and interface material should be preserved in ways that support later reconstruction instead of only textual description.",
        ),
        (
            "Context over fragments",
            "A fragment is useful, but the archive should keep enough company, partner, and market context that each artifact still makes sense years later.",
        ),
    ]
    preservation_html = []
    for title, body in preservation_cards:
        preservation_html.append(
            f"""                <article class="card">
                    <h3>{html.escape(title)}</h3>
                    <p>{html.escape(body)}</p>
                </article>"""
        )
    html_doc = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quack.com Archive Project</title>
    <link rel="stylesheet" href="assets/public-site.css">
    <style>
        :root {{
            --bg: #120d0b;
            --bg2: #1f3040;
            --panel-bg: rgba(18, 12, 9, 0.74);
            --panel-glow: rgba(255, 176, 82, 0.18);
            --card-bg: rgba(255, 248, 236, 0.06);
            --card-border: rgba(255, 224, 185, 0.12);
            --panel-border: rgba(255, 192, 120, 0.22);
            --button-bg: rgba(98, 214, 202, 0.16);
            --button-border: rgba(98, 214, 202, 0.3);
            --button-bg-ghost: rgba(255, 255, 255, 0.04);
            --text: #fff7ea;
            --muted: #dcc9b1;
            --muted-strong: #fff1d8;
            --accent: #ffb052;
            --shadow: 0 18px 40px rgba(0, 0, 0, 0.34);
        }}

        body {{
            background:
                radial-gradient(circle at top left, rgba(255, 176, 82, 0.18), transparent 24%),
                radial-gradient(circle at top right, rgba(98, 214, 202, 0.18), transparent 30%),
                linear-gradient(160deg, var(--bg), var(--bg2));
        }}

        .timeline {{
            display: grid;
            gap: 16px;
        }}

        .timelineStep {{
            position: relative;
            padding: 20px 20px 20px 24px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--card-border);
        }}

        .timelineStep::before {{
            content: "";
            position: absolute;
            left: 0;
            top: 18px;
            bottom: 18px;
            width: 4px;
            border-radius: 999px;
            background: linear-gradient(180deg, rgba(255, 176, 82, 0.94), rgba(98, 214, 202, 0.92));
        }}

        .timelineCard {{
            padding: 20px;
            border-radius: 22px;
            background: linear-gradient(180deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.03));
            border: 1px solid var(--card-border);
        }}

        .timelineYear {{
            display: inline-block;
            margin-bottom: 10px;
            color: var(--accent);
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }}

        .tagRow {{
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 18px;
        }}

        .tag {{
            display: inline-flex;
            align-items: center;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 224, 185, 0.14);
            color: var(--muted-strong);
            font-size: 12px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }}

        .checkpointList {{
            margin: 0;
            padding-left: 18px;
            color: var(--muted);
        }}

        .checkpointList li + li {{
            margin-top: 8px;
        }}

        .quote {{
            margin: 0;
            padding: 18px 20px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 224, 185, 0.12);
            color: var(--muted-strong);
            font-size: 18px;
            line-height: 1.6;
        }}

        .quote strong {{
            color: var(--text);
        }}
    </style>
</head>
<body>
    <!-- Generated by quack/tools/quack_research_pipeline.py -->
    <main class="shell">
        <section class="hero">
            <div class="heroTop">
                <span class="eyebrow">Public Project Page</span>
                <a class="heroHomeLink" href="https://sgwoods.github.io/public">Steven Woods</a>
            </div>
            <h1>{html.escape(project_manifest["display_name"])}</h1>
            <p class="lead">{html.escape(project_manifest["description"])} {html.escape(project_manifest["person_context"])}</p>
            <div class="meta">
                <div class="metaCard">
                    <span class="metaLabel">Current Phase</span>
                    <span class="metaValue">Active research archive</span>
                    <div class="metaNote">Quack now has a repeatable batch workflow, preserved local copies, and formal public handoff files.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Timeline Span</span>
                    <span class="metaValue">1998 to 2000+</span>
                    <div class="metaNote">Coverage now starts before the AOL deal and extends into patents, alumni profiles, and retrospective talks.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Current Focus</span>
                    <span class="metaValue">{html.escape(project_manifest["current_focus"])}</span>
                    <div class="metaNote">Research outputs now live in the Quack archive layer and feed the public summary downstream.</div>
                </div>
                <div class="metaCard">
                    <span class="metaLabel">Updated</span>
                    <span class="metaValue">{html.escape(human_readable_today())}</span>
                    <div class="metaNote">{len(approved)} approved sources, {len(deferred)} deferred leads, and {archived_count} local archive copies currently shape the summary.</div>
                </div>
            </div>
            <div class="tagRow" aria-label="Archive themes">
                {tag_row}
            </div>
            <div class="links">
                <a class="button" href="quack/">Open working repository</a>
                <a class="button" href="quack/source-manifest.json">Open source manifest</a>
                <a class="button button--ghost" href="quack/research/run-report.md">Open run report</a>
            </div>
        </section>

        <section class="panel">
            <h2>Current State</h2>
            <div class="grid">
{''.join(current_state_html)}
            </div>
        </section>

        <section class="panel">
            <h2>Archive Timeline</h2>
            <div class="timeline">
{''.join(phase_html)}
            </div>
        </section>

        <section class="panel">
            <h2>Research Coverage</h2>
            <p class="lead">The current batch covers contemporaneous press, partners, financing, patents, retrospective institutional sources, and secondary graph leads for follow-up.</p>
            <div class="grid">
{''.join(lane_cards)}
            </div>
        </section>

        <section class="panel">
            <h2>Current Campaigns</h2>
            <p class="lead">This pause point leaves Quack with named follow-up campaigns instead of loose deferred notes, so the next pass can resume from focused work instead of re-discovery.</p>
            <div class="grid">
{''.join(campaign_cards)}
            </div>
        </section>

        <section class="panel">
            <h2>Batch Timeline Highlights</h2>
            <div class="timeline">
{''.join(timeline_cards)}
            </div>
        </section>

        <section class="panel">
            <h2>Key People and Organizations</h2>
            <div class="grid">
{''.join(entity_cards)}
            </div>
            <div class="links">
                <a class="button button--ghost" href="quack/research/related-people-index-todo.md">Open related people to-do</a>
            </div>
        </section>

        <section class="panel">
            <h2>Featured Sources</h2>
            <div class="grid">
{''.join(source_cards)}
            </div>
        </section>

        <section class="panel">
            <h2>Preservation Priorities</h2>
            <p class="quote"><strong>Quack should be preserved as a company story, not just a set of clippings.</strong> The Kinitos work usefully reinforced three guardrails that now apply here as well: provenance first, runnable when possible, and context over fragments.</p>
            <div class="grid" style="margin-top: 18px;">
{''.join(preservation_html)}
            </div>
        </section>

        <section class="panel">
            <h2>Next Steps Informed By Kinitos</h2>
            <p class="lead">The Kinitos archive already surfaced a few practical patterns that Quack can use immediately: explicit demo leads, phase framing, and preservation priorities that keep context from drifting.</p>
            <ol class="checkpointList">
{next_steps}
            </ol>
            <div class="links">
                <a class="button" href="quack/research/next-steps-from-kinitos.md">Open next-step note</a>
                <a class="button button--ghost" href="quack/historic/demos/video-leads.md">Open Quack demo leads</a>
            </div>
        </section>

        <section class="panel">
            <h2>Shared Workflow</h2>
            <p class="lead">Quack and Kinitos now share the same <code>company-research</code> skill so discovery, preservation, classification, manifests, and public handoff stay on one evolving workflow instead of splitting into project-specific habits.</p>
            <div class="links">
                <a class="button" href="quack/README.md">Open Quack workflow notes</a>
                <a class="button button--ghost" href="quack/project-manifest.json">Open project manifest</a>
            </div>
        </section>
    </main>
</body>
</html>
"""
    PROJECT_PAGE_OUTPUT.write_text(html_doc)


def sync_public_project_card_manifest(project_manifest: dict[str, Any], source_manifest: dict[str, Any]) -> None:
    card_manifest = read_json(PUBLIC_PROJECT_CARD_MANIFEST_PATH, {})
    card_manifest.update(
        {
            "schema_version": "1.0",
            "project_id": "quack-com",
            "active": True,
            "display_name": project_manifest["display_name"],
            "description": "Public project page for the Quack.com archive, including deep research, preserved sources, partner context, patents, and next-step planning.",
            "project_page_path": "quack-com.html",
            "repo_url": "",
            "dashboard_url": None,
            "experience_url": None,
            "repo_pushed_at": project_manifest["repo_pushed_at"],
            "status_generated_at": project_manifest["status_generated_at"],
            "status_label": "Current phase",
            "status_value": "Active research archive",
            "focus_label": "Current focus",
            "focus_value": project_manifest["current_focus"],
        }
    )
    write_json(PUBLIC_PROJECT_CARD_MANIFEST_PATH, card_manifest)


def summarize_all() -> None:
    payload = load_leads()
    leads = payload.get("leads", [])
    source_manifest = make_source_manifest(leads)
    timeline = build_timeline(leads)
    entities = build_entities(leads)
    public_handoff = make_public_handoff(source_manifest["sources"])
    project_manifest = update_project_manifest(source_manifest)

    write_json(SOURCE_MANIFEST_PATH, source_manifest)
    write_json(PUBLIC_HANDOFF_PATH, public_handoff)
    write_json(PROJECT_MANIFEST_PATH, project_manifest)
    write_json(TIMELINE_PATH, timeline)
    write_json(ENTITIES_PATH, entities)
    write_topic_briefs(leads)
    write_run_report(leads, source_manifest, timeline)
    render_project_page(project_manifest, source_manifest, timeline, entities)
    sync_public_project_card_manifest(project_manifest, source_manifest)
    payload["generated_at"] = now_iso()
    write_json(SOURCE_LEADS_PATH, payload)


def validate_outputs() -> None:
    for path in (
        SEARCH_PACKS_PATH,
        SOURCE_LEADS_PATH,
        TIMELINE_PATH,
        ENTITIES_PATH,
        PROJECT_MANIFEST_PATH,
        SOURCE_MANIFEST_PATH,
        PUBLIC_HANDOFF_PATH,
    ):
        json.loads(path.read_text())


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("discover")
    fetch_parser = sub.add_parser("fetch")
    fetch_parser.add_argument("--allow-network", action="store_true")
    sub.add_parser("analyze")
    sub.add_parser("classify")
    sub.add_parser("summarize")
    run_parser = sub.add_parser("run")
    run_parser.add_argument("--allow-network", action="store_true")
    sub.add_parser("validate")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    if args.command == "discover":
        discover()
    elif args.command == "fetch":
        discover()
        fetch_all(allow_network=args.allow_network)
    elif args.command == "analyze":
        analyze_all()
    elif args.command == "classify":
        classify_all()
    elif args.command == "summarize":
        summarize_all()
    elif args.command == "run":
        discover()
        fetch_all(allow_network=args.allow_network)
        analyze_all()
        classify_all()
        summarize_all()
    elif args.command == "validate":
        validate_outputs()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
