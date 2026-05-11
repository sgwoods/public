# SEI Pittsburgh Living Work Plan

Last updated: `2026-05-11`

This is the living execution plan for the SEI Pittsburgh archive project. Keep
it current as the continuity layer, preservation baseline, and era boundary
evolve.

## Operating rule

Active SEI Pittsburgh work should happen from the canonical shared-public
checkout:

- `/Users/steven/Projects-All/public`

The canonical deep archive root inside that checkout is:

- `/Users/steven/Projects-All/public/sei-pittsburgh-research`

Do not treat older `GitPages/public` paths or Steven-only preservation as the
active SEI Pittsburgh workspace.

## Current project goal

Preserve the SEI Pittsburgh period as the canonical era-specific archive for
Steven Woods' work at the Software Engineering Institute, including:

- SEI publications and papers
- institute and staff context
- architecture and reengineering-era material
- transition-to-startup bridge sources leading into Quack

## Current state

- the SEI Pittsburgh manifest triad exists and parses cleanly
- the public summary page exists at `public/sei-pittsburgh-research.html`
- the repo-facing working page exists at `public/sei-pittsburgh-research/index.html`
- current manifest counts are `9` total / `9` approved / `0` deferred / `0` rejected
- `9` source records currently resolve to checked-in local archive files
- SEI Pittsburgh now has repo-owned continuity surfaces:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
  - `tools/start-sei-codex.sh`

## Active plan

### Phase 1: continuity hardening

Status: `completed`

Goals:

- make SEI Pittsburgh restartable from the canonical `Projects-All/public`
  workspace
- add repo-owned continuity and portability docs
- add a dedicated startup validator

Completed checkpoint:

- SEI Pittsburgh now has a living work plan, workspace-status note, dated
  recovery audit, and startup validator
- the public and working pages now expose the continuity layer directly
- the canonical era/person boundary with `steven-woods-research` is now
  explicit

### Phase 2: first-source baseline

Status: `completed`

Goals:

- move SEI Pittsburgh beyond scaffold status
- create a small, honest source baseline without broadening into full research
  expansion
- localize the first stable SEI-hosted captures

Completed checkpoint:

- `3` seed leads are now formal source records
- all `3` seeded records are approved baseline sources
- all `3` seeded records resolve to checked-in local archive files inside the
  SEI Pittsburgh archive tree

### Phase 3: preservation and coverage depth

Status: `underway`

Goals:

- add stronger staff and institute context around Steven Woods' SEI role
- deepen the SEI Interactive and architecture/reengineering publication lane
- extend the bridge into Quack without collapsing ownership into Steven-only
  context

Priority queue:

- stronger SEI staff or organization context beyond the current Woods and
  Carriere author profiles
- additional SEI Interactive or related publication entries from the period
- further bridge sources linking the SEI architecture practices to the Quack
  startup path

Completed checkpoint:

- stable SEI author profiles for both Steve Woods and Jeromy Carriere are now
  localized into the archive as institute and collaborator context
- `Software Architectural Transformation`, `Why Reengineering Projects Fail`,
  and `Requirements for Integrating Software Architecture and Reengineering
  Models: CORUM II` are now localized as additional SEI publication anchors
- `A Short History of Quack.com from AOL's Web Site` is now formalized as a
  second Quack transition bridge source using the already-preserved 2002 SEI
  newsletter PDF

## Practical next-step path from here

1. Start every new SEI Pittsburgh session from `/Users/steven/Projects-All/public`.
2. Run `bash sei-pittsburgh-research/tools/start-sei-codex.sh` before
   substantive work when continuity matters.
3. Add the next SEI paper, institute context, and transition bridge sources to
   the source manifest.
4. Keep `project-manifest.json`, `source-manifest.json`,
   `public-handoff.json`, `sei-pittsburgh-research/index.html`, and
   `sei-pittsburgh-research.html` aligned when the archive state changes.
