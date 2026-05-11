# SEI Pittsburgh Project State And Recovery Audit

Audit timestamp: `2026-05-11T19:22:15Z`

Repo: `public`

Canonical active local workspace:

- `/Users/steven/Projects-All/public`

Canonical SEI Pittsburgh deep archive root:

- `public/sei-pittsburgh-research/`

Canonical public summary page:

- `public/sei-pittsburgh-research.html`

## Project meaning

SEI Pittsburgh is the canonical era-specific archive for Steven Woods' Software
Engineering Institute period inside the shared `public` repo.

It owns:

- SEI-era source interpretation
- era-specific local preservation
- working notes and next-step planning for the SEI Pittsburgh period

It does not own:

- the top-level Steven biography
- person-centric cross-company interpretation already owned by
  `steven-woods-research`

## Current archive state

Confirmed machine-readable baseline:

- `9` total source records
- `9` approved
- `0` deferred
- `0` rejected

Confirmed local preservation baseline:

- `9` source records currently resolve to checked-in local archive files
- the expanded baseline now includes five local PDF captures and three local
  HTML captures from stable SEI-hosted sources
- one preserved PDF issue now supports two distinct approved transition sources
  because it contains both the main SEI architecture-practices article and the
  Quack-history sidebar

Confirmed continuity baseline:

- `project-manifest.json`, `source-manifest.json`, and `public-handoff.json`
  all parse cleanly
- SEI Pittsburgh now has a repo-owned continuity layer:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
  - `tools/start-sei-codex.sh`

## Portability assessment

SEI Pittsburgh is now meaningfully restartable from the canonical
`Projects-All/public` workspace.

This pass converts it from a pure scaffold into a seeded era archive by adding:

- explicit workspace and restart docs
- a startup validator
- a deeper machine-readable source baseline
- localized preserved copies of a core paper, two SEI author profiles, three
  additional SEI-era publications, an institute-context page, and two
  transition bridge sources

## Remaining risk

The main remaining risk is not workspace ambiguity. It is depth and completeness:

- staff and institute context is better now, but still thin beyond the current
  Woods and Carriere author profiles
- the SEI publication floor is stronger now, but still not a deep run through
  the period
- the bridge lane is better now, but still benefits from an external
  non-SEI-owned Quack transition source later

## Practical verdict

SEI Pittsburgh is now `seeded, continuity-safe, and restartable` inside the
canonical shared-public workspace, with a stronger paper-and-bridge floor,
but it is not yet `deeply populated`.

The next sensible SEI Pittsburgh pass is another small preservation-and-seeding
pass, not another continuity rebuild.
