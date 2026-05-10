# Steven Woods Research Living Work Plan

Last updated: `2026-05-10`

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
- `18` approved source records currently resolve to checked-in local archive files
- `4` approved baseline/profile sources remain URL-backed
- `24` files exist under `historic/artifacts/archive-html/`
- `6` of those checked-in files are still tracked only in the review ledger rather than the source manifest
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

- `18` approved Steven source records now resolve to checked-in local archive files
- the remaining URL-backed approved sources are the current Inovia profile, LinkedIn profile, bio.link page, and Wikipedia comparison page
- several additional checked-in captures already exist in the review ledger and should be reconciled deliberately rather than silently ignored

Priority queue:

- preserve the current profile/baseline pages where feasible
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
