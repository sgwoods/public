# Inovia Project State And Recovery Audit

Audit timestamp: `2026-05-11T17:46:41Z`

Repo: `public`

Canonical active local workspace:

- `/Users/steven/Projects-All/public`

Canonical Inovia deep archive root:

- `public/inovia-research/`

Canonical public summary page:

- `public/inovia-research.html`

## Project meaning

Inovia is the canonical era-specific archive for Steven Woods' Inovia period
inside the shared `public` repo.

It owns:

- Inovia-era source interpretation
- era-specific local preservation
- working notes and next-step planning for the Inovia period

It does not own:

- the top-level Steven biography
- person-centric cross-company interpretation already owned by
  `steven-woods-research`

## Current archive state

Confirmed machine-readable baseline:

- `3` total source records
- `3` approved
- `0` deferred
- `0` rejected

Confirmed local preservation baseline:

- `3` source records currently resolve to checked-in local archive files
- the Inovia archive now also carries a supporting `riddick-show-feed.xml`
  metadata file alongside the seeded podcast capture

Confirmed continuity baseline:

- `project-manifest.json`, `source-manifest.json`, and `public-handoff.json`
  all parse cleanly
- Inovia now has a repo-owned continuity layer:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
  - `tools/start-inovia-codex.sh`

## Portability assessment

Inovia is now meaningfully restartable from the canonical
`Projects-All/public` workspace.

This pass converts it from a pure scaffold into a seeded era archive by adding:

- explicit workspace and restart docs
- a startup validator
- a first machine-readable source baseline
- localized preserved copies of the three initial seed sources

## Remaining risk

The main remaining risk is not workspace ambiguity. It is depth and completeness:

- the current Inovia team profile is still URL-backed and not yet localized
- the archive still needs more public appearances and ecosystem-facing sources
- person/era overlap with `steven-woods-research` is now explicit, but still
  needs deliberate upkeep as the archive grows

## Practical verdict

Inovia is now `seeded, continuity-safe, and restartable` inside the canonical
shared-public workspace, but it is not yet `deeply populated`.

The next sensible Inovia pass is another small preservation-and-seeding pass,
not another continuity rebuild.
