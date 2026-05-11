# Inovia Living Work Plan

Last updated: `2026-05-11`

This is the living execution plan for the Inovia archive project. Keep it
current as the continuity layer, preservation baseline, and era boundary
evolve.

## Operating rule

Active Inovia work should happen from the canonical shared-public checkout:

- `/Users/steven/Projects-All/public`

The canonical deep archive root inside that checkout is:

- `/Users/steven/Projects-All/public/inovia-research`

Do not treat older `GitPages/public` paths or Steven-only source preservation as
the active Inovia workspace.

## Current project goal

Preserve the Inovia period as the canonical era-specific archive for Steven
Woods' work at Inovia, including:

- first-party role and transition material
- talks, podcasts, and public appearances in Inovia context
- portfolio and ecosystem-facing public sources
- preserved local captures that belong to the era archive

## Current state

- the Inovia manifest triad exists and parses cleanly
- the public summary page exists at `public/inovia-research.html`
- the repo-facing working page exists at `public/inovia-research/index.html`
- current manifest counts are `3` total / `3` approved / `0` deferred / `0` rejected
- `3` source records currently resolve to checked-in local archive files
- Inovia now has repo-owned continuity surfaces:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
  - `tools/start-inovia-codex.sh`

## Active plan

### Phase 1: continuity hardening

Status: `completed`

Goals:

- make Inovia restartable from the canonical `Projects-All/public` workspace
- add repo-owned continuity and portability docs
- add a dedicated startup validator

Completed checkpoint:

- Inovia now has a living work plan, workspace-status note, dated recovery
  audit, and startup validator
- the public and working pages now expose the continuity layer directly
- the canonical era/person boundary with `steven-woods-research` is now
  explicit

### Phase 2: first-source baseline

Status: `completed`

Goals:

- move Inovia beyond scaffold status
- create a small, honest source baseline without broadening into full research
  expansion
- localize the first preserved era-specific captures

Completed checkpoint:

- `3` seed leads are now formal source records
- all `3` seeded records are approved baseline sources
- all `3` seeded records resolve to checked-in local archive files inside the
  Inovia archive tree

### Phase 3: preservation and coverage depth

Status: `next`

Goals:

- add the current team profile as a localized baseline source
- extend the era archive beyond transition-only material
- grow the appearance and ecosystem lanes without losing restart discipline

Priority queue:

- current Inovia team profile
- additional podcasts, panels, and keynote-style appearances
- portfolio and ecosystem-facing sources that show Steven Woods operating inside
  the Inovia venture context

## Practical next-step path from here

1. Start every new Inovia session from `/Users/steven/Projects-All/public`.
2. Run `bash inovia-research/tools/start-inovia-codex.sh` before substantive
   work when continuity matters.
3. Add the next current-role and public-appearance sources to the source
   manifest.
4. Keep `project-manifest.json`, `source-manifest.json`,
   `public-handoff.json`, `inovia-research/index.html`, and
   `inovia-research.html` aligned when the archive state changes.
