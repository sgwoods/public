# Google Canada Living Work Plan

Last updated: `2026-05-11`

This is the living execution plan for the Google Canada archive project. Keep
it current as the continuity layer, preservation baseline, and era boundary
evolve.

## Operating rule

Active Google Canada work should happen from the canonical shared-public
checkout:

- `/Users/steven/Projects-All/public`

The canonical deep archive root inside that checkout is:

- `/Users/steven/Projects-All/public/google-canada-research`

Do not treat older `GitPages/public` paths or Steven-only preservation as the
active Google Canada workspace.

## Current project goal

Preserve the Google Canada period as the canonical era-specific archive for
Steven Woods' work during the Google Canada leadership years, including:

- leadership and Waterloo engineering growth
- talks, interviews, videos, and public appearances
- Canadian media and ecosystem-facing sources
- preserved local captures that belong to the era archive

## Current state

- the Google Canada manifest triad exists and parses cleanly
- the public summary page exists at `public/google-canada-research.html`
- the repo-facing working page exists at `public/google-canada-research/index.html`
- current manifest counts are `7` total / `7` approved / `0` deferred / `0` rejected
- `7` source records currently resolve to checked-in local archive files
- Google Canada now has repo-owned continuity surfaces:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
  - `tools/start-google-canada-codex.sh`

## Active plan

### Phase 1: continuity hardening

Status: `completed`

Goals:

- make Google Canada restartable from the canonical `Projects-All/public`
  workspace
- add repo-owned continuity and portability docs
- add a dedicated startup validator

Completed checkpoint:

- Google Canada now has a living work plan, workspace-status note, dated
  recovery audit, and startup validator
- the public and working pages now expose the continuity layer directly
- the canonical era/person boundary with `steven-woods-research` is now
  explicit

### Phase 2: first-source baseline

Status: `completed`

Goals:

- move Google Canada beyond scaffold status
- create a small, honest source baseline without broadening into full research
  expansion
- localize the first preserved era-specific captures

Completed checkpoint:

- `4` seed leads are now formal source records
- all `4` seeded records are approved baseline sources
- all `4` seeded records resolve to checked-in local archive files inside the
  Google Canada archive tree

### Phase 3: preservation and coverage depth

Status: `underway`

Goals:

- add the next interview and media anchors
- extend the archive beyond the initial Waterloo-and-Google starter set
- grow the era archive without collapsing it back into Steven-only context

Completed checkpoint:

- the Springboard Atlantic interview is now localized into the Google Canada
  archive
- the CityNews Lang Tannery item is now localized as an early Waterloo office
  and local-media anchor
- a BetaKit transition article now closes the era more cleanly with an
  explicit bridge into Inovia

Priority queue:

- direct archival copy or stronger provenance for the original University
  Affairs interview behind the Springboard Atlantic repost
- first-party transition companion source for the move into Inovia
- later Google-era ecosystem and accelerator coverage once the core archive is
  a little deeper

## Practical next-step path from here

1. Start every new Google Canada session from `/Users/steven/Projects-All/public`.
2. Run `bash google-canada-research/tools/start-google-canada-codex.sh` before
   substantive work when continuity matters.
3. Add the next first-party interview, media, and transition companion sources
   to the source manifest.
4. Keep `project-manifest.json`, `source-manifest.json`,
   `public-handoff.json`, `google-canada-research/index.html`, and
   `google-canada-research.html` aligned when the archive state changes.
