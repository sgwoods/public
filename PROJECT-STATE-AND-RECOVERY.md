# Public project state and recovery

Updated: 2026-05-03

## Working policy going forward

Going forward, all local work should be done only in an iCloud-backed folder.

Current state:

- canonical active continuity checkout:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- older non-iCloud transition checkout:
  - `/Users/stevenwoods/GitPages/public`
- parallel older iCloud checkout:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`

Practical implication:

- `public-quack-recovery` is the current active continuity workspace
- `/Users/stevenwoods/GitPages/public` should be treated as a deprecated transition checkout for active local work
- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public` should be treated as a non-canonical parallel iCloud checkout unless intentionally reconciled later
- no new substantial local-only work should continue in deprecated or non-canonical checkouts
- new-machine bootstrap and validation instructions now live in `START-HERE-NEW-MAC.md` and `tools/start_codex_on_new_mac.sh`

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

Status: `partially complete`

Goals:

- protect current local-only work from accidental loss
- make the current workspace auditable
- avoid introducing more divergence before migration
- avoid accidentally co-mingling unrelated parallel project work under the recovery branch

Tasks:

- [x] create a dedicated recovery branch from the current local state
- [x] commit the currently untracked continuity files
- [ ] group and commit the remaining tracked local modifications intentionally
- [x] separate Quack continuity-only changes from active parallel project changes
- [ ] remove or ignore Finder junk such as `.DS_Store`
- [ ] fetch/review and reconcile the current `origin/main` gap

### Phase 2: iCloud migration

Status: `complete for Quack continuity workspace`

Goals:

- move the active working copy into an iCloud-backed location
- ensure new machine recovery does not depend on the old non-iCloud checkout

Tasks:

- [x] choose the canonical iCloud-backed parent folder for active repos
- [x] create a fresh clone of this repo in the iCloud-backed location
- [x] verify the Quack continuity checkout can build/regenerate its archive surfaces
- [x] move Quack continuity work into that canonical checkout via the recovery branch
- [x] stop treating `/Users/stevenwoods/GitPages/public` as the primary Quack working copy

### Phase 3: continuity hardening

Status: `in progress`

Goals:

- make a fresh checkout sufficient to continue work
- reduce dependence on transient web sources and machine-local memory

Tasks:

- [x] add a top-level bootstrap checklist for a new machine
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

Workspace-status references:

- `quack/WORKSPACE-STATUS.md`
- `kinitos-neoedge/WORKSPACE-STATUS.md`
- `START-HERE-NEW-MAC.md`

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
  - deprecated transition checkout for active local archive work
  - not the intended long-term canonical local working copy
- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`
  - non-canonical parallel iCloud checkout
  - useful only if intentionally reconciled later

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

The continuity story is now materially better than it was at the start of this pass, but there is still an important split between:

- the **safe continuity lane**, which is checked in and iCloud-backed
- the **deprecated MacBook checkout**, which still contains unrelated active project edits

Current continuity reality:

- branch: `codex/public-recovery-stabilization`
- remote tracking branch for that lane exists and is current
- canonical active continuity checkout:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- older iCloud checkout on `main` also exists and is clean:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`
- deprecated non-iCloud checkout still has local modifications from active parallel work:
  - `/Users/stevenwoods/GitPages/public`

What we can now honestly claim:

- a new machine can clone the recovery branch into an iCloud-backed workspace and validate it from checked-in instructions
- Quack and Kinitos continuity can restart from the canonical iCloud-backed recovery checkout without relying on memory from this MacBook
- the portability path is documented and scripted

What we still cannot honestly claim:

- that every active parallel project change in the deprecated MacBook checkout is already folded into the continuity lane
- that the deprecated checkout itself should be treated as canonical

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

The deprecated non-iCloud checkout still has tracked local modifications that are not part of the clean continuity snapshot.

At the time of this update, those modified areas include:

- `ai-dystopia-quotes`
- `phd-renovation`
- `mmath-renovation`
- some top-level derived or presentation files such as `index.html` and `steven-woods-cv.pdf`

Important note:

- these are active parallel project surfaces
- they should be grouped and handled in their own project flows
- they are not proof that the continuity lane is broken
- they are proof that `/Users/stevenwoods/GitPages/public` is not the canonical workspace anymore

### Local untracked files

The continuity bootstrap surfaces should be checked in and preferred over ad hoc local notes.

If new untracked bootstrap or portability files appear in the deprecated checkout, treat that as a warning sign:

- either the file should be intentionally promoted into the continuity lane
- or it should be removed as scratch or duplicate material

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

If the deprecated non-iCloud checkout vanished today, we would still retain the continuity lane because:

- the recovery branch is pushed
- the canonical continuity checkout is already in iCloud-backed storage
- the bootstrap and validation path is documented

What would still be at risk are only the active parallel project edits that remain local to the deprecated checkout and have not yet been grouped into their own project-specific commits.

## Recommended next steps to reach recovery certainty

### Immediate

1. Keep the continuity lane on `codex/public-recovery-stabilization` clean and pushed.
2. Treat `/Users/stevenwoods/GitPages/public` as deprecated for new work.
3. Move active project continuation into iCloud-backed checkouts only.
4. Promote only deliberate portability surfaces into the continuity lane.
5. Remove duplicate local bootstrap or scratch files that are no longer authoritative.

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
9. Keep `README.md`, `START-HERE-NEW-MAC.md`, and `LOCAL-WORKTREE-STATUS.md` aligned so a new machine has one obvious startup path.

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
