# Archive Subproject Graduation Guide

Purpose: define when an archive subproject should remain monorepo-owned inside
`public`, when it should become a stronger standalone effort, and which
structure options preserve the shared Steven Woods hub model cleanly.

This document is a decision framework, not a forced migration plan.

## Core rule

Not all research-style projects need to stay in one repository forever.

But they should usually stay connected at the **hub and export** level even if
they later separate at the **repo** level.

That means:

- `public` remains the canonical Steven Woods hub shell
- archive projects should keep exporting compatible machine-readable state
- splits should happen only when they solve a real operational problem

Default stance:

- keep archive subprojects inside `~/Projects-All/public`
- split one out only by deliberate decision

## Three structural options

### Option 1: shared-public subproject

The archive stays inside the canonical `public` repo.

Typical shape:

- `project-name/`
- `project-name.html`
- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

Best for:

- scaffolded archives
- newly seeded archives
- archives that still depend heavily on `steven-woods-research`
- archives where the overhead of another repo would outweigh the benefit

Benefits:

- one canonical clone
- one publishing flow
- easy cross-project repair and continuity work
- low coordination overhead

Costs:

- mixed Git history
- promotion discipline matters more
- unrelated branch work can travel together unless handled carefully

### Option 2: standalone deep archive with `public` bridge

The archive gets its own repo, but `public` remains the top-level hub.

The standalone repo still maintains:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

And `public` consumes those exports through a documented bridge or sync path.

Best for:

- large, identity-rich deep archives
- projects that may want their own issue tracking, release cadence, or outside
  collaborators
- archives whose preservation and research work are substantial enough to stand
  on their own

Benefits:

- cleaner project-specific history
- easier collaboration boundaries
- easier project-specific tooling, tests, and release discipline

Costs:

- requires a stable bridge back into `public`
- adds repo overhead
- increases the chance of drift if manifests or public-facing summaries are not
  synced carefully

### Option 3: fully external archive project

The archive becomes a mostly independent public property, and `public` only
holds a top-level hub card plus minimal cross-links.

Best for:

- rare cases where the archive develops a strong identity beyond the Steven
  Woods hub
- cases where the archive needs its own brand, deployment model, or audience

Benefits:

- maximum independence
- clean operational separation

Costs:

- highest drift risk
- weakest shared continuity unless a formal interface is preserved
- easiest way to lose the “single hub” model if done casually

Default recommendation:

- do not use this model unless there is a strong reason

## What should always stay connected

Regardless of repo structure, the following should stay connected:

- top-level Steven hub navigation
- cross-project role definitions
- machine-readable manifest contract
- clear person-vs-company ownership boundaries

In practice, even a standalone archive should still be compatible with the
`public` hub through the manifest triad and public-facing links.

## Graduation criteria

A subproject is a good candidate for standalone promotion when most of the
following are true:

- it has a substantial deep archive with many project-owned artifacts
- it has a meaningful identity independent of the Steven hub
- it already has continuity docs and a startup validator
- it has a stable archive model rather than a changing scaffold model
- it no longer depends heavily on `steven-woods-research` for core
  interpretation
- it would benefit from separate issues, PRs, or collaborators
- its publish or preservation cadence is different enough that shared-repo
  coordination is becoming friction

A subproject should usually remain monorepo-owned when most of the following
are true:

- it is still scaffolded or lightly seeded
- it still relies heavily on Steven-layer overlap
- its source ledger and artifact lane are still thin
- its continuity structure is new and still settling
- it has no real operational need for a separate repo yet

## Recommended current model by archive

### Keep monorepo-owned for now

`steven-woods-research`

- reason: canonical shared person-centric layer
- splitting it now would make the hub/archive boundary harder, not easier

`google-canada-research`

- reason: now seeded and restartable, but still early enough that shared-public
  maintenance is the better fit

`inovia-research`

- reason: newly seeded era archive, still growing its first serious baseline

`canberra-research`

- reason: still scaffold-level

`sei-pittsburgh-research`

- reason: still scaffold-level

### Strongest eventual standalone candidates

`kinitos-neoedge`

- reason: already behaves like a substantial deep historical archive with
  artifacts, continuity docs, validators, and real preservation depth
- likely first candidate if anything graduates

`quack`

- reason: also a real deep archive with artifacts, continuity docs, and
  company-specific preservation lanes
- likely second candidate after Kinitos

## Practical promotion path

If a subproject is promoted later, prefer this sequence:

1. keep the archive stable inside `public` first
2. confirm the continuity layer and validator are solid
3. confirm the manifest triad is authoritative
4. document what `public` will continue to own
5. document how `public` will consume the standalone archive’s manifests
6. only then split the repo boundary

This avoids turning a structure decision into a recovery problem.

## Operational rule of thumb

Use this test:

- if the archive is still becoming legible, keep it inside `public`
- if the archive is already legible and the repo boundary is now the bottleneck,
  consider promotion

Today that means:

- stabilize and seed first
- graduate later, selectively

## Current recommendation

Stay with the shared-public model while the remaining research archives are
stabilized.

After the remaining scaffolds are upgraded to seeded, restartable archives, do
a deliberate promotion review for:

1. `kinitos-neoedge`
2. `quack`
3. later, possibly `google-canada-research`

Do not split solely because a project is “research.”

Split only when the archive has earned a cleaner operational boundary and the
bridge back to `public` is documented.
