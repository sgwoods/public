# Quack.com Living Work Plan

Last updated: `2026-05-10`

This is the living execution plan for the Quack archive project. Keep it current as the archive, preservation baseline, and restart path change.

## Operating rule

Active Quack work should happen from the canonical shared-public checkout:

- `/Users/steven/Projects-All/public`

The canonical deep archive root inside that checkout is:

- `/Users/steven/Projects-All/public/quack`

Quack remains staged inside `public`, so the archive is still intentionally monorepo-owned for now. Do not treat older `GitPages/public` paths or cross-project copies as the active Quack workspace.

## Current project goal

Preserve Quack.com as the canonical deep archive for the company story, including:

- contemporaneous press and partner coverage
- acquisition and post-acquisition product evidence
- financing and investor-outcome context
- patents, retrospective profiles, and institutional references
- preserved local artifacts, demos, and future first-party captures

## Current state

- the Quack manifest triad exists and parses cleanly
- the public summary page exists at `public/quack-com.html`
- the repo-facing working page exists at `public/quack/index.html`
- current manifest counts are `20` total / `6` approved / `14` deferred / `0` rejected
- `5` source records currently resolve to checked-in local archive files
- Quack now has repo-owned continuity surfaces:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
  - `tools/start-quack-codex.sh`
- Quack remains staged inside `public`, so `repo_url` in `project-manifest.json` is still intentionally unset

## Active plan

### Phase 1: continuity hardening

Status: `completed`

Goals:

- make Quack restartable from the canonical `Projects-All/public` workspace
- add repo-owned continuity and portability docs
- add a dedicated startup validator instead of relying only on the publishing pipeline

Completed checkpoint:

- Quack now has a living work plan, workspace-status note, dated recovery audit, and startup validator
- Quack's visible working page now exposes the manifest triad and continuity surfaces directly
- old-machine absolute path drift has been reduced in Quack-owned docs and research metadata

### Phase 2: preservation completeness

Status: `in progress`

Goals:

- reduce dependency on fragile external URLs
- improve exact-state reproducibility
- make the archive more self-contained without broadening into unrelated redesign

Current checkpoint:

- `5` Quack source records now resolve to checked-in local archive files
- `3` of those local archive paths belong to `approved` sources
- the next highest-value preservation targets remain AOL by Phone / AOL Anywhere first-party pages, plus additional URL-backed acquisition, financing, and partner sources

Priority queue:

- AOL by Phone and AOL Anywhere first-party captures
- investor outcomes and financing trail
- URL-backed acquisition and market-context press
- stronger first-party or partner evidence for post-acquisition product behavior

### Phase 3: structured research follow-through

Status: `later`

Goals:

- continue named research campaigns without losing continuity discipline
- keep company-specific interpretation in Quack while only short Steven-relevant summaries flow upward

Tasks:

- work campaign-by-campaign
- keep the manifest triad and public page aligned after each material archive change
- preserve first-party or fragile evidence before broad editorial expansion

### Phase 4: optional extraction

Status: `optional future`

Goals:

- revisit a standalone Quack repo only after the staged-in-`public` workflow is stable and well understood

## Practical next-step path from here

1. Start every new Quack session from `/Users/steven/Projects-All/public`.
2. Run `bash quack/tools/start-quack-codex.sh` before substantive work when continuity matters.
3. Continue preservation around AOL by Phone, investor outcomes, and first-party capture gaps.
4. Keep `project-manifest.json`, `source-manifest.json`, `public-handoff.json`, `quack/index.html`, `quack-com.html`, and `data/projects/quack-com.json` aligned when Quack state changes.

