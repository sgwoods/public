#!/usr/bin/env python3
"""Validate a dated maintainer review and compare it with current content signals."""
import argparse
from collections import Counter
from datetime import date, datetime
import json
from pathlib import Path
import re
from zoneinfo import ZoneInfo

import content_inventory as ci

ROOT = Path(__file__).resolve().parents[1]
LEDGER = "data/content/request-triage.json"
REPORT = "CONTENT-REQUEST-TRIAGE.md"
STATES = {"resolved", "ready", "in_progress", "deferred", "blocked_user", "quarantined"}


def validate(ledger, root=ROOT):
    if ledger.get("schema_version") != "1.0":
        raise ValueError("Unsupported request triage schema")
    date.fromisoformat(ledger["reviewed_on"])
    baseline = ledger["baseline"]
    if not re.fullmatch(r"[0-9a-f]{40}", baseline["commit"]):
        raise ValueError("Triage baseline must be a pinned full commit")
    raw = ci.git(root, "show", baseline["commit"] + ":data/content/update-requests.json")
    if ci.digest(raw) != baseline["requests_sha256"]:
        raise ValueError("Historical request queue hash mismatch")
    original = {entry["request_id"]: entry for entry in json.loads(raw)["requests"]}
    entries = ledger["entries"]
    if len({entry["request_id"] for entry in entries}) != len(entries):
        raise ValueError("Duplicate triage request ID")
    if set(original) != {entry["request_id"] for entry in entries} or len(entries) != baseline["request_count"]:
        raise ValueError("Triage must cover every request in its historical baseline exactly once")
    all_entries = entries + ledger.get("followup_entries", [])
    if len({entry["request_id"] for entry in all_entries}) != len(all_entries):
        raise ValueError("Duplicate baseline/follow-up request ID")
    batches = {item["batch_id"] for item in ledger["batches"]}
    questions = {item["question_id"] for item in ledger["questions"]}
    tracked = set(ci.git(root, "ls-files", "-z").decode().split("\0"))
    if len(batches) != len(ledger["batches"]) or len(questions) != len(ledger["questions"]):
        raise ValueError("Duplicate batch/question ID")
    for question in ledger["questions"]:
        if question["answer_state"] == "answered" and not question.get("decision"):
            raise ValueError("Answered questions need the public-safe direction recorded")
    for entry in all_entries:
        old = original.get(entry["request_id"])
        if old is not None:
            if any(entry[key] != old[key] for key in ("content_id", "reason", "owner")):
                raise ValueError("Historical request identity changed")
        elif entry["request_id"] != ci.digest((entry["content_id"] + ":" + entry["reason"]).encode())[:20]:
            raise ValueError("Follow-up request identity must match the signal generator")
        if entry["state"] not in STATES or entry["batch_id"] not in batches:
            raise ValueError("Unknown triage state/batch")
        if not set(entry["question_ids"]) <= questions:
            raise ValueError("Unknown question reference")
        if entry["automatic_fetch"] or entry["changes_release_status"]:
            raise ValueError("Triage cannot fetch or change project release labels")
        if entry["state"] == "resolved" and not entry["evidence_paths"]:
            raise ValueError("Resolved decisions need evidence")
        for name in entry["evidence_paths"]:
            path = ci.safe_local(root, name)
            if ci.private_path(name) or not path.is_file() or name not in tracked:
                raise ValueError("Missing or private triage evidence")
        ci.safe_url(entry.get("canonical_url"))
    for draft in ledger["outreach_drafts"]:
        if draft.get("sent"):
            raise ValueError("This register contains unsent drafts only; record authorized outreach separately")
        for url in draft.get("contact_routes", []):
            ci.safe_url(url)
    return ledger


def render(ledger):
    counts = Counter(entry["state"] for entry in ledger["entries"])
    lines = ["# Content Request Triage", "", "Generated from `data/content/request-triage.json`; change that reviewed decision register, not this report.", "",
             f"Reviewed: **{ledger['reviewed_on']}**. Baseline: **{ledger['baseline']['request_count']} signals**, pinned to `{ledger['baseline']['commit']}`.", "",
             "; ".join(f"**{count} {state.replace('_', ' ')}**" for state, count in sorted(counts.items())) + ".", "",
             ledger["summary"], "", "This is a dated triage, not a daily re-review or a claim that all gaps are closed. New signals and reopened resolutions are reported by `python3 tools/triage_content_requests.py status`. The generated signal queue remains separate.", "",
             "## Decisions For Steven", "", "Recommendations below are not submitted answers. Return private locations privately, not in a GitHub issue or this register.", ""]
    if ledger.get("last_cycle_report"):
        lines[2:2] = [f"Current cycle: [Text-first recovery and review gates]({ledger['last_cycle_report']}).", ""]
    for question in ledger["questions"]:
        lines += [f"### {question['question_id']}: {question['title']}", "", question["question"], "",
                  f"Recommendation: **{question['recommended']}**", "", f"Options: {'; '.join(question['options'])}.", "",
                  f"Blocks: {question['blocks']}. Answer state: `{question['answer_state']}`.", ""]
        if question.get("decision"):
            lines += [f"Recorded direction: **{question['decision']}**", ""]
    lines += ["## Ranked Work Batches", "", "Effort ranges are rough maintainer planning estimates, not measured duration, spending approval or a promise. Stop at the stated gate rather than expanding a blocked search.", ""]
    for batch in sorted(ledger["batches"], key=lambda item: item["rank"]):
        members = [entry for entry in ledger["entries"] + ledger.get("followup_entries", []) if entry["batch_id"] == batch["batch_id"]]
        noun = "signal" if len(members) == 1 else "signals"
        lines += [f"### {batch['rank']}. {batch['title']}", "", f"{len(members)} baseline {noun}. {batch['value']}", "",
                  f"Effort: {batch['effort']}. Next: {batch['next_action']}", "", f"Stop gate: {batch['stop_gate']}.", ""]
    lines += ["## Unsent Organizer Questions", "", "Drafts only. No recipient has been contacted, no private artifact attached and no contact detail inferred. Steven must approve outreach and its sender/channel first.", ""]
    for draft in ledger["outreach_drafts"]:
        lines += [f"### {draft['draft_id']}: {draft['recipient_role']}", "", draft["body"], ""]
        if draft.get("contact_routes"):
            lines += ["Future official routes (unsent): " + "; ".join(f"[Contact page]({url})" for url in draft["contact_routes"]), ""]
    lines += ["## Every Baseline Request", "", "Source approval/status is unchanged. A reused capture resolves a copy-discovery signal, not authorship, republication permission, exact-edition review or voice approval.", "",
              "| Request / Source | Original Signal | Disposition | Evidence / Next Action |", "| --- | --- | --- | --- |"]
    for entry in sorted(ledger["entries"], key=lambda item: (item["batch_id"], item["content_id"])):
        evidence = "; ".join(f"[{Path(name).name}]({name})" for name in entry["evidence_paths"])
        detail = entry["decision"] + (" Evidence: " + evidence if evidence else "")
        cells = [f"`{entry['request_id']}` / {entry['title']} (`{entry['content_id']}`)", entry["reason"],
                 f"{entry['state']} / {entry['batch_id']}", detail]
        lines.append("| " + " | ".join(cell.replace("|", "\\|").replace("\n", " ") for cell in cells) + " |")
    if ledger.get("followup_entries"):
        lines += ["", "## Explicitly Reviewed Follow-up Signals", "", "These are additional signals introduced after the pinned baseline, not silent rewrites of its original request identities.", ""]
        for entry in ledger["followup_entries"]:
            lines += [f"- `{entry['request_id']}` / `{entry['content_id']}`: **{entry['state']}** ({entry['reason']}). {entry['decision']}"]
    lines += ["", "## Maintenance", "", "Update a decision only with evidence or Steven's explicit direction. Preserve request IDs and the historical baseline. After each catalog refresh, run `python3 tools/triage_content_requests.py status`; unmatched requests need a new dated cycle, not silent suppression. A due review is not evidence that a historical source is wrong.", "",
              "No unreviewed transcript, LinkedIn export, private location, credential or user answer containing private information belongs in these public files. The public-information maintainer does the work; other machines consume approved results and request changes.", ""]
    return "\n".join(lines)


def compare(ledger, requests):
    decisions = {entry["request_id"]: entry for entry in ledger["entries"] + ledger.get("followup_entries", [])}
    active = {entry["request_id"]: entry for entry in requests["requests"]}
    rows = []
    for identifier, signal in sorted(active.items()):
        entry = decisions.get(identifier)
        state = "untriaged" if entry is None else ("reopened_needs_review" if entry["state"] == "resolved" else entry["state"])
        rows.append(dict(request_id=identifier, content_id=signal["content_id"], reason=signal["reason"],
                         triage_state=state, batch_id=entry["batch_id"] if entry else None,
                         question_ids=entry["question_ids"] if entry else []))
    return dict(schema_version="1.0", evaluated_on=requests["evaluated_on"],
                semantics="Signals compared with dated decisions; no messages sent and no source/release status changed.",
                active_signal_count=len(rows), counts=dict(sorted(Counter(row["triage_state"] for row in rows).items())),
                resolved_baseline_signals_absent=[entry["request_id"] for entry in ledger["entries"] if entry["state"] == "resolved" and entry["request_id"] not in active],
                resolved_followup_signals_absent=[entry["request_id"] for entry in ledger.get("followup_entries", []) if entry["state"] == "resolved" and entry["request_id"] not in active],
                signals=rows)


def verified_triage_catalog(root=ROOT):
    catalog = ci.verify_bundle(root)
    artifacts = {row["path"]: row for row in map(json.loads, (root / ci.OUTPUTS[1]).read_text().splitlines())}
    if LEDGER not in artifacts or artifacts[LEDGER].get("sha256") != ci.digest((root / LEDGER).read_bytes()):
        raise ValueError("Triage register differs from the verified catalog; refresh from one revision")
    return catalog


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["render", "check", "status"])
    parser.add_argument("--as-of", type=date.fromisoformat)
    parser.add_argument("--schema", action="store_true", help="Also validate the formal schema with the optional test dependency")
    args = parser.parse_args()
    ledger = validate(json.loads((ROOT / LEDGER).read_text()))
    if args.schema:
        import jsonschema
        schema = json.loads((ROOT / "data/content/schema.json").read_text())
        jsonschema.Draft202012Validator({**schema, "$ref": "#/$defs/request_triage"},
                                       format_checker=jsonschema.FormatChecker()).validate(ledger)
    expected = render(ledger)
    if args.command == "render":
        (ROOT / REPORT).write_text(expected)
        print("Rendered dated request triage; no request sent or source fetched.")
    elif args.command == "check":
        if (ROOT / REPORT).read_text() != expected:
            raise ValueError("Request triage report needs regeneration")
        print(f"Triage covers all {len(ledger['entries'])} historical requests; evidence and report validated.")
    else:
        catalog = verified_triage_catalog()
        sources = json.loads((ROOT / ci.OUTPUTS[2]).read_text())["sources"]
        requests = ci.update_requests(sources, args.as_of or datetime.now(ZoneInfo("America/Toronto")).date())
        result = compare(ledger, requests)
        result["catalog_source_tree_sha256"] = catalog["source_tree_sha256"]
        print(ci.dumps(result), end="")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, KeyError) as error:
        raise SystemExit(str(error))
