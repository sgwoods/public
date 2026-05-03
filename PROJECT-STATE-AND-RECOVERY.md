# Public project state and recovery

Updated: 2026-05-03

## Working policy going forward

Going forward, all local work should be done only in an iCloud-backed folder.

Current state:

- this checkout is under `/Users/stevenwoods/GitPages/public`
- the standard iCloud-backed root exists at:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs`

Practical implication:

- this current checkout should be treated as a transition workspace
- no new substantial local-only work should continue here once the current state is stabilized
- the next safe milestone is to preserve and reconcile the current work, then migrate the active workspace into an iCloud-backed location

## Parallel workstreams

Several active projects are being worked on separately and in parallel to this continuity effort.

At the time of this update, those parallel workstreams include:

- `phd-renovation`
- `ai-dystopia-quotes`
- `mmath-renovation`
- `kinitos-neoedge`
- `quack`

Operational rule:

- the continuity/recovery branch should not casually absorb active project work from those streams just because their files are locally modified
- project-specific work should remain grouped by project and handled intentionally
- continuity work should focus on:
  - recovery notes
  - workflow baselines
  - archive coordination surfaces
  - migration readiness

This changes the stabilization strategy:

- do not treat all local modifications as one cleanup batch
- instead, separate `continuity infrastructure` from `active project development or research`
- preserve continuity-first work here, while leaving parallel project changes for their own deliberate batching

## Living plan

This is the current working plan and should be kept up to date as work proceeds.

### Phase 1: stabilize the current local state

Status: `in progress`

Goals:

- protect current local-only work from accidental loss
- make the current workspace auditable
- avoid introducing more divergence before migration
- avoid accidentally co-mingling unrelated parallel project work under the recovery branch

Tasks:

- [x] create a dedicated recovery branch from the current local state
- [x] commit the currently untracked continuity files
- [ ] group and commit the current tracked local modifications intentionally
- [ ] separate continuity-only changes from active parallel project changes
- [ ] remove or ignore Finder junk such as `.DS_Store`
- [ ] fetch/review and reconcile the current `origin/main` gap

### Phase 2: iCloud migration

Status: `not started`

Goals:

- move the active working copy into an iCloud-backed location
- ensure new machine recovery does not depend on the old non-iCloud checkout

Tasks:

- [ ] choose the canonical iCloud-backed parent folder for active repos
- [ ] create a fresh clone of this repo in the iCloud-backed location
- [ ] verify the fresh clone can build/render the public surfaces
- [ ] move any still-uncommitted work into that canonical checkout
- [ ] stop treating `/Users/stevenwoods/GitPages/public` as the primary working copy

### Phase 3: continuity hardening

Status: `not started`

Goals:

- make a fresh checkout sufficient to continue work
- reduce dependence on transient web sources and machine-local memory

Tasks:

- [ ] add a top-level bootstrap checklist for a new machine
- [ ] add a regeneration checklist for derived pages and indexes
- [ ] audit source manifests for local mirror coverage
- [ ] classify artifacts as canonical, derived, or scratch
- [ ] make continuity documents part of the normal publishing discipline

### Phase 4: repo separation

Status: `not started`

Goals:

- reduce coupling between independent archive efforts
- keep `public` focused on the hub, rendering, and downstream summaries

Tasks:

- [ ] separate `quack` into its own canonical repo when continuity is stable
- [ ] separate `kinitos-neoedge` into its own canonical repo when continuity is stable
- [ ] separate `steven-woods-research` into its own canonical repo when continuity is stable
- [ ] keep era archives nested until they justify their own repositories

## Precise goal

This repository is the public-facing Steven Woods hub and archive shell.

Its job is to:

- publish the top-level public site
- hold the recovered `Spectra` historical material
- render the shared project dashboard from project manifests
- host the person-centric Steven Woods archive
- host or mirror several company- and era-centric research archives
- keep enough checked-in structure, data, and workflow guidance that archive work can resume on a new machine without rediscovery

This repo is not just a website. It is also the continuity surface for several related archive and research efforts.

## Current canonical working areas

These are the current canonical working areas inside this repo:

- `Spectra/` for the recovered historical site archive
- `steven-woods-research/` for the person-centric deep archive
- `quack/` for the canonical Quack deep archive
- `kinitos-neoedge/` for the canonical Kinitos / NeoEdge deep archive
- `google-canada-research/`, `inovia-research/`, `canberra-research/`, and `sei-pittsburgh-research/` as early era-archive shells
- top-level public pages and renderers under the repo root and `tools/`

These are the areas that should be treated as current working surfaces unless later documents explicitly replace them.

## Legacy, alias, or supporting areas

These paths are not the canonical deep working areas, even if they still exist and remain useful:

- `data/kinitos-neoedge/`
  - legacy/supporting intake scaffold
  - useful for continuity and earlier intake context
  - not the canonical deep archive root
- `data/projects/codex-test1.json`
  - legacy compatibility alias for Aurora Galactica
  - not the canonical active project identity
- `/Users/stevenwoods/GitPages/public`
  - current transition checkout only
  - not the intended long-term canonical local working copy once iCloud migration is complete

Rule:

- if a path is canonical, work should accumulate there
- if a path is legacy/supporting, it should be labeled and used only for continuity, intake history, or compatibility
- if a path becomes abandoned, mark it explicitly rather than leaving it ambiguous

## Current state

- tracked files: about `3110`
- top-level archive payload:
  - `Spectra/` about `84M`
  - `quack/` about `1.5M`
  - `steven-woods-research/` about `4.8M`
  - `kinitos-neoedge/` about `272K`
  - era archives (`google-canada-research/`, `inovia-research/`, `canberra-research/`, `sei-pittsburgh-research/`) are present as structured shells
- shared coordination documents exist:
  - `ARCHIVE_PROJECT_INTERFACE.md`
  - `PUBLIC_STATUS_INTERFACE.md`
  - `data/shared/incoming-artifact-analysis-playbook.md`
  - `data/shared/incoming-artifact-analysis-template.md`

Top-level active project-manifest feeds currently exist for:

- `data/projects/aurora-galactica.json`
- `data/projects/codex-test1.json` (legacy alias)
- `data/projects/phd-renovation.json`
- `data/projects/mmath-renovation.json`
- `data/projects/quack-com.json`
- `data/projects/kinitos-neoedge.json`
- `data/projects/confidential-project.json`
- `data/projects/ai-dystopia-quotes.json`

Archive-style project manifests currently exist for:

- `steven-woods-research/project-manifest.json`
- `quack/project-manifest.json`
- `kinitos-neoedge/project-manifest.json`
- `google-canada-research/project-manifest.json`
- `inovia-research/project-manifest.json`
- `canberra-research/project-manifest.json`
- `sei-pittsburgh-research/project-manifest.json`

## Current status

The repo is **not** in a fully recoverable, clean, ready-to-clone-and-continue state yet.

Current git state:

- branch: `codex/public-recovery-stabilization`
- local branch is behind `origin/main` by more than `200` commits at this audit point
- there are many local tracked modifications
- there are untracked recovery/workflow documents that are not yet committed

This means we cannot honestly claim today that:

- a fresh checkout alone exactly reproduces the current working state
- all current local research and artifact work is safe if this directory tree is lost

We can claim something narrower:

- the checked-in repo contains a large amount of the archive and workflow structure
- several subprojects already have strong continuity surfaces
- but the whole-repo continuity guarantee is not complete until local changes are reconciled and committed

## What is checked in now

Checked in and reusable from a clean clone:

- top-level public site pages and renderer
- `Spectra/` recovered archive tree
- Steven Woods public profile, CV, and research surfaces
- the archive/research directory shells
- many mirrored source artifacts under `Spectra/`, `steven-woods-research/`, and `quack/`
- manifest-driven project card system
- charting and dashboard rendering logic
- shared archive coordination and workflow docs
- project-specific archive structure for:
  - `quack`
  - `kinitos-neoedge`
  - `steven-woods-research`
  - `google-canada-research`
  - `inovia-research`
  - `canberra-research`
  - `sei-pittsburgh-research`

Notable continuity-positive signals:

- Quack already has a dedicated checked-in recovery note at `quack/PROJECT-STATE-AND-RECOVERY.md`
- shared workflow guidance exists at `data/shared/company-research-workflow.md`
- person/archive contract guidance exists in `ARCHIVE_PROJECT_INTERFACE.md`

## What is not safely checked in yet

### Local tracked modifications

These files are modified locally and are not yet reflected in the checked-in repository state:

- `ai-dystopia-quotes.html`
- `data/ai-dystopia-quotes.approved.json`
- `data/kinitos-neoedge/AGENTS.md`
- `data/kinitos-neoedge/README.md`
- `data/projects/ai-dystopia-quotes.json`
- `data/projects/phd-renovation.json`
- `data/projects/quack-com.json`
- `kinitos-neoedge/README.md`
- `phd-renovation-handbook.html`
- `phd-renovation-thesis.ps`
- `quack-com.html`
- `quack/AGENTS.md`
- `quack/README.md`
- `quack/incoming/README.md`
- `quack/project-manifest.json`
- `quack/public-handoff.json`
- `quack/research/entities.json`
- `quack/research/next-steps-from-kinitos.md`
- `quack/research/run-report.md`
- `quack/research/source-leads.json`
- `quack/research/timeline.json`
- `quack/research/topic-briefs/anecdotes-and-cultural-footprint.md`
- `quack/research/topic-briefs/company-history.md`
- `quack/research/topic-briefs/investors-and-outcomes.md`
- `quack/research/topic-briefs/key-individuals.md`
- `quack/research/topic-briefs/patents-and-ip.md`
- `quack/research/topic-briefs/product-and-technology.md`
- `quack/research/topic-briefs/speechworks-and-partners.md`
- `quack/research/topic-briefs/waterloo-canada-relationship.md`
- `quack/tools/quack_research_pipeline.py`

Important note:

- not all of these are part of the continuity mission
- several belong to active parallel project workstreams and should be kept grouped by project rather than swept into continuity commits

### Local untracked files

These files exist only locally right now:

- `PROJECT-STATE-AND-RECOVERY.md`
- `data/shared/company-research-workflow.md`
- `quack/PROJECT-STATE-AND-RECOVERY.md`
- `kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- `kinitos-neoedge/WORK-PLAN.md`

### Local machine residue

The repo still contains Finder metadata in multiple places such as:

- `.DS_Store`
- `quack/.DS_Store`
- `kinitos-neoedge/.DS_Store`
- `Spectra/.DS_Store`
- `google-canada-research/.DS_Store`
- `inovia-research/.DS_Store`
- `canberra-research/.DS_Store`

These do not help continuity and should not be part of the recovery story.

Current hygiene rule:

- `.DS_Store`, `__pycache__/`, `*.pyc`, and AppleDouble files should be ignored and treated as non-project residue

## Artifact-state assessment

### Good

- `Spectra/` appears substantially preserved inside the repo
- the Steven Woods research archive has structured source manifests and preserved captures
- Quack has emerging self-contained workflow, source, and recovery surfaces
- archive project folders follow a repeatable interface pattern

### Incomplete

- not all external sources have local mirrors
- some research notes still depend on canonical web URLs instead of preserved local copies
- several active areas are only partially checked in because the current working tree is dirty
- remote `origin/main` is ahead of the local checkout, so this local workspace is not even the full checked-in truth as of today

### Continuity conclusion

If this local directory vanished today, we could recover **much** of the work from git, but **not all current work**.

The main reasons are:

- local modifications not yet committed
- untracked local documents
- local branch behind remote
- some source artifacts still depend on external web availability

## Recommended next steps to reach recovery certainty

### Immediate

1. Create a dedicated recovery branch from the current local state.
2. Commit the two untracked recovery/workflow documents.
3. Separate continuity work from active parallel project work before further commits.
4. Remove or ignore Finder junk like `.DS_Store`.
5. Fetch and review the `108` remote commits before claiming continuity.
6. Do **not** start new substantial local work in this non-iCloud checkout after the stabilization pass.
7. Prepare a clean iCloud-backed clone to become the canonical active workspace.

### After that

6. Add a top-level regeneration checklist for:
   - homepage rendering
   - Steven source index rendering
   - Quack research pipeline runs
   - any archive-page generation steps
7. Audit all `source-manifest.json` files for local-archive coverage and mark:
   - mirrored locally
   - canonical external only
   - needs local preservation
8. Decide which artifacts are canonical repo content versus machine-local scratch output.
9. Add a top-level `bootstrap on new machine` section to `README.md` after the repo is clean enough to trust.

## Recommended next steps for the project itself

1. Stabilize repository continuity before adding more historical content.
2. Keep continuity-specific commits separate from active parallel project commits.
3. Bring the local checkout up to date with `origin/main` in a controlled way.
4. Migrate active work to an iCloud-backed clone and treat that as canonical.
5. Resume each parallel project from the iCloud-backed workspace in its own grouped flow.
6. Continue source preservation, prioritizing fragile or high-value external sources.
7. Tighten the contract between project manifests and rendered public pages so stale exports are easier to detect.

## Subprojects that should be separated

### Strong candidates for separation

These have enough identity and independent pace to justify their own repos over time:

- `quack`
- `kinitos-neoedge`
- `steven-woods-research`

Why:

- they have their own manifests
- they have their own research or archive workflow
- they change independently
- they are larger than simple public-page subfolders

Recommended separation model:

- each becomes its own canonical repo
- each continues to publish `project-manifest.json`, `source-manifest.json`, and `public-handoff.json`
- this `public` repo becomes the downstream hub and published shell

### Likely stay nested for now

- `google-canada-research`
- `inovia-research`
- `canberra-research`
- `sei-pittsburgh-research`

Why:

- they are still early shells
- they are not yet heavy enough to justify separate repositories
- they can remain nested under the Steven-centric archive until their preserved material and independent workflows grow

### Likely stay in this repo

- `Spectra/`
- top-level profile/publication/reference pages
- homepage/dashboard rendering
- shared interface and workflow docs

Why:

- these are part of the public hub itself
- they are downstream presentation and shared infrastructure, not independent archival identities

## Recommended structure direction

Best long-term shape:

- `public` = public hub, shared pages, renderers, reference docs, and downstream published summaries
- `quack` = independent company archive repo
- `kinitos-neoedge` = independent company archive repo
- `steven-woods-research` = independent person-centric archive repo
- era subprojects remain inside `steven-woods-research` until they justify splitting

## Bottom-line assessment

Today the project is valuable, substantial, and partly structured for continuity, but it is **not yet at the standard where we should say a new machine can reproduce the exact current state without loss**.

To reach that bar, the next unit of work should be continuity and repository hygiene, not more discovery.

With the new iCloud-backed-work requirement, the next unit of work is more specifically:

- stabilize current local state
- migrate the canonical working copy into iCloud-backed storage
- then continue archive and research expansion only from that backed-up checkout

Because several substantive projects are moving in parallel, the correct interpretation is:

- continuity work should make those parallel streams safer
- continuity work should not replace their own project-specific batching and decision-making
