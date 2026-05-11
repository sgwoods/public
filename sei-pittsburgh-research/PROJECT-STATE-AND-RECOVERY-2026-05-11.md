# SEI Pittsburgh Project State And Recovery Audit

Audit timestamp: `2026-05-11T19:01:15Z`

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

- `3` total source records
- `3` approved
- `0` deferred
- `0` rejected

Confirmed local preservation baseline:

- `3` source records currently resolve to checked-in local archive files
- the first baseline includes two direct SEI-hosted PDFs and one SEI-hosted
  institute-context HTML page

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
- localized preserved copies of a core paper, an institute-context page, and a
  retrospective bridge source

## Remaining risk

The main remaining risk is not workspace ambiguity. It is depth and completeness:

- staff and institute context explicitly naming Steven Woods is still thin
- the SEI publication floor is still only a starter set rather than a deep run
  through the period
- the Quack transition lane still needs a few more strong bridge sources

## Practical verdict

SEI Pittsburgh is now `seeded, continuity-safe, and restartable` inside the
canonical shared-public workspace, with a real paper-and-bridge floor,
but it is not yet `deeply populated`.

The next sensible SEI Pittsburgh pass is another small preservation-and-seeding
pass, not another continuity rebuild.
