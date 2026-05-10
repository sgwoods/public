# Kinitos / NeoEdge Living Work Plan

Last updated: `2026-05-10`

This is the living execution plan for the Kinitos / NeoEdge archive project. Keep it current as the archive advances.

## Operating rule

Active local working activity for this archive should happen in the canonical shared-public checkout:

- `/Users/steven/Projects-All/public`

If another checkout is opened for comparison, recovery verification, or historical reference, treat it as reference-only until any needed material has been reconciled back into this canonical workspace.

Git history is still the primary canonical record. The active local continuity layer is now this `Projects-All/public` clone, not the older `public-quack-recovery` checkout.

## Current project goal

Preserve the Kinitos -> NeoEdge -> Blue Noodle -> Double Fusion company line as the canonical deep archive for this history, including:

- source manifests and handoff surfaces
- research notes and campaign files
- archived site captures and other artifacts
- demos, memories, and future code recovery

## Current state

- the archive backbone exists
- the main public summary page exists
- the working repository page exists
- the source manifest is populated and usable
- the source baseline remains `32` total / `24` approved / `8` deferred / `0` rejected
- five local HTML captures are already preserved in git
- the continuity and restart layer now lives in `~/Projects-All/public`
- a dated recovery audit exists at `PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- workspace status is tracked in `WORKSPACE-STATUS.md`
- portability handoff status is tracked in `PORTABILITY-AND-MAC-HANDOFF.md`
- the Codex startup validation script now targets the canonical `Projects-All` workspace
- the prior `public-quack-recovery` checkout is now a deprecated source-state reference rather than the active Kinitos workspace

## Active plan

### Phase 1: continuity lock-in

Status: `completed`

Goals:

- preserve the archive state in committed git history
- make the shared workflow recovery file tracked
- make the Kinitos continuity docs part of the repo state

Completed checkpoint:

- the continuity documentation was written and captured in repo-owned files
- the shared checked-in workflow baseline exists in the repo
- the source-state comparison point remains recoverable from `codex/public-recovery-stabilization`

### Phase 2: canonical workspace consolidation

Status: `completed`

Goals:

- make `/Users/steven/Projects-All/public` the long-term canonical Kinitos workspace
- move the continuity layer out of the older recovery checkout
- remove hidden dependence on `public-quack-recovery` for restartability

Completed checkpoint:

- `WORK-PLAN.md`, `WORKSPACE-STATUS.md`, `PROJECT-STATE-AND-RECOVERY-2026-05-03.md`, and `PORTABILITY-AND-MAC-HANDOFF.md` now live in the canonical workspace
- `tools/start-kinitos-codex.sh` now validates the canonical `Projects-All/public` checkout directly
- `data/shared/company-research-workflow.md` is present in the canonical workspace
- the old `public-quack-recovery` path is now documented as prior source-state / deprecated reference only

Operational rule after consolidation:

- new raw captures, draft notes, downloaded artifacts, and restoration experiments should begin only inside `/Users/steven/Projects-All/public`

### Phase 3: preservation completeness

Status: `next`

Goals:

- reduce dependence on external live URLs
- improve exact-state reproducibility
- make the approved-source record more locally self-contained

Tasks:

- locally preserve the approved non-local sources where appropriate
- prioritize fragile or likely-to-disappear sources first
- keep `source-manifest.json` current as local captures are added
- keep the public project page and status export in sync as the archive materially changes

Priority queue:

- Yahoo Games cluster
- fragile press items
- acquisition and investor trail sources
- university and official-company context pages

### Phase 4: resumable research and restoration

Status: `later`

Goals:

- resume targeted research only after workspace continuity and preservation completeness are stable
- keep new work structured and reproducible

Tasks:

- restart only with a named campaign
- update manifests and project pages as each campaign lands
- begin code or artifact restoration work only from the canonical workspace

## Practical next-step path from here

1. Continue Kinitos local work from `/Users/steven/Projects-All/public` only.
2. Preserve the approved non-local sources, starting with the Yahoo cluster and fragile press items.
3. Capture additional local copies for high-value first-party or archived material when the evidence is strong.
4. Keep the manifest triad, public page, and status export aligned as the archive changes.
5. Treat `public-quack-recovery` as reference-only until you are fully comfortable retiring it.
6. After the preservation pass, resume broader research or restoration campaigns in named batches.

## Why this ordering matters

The workspace continuity problem is now largely solved. The bigger remaining risk is that important approved sources still depend on external web availability.

The right sequence is:

- first consolidate the canonical workspace
- then preserve fragile evidence
- then resume broader research or restoration

## Update rule

When the project advances, update this file along with:

- `project-manifest.json` when the current focus changes materially
- the working repository page when the operational state changes materially
- the dated recovery audit when a new formal audit is warranted
