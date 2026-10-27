# Steven Woods Research Living Work Plan

Last updated: `2026-10-27`

This is the living execution plan for the Steven Woods public-record archive. Keep it current as the continuity layer, preservation baseline, and shared-layer role evolve.

## Operating rule

Active Steven archive work should happen from the canonical shared-public checkout:

- `/Users/steven/Projects-All/public`

The canonical deep archive root inside that checkout is:

- `/Users/steven/Projects-All/public/steven-woods-research`

Do not treat older `GitPages/public` paths, ad hoc top-level notes, or cross-project copies as the active Steven archive workspace.

## Current project goal

Preserve the canonical person-centric public record for Steven Woods, including:

- talks, interviews, podcasts, and keynotes
- institutional profiles, awards, and current-role baseline pages
- cross-company media mentions where Steven Woods is the person-level focus
- locally preserved source captures and supporting review notes
- short public-facing handoff material for the top-level `public` hub

## Current state

- the Steven manifest triad exists and parses cleanly
- the working repository page exists at `public/steven-woods-research/index.html`
- the public summary page exists at `public/steven-woods-research.html`
- current machine-readable counts are `22` total / `22` approved / `0` deferred / `0` rejected
- `21` approved source records resolve to local archive files
- LinkedIn is the only approved baseline/profile source without a local content capture
- Inovia, bio.link and Wikipedia content captures and provenance were added October 26; historical/review dates are unchanged
- [The repository content inventory](../CONTENT-INVENTORY.md) distinguishes text, recordings, transcripts, Git provenance and external checks across the entire versioned tree
- Supporting captures and sidecars need not be standalone source-manifest entries; use the inventory rather than stale hand-maintained file counts
- Quack intentionally uses this project as supporting person-centric context, but company-specific depth still belongs in Quack

## Active plan

### Phase 1: continuity hardening

Status: `completed`

Goals:

- make the Steven archive restartable from the canonical `Projects-All/public` workspace
- add repo-owned continuity and portability docs
- add a dedicated startup validator instead of relying on memory or inference
- make the source-of-truth split explicit

Completed checkpoint:

- the project now has a living work plan, workspace-status note, dated recovery audit, and startup validator
- the working and public pages now expose continuity surfaces more explicitly
- the split between `source-manifest.json` and `research/media-sources-review.md` is documented directly in the repo

### Phase 2: preservation completeness

Status: `in progress`

Goals:

- reduce dependency on fragile live profile pages
- keep the person-centric archive usable if external pages drift
- preserve overlap sources without taking ownership away from company archives

Current checkpoint:

- `21` approved Steven source records now resolve to local archive files
- LinkedIn remains blocked for public capture; authenticated account views were not archived
- the review ledger is reconciled with the October 26 profile captures
- speech recordings have explicit per-source links; no full transcript is catalogued in the public baseline
- the SlideShare identity concern blocks voice use independently of its legacy source approval
- several additional checked-in captures already exist in the review ledger and should be reconciled deliberately rather than silently ignored

Priority queue:

- recover private transcripts before retranscribing, and keep LinkedIn exports/unreviewed speech text outside this public checkout
- extract and review existing first-person Q&A before broad new sourcing
- recheck current profiles when documented successful source checks become due; do not age-expire historical papers
- decide which review-ledger-only captures should become formal source-manifest entries
- keep Quack and Kinitos overlap sources person-centric here and company-centric there

### Phase 3: structured archive follow-through

Status: `later`

Goals:

- continue source enrichment without losing the continuity discipline
- keep person-level interpretation here while company-level detail stays in company archives

Tasks:

- reconcile review-ledger-only captures against the manifest triad
- continue exact dating and context tightening for older talks and profiles
- keep `project-manifest.json`, `source-manifest.json`, `public-handoff.json`, `steven-woods-research/index.html`, and `steven-woods-research.html` aligned after material archive changes

## Practical next-step path from here

1. Start every new Steven archive session from `/Users/steven/Projects-All/public`.
2. Run `bash steven-woods-research/tools/start-steven-woods-codex.sh` before substantive continuity-sensitive work.
3. Read `WORKSPACE-STATUS.md` and `PROJECT-STATE-AND-RECOVERY-2026-05-10.md` before expanding the archive.
4. Continue with preservation completeness and manifest/review-ledger reconciliation, not a broad research redesign.
5. Use `../IMAC-CONTENT-HANDOFF.md` and `../CONTENT-INVENTORY-INTERFACE.md` for cross-machine ingestion, freshness review requests and private staging rules.

## Public Maintainer And Consumer Requests

This public-repository effort owns public-information gathering, verification,
transcript production/review in private staging, source metadata, indexes and
publication. The other Mac consumes approved content and returns requests; it
does not produce this archive's transcripts or maintain parallel public indexes.
Triage its public-safe request IDs here, retaining the catalog digest and evidence.
Do not copy unreviewed transcripts or LinkedIn exports into this work plan.

Current checkpoint: the repository-wide inventory and request triage are live.
Steven approved text-first recovery, local private transcription when prior work
is not known, search-only recording discovery with possible outreach tracked but
unsent, and retaining LinkedIn's blocked status. The other Mac remains a consumer.
The unanswered 2012 deck-identity question remains quarantined. The current cycle
is tracked in `../CONTENT-TEXT-RECOVERY.md`; public-safe code and evidence are
committed at each major checkpoint, never raw unreviewed transcripts.

The person summary derives its registry date and local-source count
from committed sources. Source registry changes require
`python3 tools/render_person_content.py`, a committed metadata/summary update,
then the scoped archive snapshot and catalog rebuild. Daily CI verifies these
surfaces but does not claim to perform every external source check.
