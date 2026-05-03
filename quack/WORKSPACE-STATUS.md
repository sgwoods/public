# Quack Workspace Status

Last updated: `2026-05-03`

This file exists to prevent confusion about which local checkout is current, which ones are transitional, and which folders are support-only.

## Canonical active local workspace

Use this checkout for active local Quack work going forward:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

Why this one is canonical:

- it is iCloud-backed
- it is on branch `codex/public-recovery-stabilization`
- it contains the current Quack continuity and recovery plan
- it has been validated by rerunning the Quack pipeline and portability checks

Operational rule:

- new raw captures, downloaded artifacts, draft notes, restored HTML, and research-ledger updates should begin here, not in older checkouts

## Deprecated transition checkout

This checkout should now be treated as deprecated for active Quack local work:

- `/Users/stevenwoods/GitPages/public`

Use it only as a temporary bridge for:

- reviewing older local state
- confirming what was previously done
- helping reconcile branch history if needed

Do not use it as the default place for:

- new local-only archive captures
- new Quack draft intake work
- restoration experiments
- long-running active Quack archive work

## Non-canonical parallel iCloud checkout

This iCloud-backed checkout exists, but it is not the current canonical Quack workspace:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`

Reason:

- it is a separate checkout
- it is on `main`
- it already has unrelated local modification state
- the verified Quack continuation point is `public-quack-recovery`, not this checkout

Unless we intentionally consolidate later, treat this as an older parallel iCloud checkout, not the active Quack work area.

## Current archive root versus support surfaces

Canonical deep archive root:

- `public/quack/`

Supporting public-summary surfaces:

- `public/quack-com.html`
- `public/data/projects/quack-com.json`

Use the summary surfaces for public presentation and hub consumption. Do not treat them as replacements for the deep archive root.

## Big picture

The project is now in a safer state:

- committed git history preserves the Quack continuity work
- the active local workspace is iCloud-backed
- the Quack archive can be regenerated from the canonical checkout
- the current task is no longer basic continuity lock-in
- the current task is careful archive enrichment from the canonical workspace

## Next few steps

1. Continue Quack local work only from the canonical iCloud-backed workspace.
2. Review whether `codex/public-recovery-stabilization` should be merged cleanly or narrowed before merge.
3. Preserve stronger first-party Quack and AOL-by-Phone materials.
4. Strengthen investor-outcome sourcing and keep the manifests and project page in sync.

## New-Mac handoff

If Quack needs to be resumed on a different Mac, start with:

- `public/START-HERE-NEW-MAC.md`
- `public/tools/start_codex_on_new_mac.sh`

Those are the checked-in bootstrap and validation surfaces for proving the canonical workspace can be recreated elsewhere.
