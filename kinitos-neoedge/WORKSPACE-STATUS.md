# Kinitos / NeoEdge Workspace Status

Last updated: `2026-05-10`

This file exists to prevent confusion about which local checkout is current, which ones are deprecated references, and which folders are support-only.

## Canonical active local workspace

Use this checkout for active local Kinitos / NeoEdge work going forward:

- `/Users/steven/Projects-All/public`

Why this one is canonical:

- it is the intended long-term shared-public working repo on this machine
- it now contains the Kinitos continuity docs, startup validator, shared workflow baseline, manifests, public page, and preserved local artifacts
- it is the workspace that should remain after the older Mac is retired

Operational rule:

- new raw captures, downloaded artifacts, draft notes, and restoration experiments should begin here, not in older recovery or legacy checkouts

## Prior source-state checkout: deprecated reference

This checkout remains valuable as a source-state comparison point, but it is no longer the canonical Kinitos workspace:

- `/Users/steven/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

Use it only for:

- spot-checking the pre-consolidation state
- confirming that continuity files or artifacts were migrated correctly
- emergency fallback while you finish gaining confidence in the canonical workspace

Do not use it as the default place for:

- new local-only archive captures
- new Kinitos draft intake work
- restoration experiments
- long-running active Kinitos archive work

## Historical legacy checkout

If this older path still exists on the older machine, treat it as historical only:

- `/Users/stevenwoods/GitPages/public`

Do not revive it as the active Kinitos workspace.

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

The project is now in a safer and clearer state:

- committed git history preserves the continuity work
- the active local workspace is now `~/Projects-All/public`
- the prior `public-quack-recovery` checkout is deprecated for active Kinitos work
- the current task is preservation completeness and additional local source capture from the canonical workspace

## Next few steps

1. Continue Kinitos local work from the canonical active local workspace only.
2. Preserve the approved non-local sources, starting with the Yahoo cluster and fragile press items.
3. Keep `WORK-PLAN.md`, `WORKSPACE-STATUS.md`, `project-manifest.json`, and the public project page current as the archive moves forward.
