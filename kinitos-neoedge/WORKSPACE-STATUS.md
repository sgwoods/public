# Kinitos / NeoEdge Workspace Status

Last updated: `2026-05-03`

This file exists to prevent confusion about which local checkout is current, which ones are transitional, and which folders are support-only.

## Canonical active local workspace

Use this checkout for active local Kinitos / NeoEdge work going forward:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

Why this one is canonical:

- it is iCloud-backed
- it is on branch `codex/public-recovery-stabilization`
- it has the current Kinitos continuity and planning updates
- it is the workspace verified for ongoing local archive work

Operational rule:

- new raw captures, downloaded artifacts, draft notes, and restoration experiments should begin here, not in older non-iCloud checkouts

## Transitional non-canonical checkout

This checkout should now be treated as transitional for Kinitos local work:

- `/Users/stevenwoods/GitPages/public`

Use it only as a temporary bridge while the iCloud-backed workspace is taking over.

Do not use it as the default place for:

- new local-only archive captures
- new Kinitos draft intake work
- restoration experiments
- long-running active Kinitos archive work

## Non-canonical parallel iCloud checkout

This iCloud-backed checkout exists, but it is not the current canonical Kinitos workspace:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`

Reason:

- it is a separate checkout
- it is on `main`
- it already has unrelated local modification state
- the verified Kinitos continuation point is `public-quack-recovery`, not this checkout

Unless we intentionally consolidate later, treat this as an older parallel iCloud checkout, not the active Kinitos work area.

## Support-only scaffold

This subtree remains useful, but it is not the canonical deep archive root:

- `public/data/kinitos-neoedge/`

Use it for:

- intake conventions
- support documentation
- workflow context
- older scaffold continuity

Do not treat it as the main active archive root. The canonical deep archive root is:

- `public/kinitos-neoedge/`

## Big picture

The project is now in a safer state:

- committed git history preserves the continuity work
- the active local workspace is iCloud-backed
- the current task is no longer continuity lock-in
- the current task is preservation completeness from the canonical iCloud-backed workspace

## Next few steps

1. Continue Kinitos local work from the canonical iCloud-backed workspace only.
2. Preserve the approved non-local sources, starting with the Yahoo cluster and fragile press items.
3. Keep `WORK-PLAN.md`, `WORKSPACE-STATUS.md`, and `project-manifest.json` current as the archive moves forward.
