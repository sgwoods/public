# Kinitos / NeoEdge Portability and Mac Handoff

Last updated: `2026-05-03`

This document is the portability and machine-handoff guide for the Kinitos / NeoEdge archive project.

It exists to answer four questions clearly:

1. what is safely committed and backed up now
2. what local workspace is current
3. how a different Mac should start and validate the project
4. when this current MacBook can be treated as deprecated for Kinitos work

## Current safe state

Canonical active local workspace:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

Current project branch:

- `codex/public-recovery-stabilization`

Current remote:

- `origin https://github.com/sgwoods/public.git`

Current portability rule:

- active local Kinitos work should happen only in the canonical iCloud-backed workspace

Current non-canonical local checkouts:

- transitional non-iCloud checkout: `/Users/stevenwoods/GitPages/public`
- older parallel iCloud checkout: `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`

Support-only subtree:

- `public/data/kinitos-neoedge/`

## What is already backed up safely

The project now has multiple recovery layers:

- committed git history in the `public` repository
- pushed remote branch history on GitHub
- iCloud-backed canonical local checkout
- checked-in continuity and workspace documents inside the repo

The Kinitos archive itself now includes:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`
- `WORK-PLAN.md`
- `WORKSPACE-STATUS.md`
- `PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- research passes
- lead tracker
- local preserved HTML captures

## What a fresh Mac needs

Required:

- macOS with iCloud Drive enabled if using the canonical active-workspace pattern
- `git`
- `python3` version `3.9+`
- Python `zoneinfo` support

Recommended:

- `rg` / ripgrep
- Codex installed and working

Network needs:

- GitHub access for clone, fetch, and pull
- normal web access for ongoing research and source review

## Canonical startup path on a different Mac

Recommended workspace target:

- clone into an iCloud-backed path analogous to:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

Recommended startup steps:

1. clone the `public` repository into the iCloud-backed workspace
2. check out `codex/public-recovery-stabilization`
3. run the start script:
   - `bash kinitos-neoedge/tools/start-kinitos-codex.sh`
4. read the core documents in this order:
   - `ARCHIVE_PROJECT_INTERFACE.md`
   - `kinitos-neoedge/WORKSPACE-STATUS.md`
   - `kinitos-neoedge/WORK-PLAN.md`
   - `kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
   - `kinitos-neoedge/project-manifest.json`
   - `kinitos-neoedge/source-manifest.json`
5. confirm the script reports a clean Kinitos subtree and zero broken local archive paths
6. continue only from that iCloud-backed workspace

## Start script purpose

The start script is meant to validate:

- you are in the right repo
- the key Kinitos continuity files exist
- Python is new enough
- the Kinitos subtree is clean
- the source manifest resolves its local archive paths
- the approved/deferred source counts look sane

It also prints the recommended reading order for Codex startup.

## Validation results so far

The portability package has already been validated in two ways on this machine:

1. canonical iCloud-backed workspace validation passed
   - workspace: `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
   - result: clean Kinitos subtree, correct branch, correct remote, zero broken local archive paths
2. clean-clone simulation passed
   - clone path used for validation: `/tmp/public-kinitos-portability-check`
   - result: clean Kinitos subtree, correct branch, correct remote, zero broken local archive paths

That means portability is strongly evidenced locally.

The remaining final proof is:

- run the same startup script on the different Mac that will replace this one

## When this MacBook can be deprecated for Kinitos work

This MacBook can be treated as deprecated for Kinitos local work once a different Mac has done all of the following successfully:

1. cloned the repo
2. checked out `codex/public-recovery-stabilization`
3. run `kinitos-neoedge/tools/start-kinitos-codex.sh`
4. validated the Kinitos subtree cleanly
5. opened the continuity documents and confirmed the working context is intact

Until then, this MacBook is transitional.

After that point:

- do not begin new Kinitos local work here
- do not treat `/Users/stevenwoods/GitPages/public` as the active Kinitos workspace
- keep this machine only as a fallback reference until you are comfortable retiring it

## Big picture

We are no longer trying to prove only that the archive exists.

We are now trying to prove that:

- the archive can survive this MacBook going away
- the active workspace can move cleanly to another Mac
- Codex can restart with the right context and no hidden machine-local dependency

## Next few steps

1. Run the same startup script on the different Mac that will replace this MacBook.
2. Once that passes, treat this MacBook as deprecated for Kinitos local work.
3. Resume preservation completeness from the canonical workspace.
