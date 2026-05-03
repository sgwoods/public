# Kinitos / NeoEdge Living Work Plan

Last updated: `2026-05-03`

This is the living execution plan for the Kinitos / NeoEdge archive project. Keep it current as the archive advances.

## Operating rule

Going forward, all local working activity for this project should happen in an iCloud-backed folder only.

That changes the workflow in one important way:

- no new local-only capture, intake, or restoration work should begin from a non-iCloud working directory once the current continuity cleanup is complete

Git history is still the primary canonical record. iCloud is the required local continuity layer for everything that is not yet committed or pushed.

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
- five local HTML captures are already preserved in git
- a dated recovery audit exists at `PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- the next operational constraint is now iCloud-backed local continuity

## Active plan

### Phase 1: continuity lock-in

Status: `completed`

Goals:

- preserve the current archive state in committed git history
- make the shared workflow recovery file tracked
- make the current Kinitos continuity docs part of the repo state

Completed checkpoint:

- Kinitos continuity documentation was written and locked into the archive workflow on the stabilization branch
- the shared checked-in workflow baseline is already present in the repo
- the remaining immediate action is to publish the current Kinitos-scoped commit without mixing in unrelated repo work

### Phase 2: iCloud workspace migration

Status: `active next phase`

Goals:

- move active local archive work into an iCloud-backed working folder
- ensure future uncommitted materials are protected by both git and iCloud

Tasks:

- choose the canonical iCloud-backed workspace path for active archive work
- clone or move the active `public` working copy into that iCloud-backed location
- verify that the Kinitos archive can be opened and continued there without missing local-only context
- treat the current non-iCloud checkout as transitional only after migration succeeds

Operational rule after migration:

- new raw captures, draft notes, downloaded artifacts, and restoration experiments should begin only inside the iCloud-backed workspace

### Phase 3: preservation completeness

Status: `queued`

Goals:

- reduce dependence on external live URLs
- improve exact-state reproducibility

Tasks:

- locally preserve the approved non-local sources where appropriate
- prioritize fragile or likely-to-disappear sources first
- keep `source-manifest.json` current as local captures are added

Priority queue:

- Yahoo Games cluster
- fragile press items
- acquisition and investor trail sources
- university and official-company context pages

### Phase 4: resumable research and restoration

Status: `later`

Goals:

- resume targeted research only after continuity and migration are settled
- keep new work structured and reproducible

Tasks:

- restart only with a named campaign
- update manifests and project pages as each campaign lands
- begin code or artifact restoration work only from the iCloud-backed workspace

## Practical next-step path from here

1. Publish the current Kinitos continuity commit from the existing checkout.
2. Establish the canonical iCloud-backed local workspace for active archive work.
3. Open the project from that iCloud-backed workspace and verify the recovery path.
4. Treat the current non-iCloud checkout as transitional only after the iCloud-backed workspace is verified.
5. Only then resume local collection, source capture, or restoration tasks.

## Why this ordering matters

If we keep collecting from the current non-iCloud checkout before migration, we create new local-only risk exactly when the archive is trying to remove that risk.

The right sequence is:

- first stabilize
- then migrate
- then collect again

## Update rule

When the project advances, update this file along with:

- `project-manifest.json` when the current focus changes materially
- the working repository page when the operational state changes materially
- the dated recovery audit when a new formal audit is warranted
