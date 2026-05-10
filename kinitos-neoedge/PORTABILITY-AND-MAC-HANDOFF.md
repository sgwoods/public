# Kinitos / NeoEdge Portability and Mac Handoff

Last updated: `2026-05-10`

This document is the portability and machine-handoff guide for the Kinitos / NeoEdge archive project.

It exists to answer four questions clearly:

1. what is safely committed and backed up now
2. what local workspace is current
3. how a different Mac should start and validate the project
4. when the older recovery checkout can be treated as deprecated for active Kinitos work

## Current safe state

Canonical active local workspace:

- `/Users/steven/Projects-All/public`

Current remote:

- `origin https://github.com/sgwoods/public.git`

Reference source-state used for consolidation:

- checkout: `/Users/steven/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- branch: `codex/public-recovery-stabilization`
- commit: `189094d5eb6e71303fad6f56ba90dae587da9722`

Current portability rule:

- active local Kinitos work should happen only in the canonical `Projects-All/public` checkout
- older recovery or legacy checkouts are reference-only unless you are deliberately validating or comparing state

Current non-canonical local checkouts:

- prior source-state checkout: `/Users/steven/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- historical legacy checkout: `/Users/stevenwoods/GitPages/public`

Support-only subtree:

- `public/data/kinitos-neoedge/`

## What is already backed up safely

The project now has multiple recovery layers:

- committed git history in the `public` repository
- pushed remote branch history on GitHub
- a canonical active local checkout in `~/Projects-All/public`
- checked-in continuity, workspace, and restart documents inside the repo

The Kinitos archive itself now includes:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`
- `WORK-PLAN.md`
- `WORKSPACE-STATUS.md`
- `PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- `PORTABILITY-AND-MAC-HANDOFF.md`
- `tools/start-kinitos-codex.sh`
- research passes
- lead tracker
- local preserved HTML captures

## What a fresh Mac needs

Required:

- macOS
- `git`
- `python3` version `3.9+`
- Python `zoneinfo` support

Recommended:

- `rg` / ripgrep
- Codex installed and working

Optional:

- iCloud Drive if you want an extra machine-local sync layer, but it is no longer required for the canonical Kinitos workflow

Network needs:

- GitHub access for clone, fetch, and pull
- normal web access for ongoing research and source review

## Canonical startup path on this or a different Mac

Recommended workspace target:

- `/Users/steven/Projects-All/public`

Recommended startup steps:

1. clone the `public` repository into the preferred working location
2. use `/Users/steven/Projects-All/public` or an analogous `Projects-All/public` path on the new machine
3. check out the intended working branch there
   - preferred resting branch after this consolidation lands: `main`
   - short-lived task branches from `main` are fine for active edits
4. run the start script:
   - `bash kinitos-neoedge/tools/start-kinitos-codex.sh`
5. read the core documents in this order:
   - `ARCHIVE_PROJECT_INTERFACE.md`
   - `kinitos-neoedge/WORKSPACE-STATUS.md`
   - `kinitos-neoedge/WORK-PLAN.md`
   - `kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
   - `kinitos-neoedge/project-manifest.json`
   - `kinitos-neoedge/source-manifest.json`
6. confirm the script reports a clean Kinitos subtree and zero broken local archive paths
7. continue only from that canonical checkout

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

The portability package has already been validated in two important ways:

1. the source-state recovery checkout validated cleanly on branch `codex/public-recovery-stabilization`
2. the continuity layer has now been consolidated into `~/Projects-All/public`, which is the intended long-term working checkout

The highest-value ongoing proof after this consolidation is:

- run the same startup script from the canonical `Projects-All/public` checkout on any future machine that takes over active Kinitos work

## When the old recovery checkout can be treated as deprecated

The old `public-quack-recovery` checkout can be treated as deprecated for active Kinitos work once all of the following are true:

1. the continuity-layer migration into `~/Projects-All/public` is committed
2. the start script passes from `~/Projects-All/public`
3. you are comfortable that the canonical workspace contains the same effective archive context
4. any future active Mac can restart from the canonical workspace without returning to the old checkout

After that point:

- do not begin new Kinitos local work in `public-quack-recovery`
- do not treat `/Users/stevenwoods/GitPages/public` as the active Kinitos workspace
- keep the old recovery checkout only as a fallback reference until you are comfortable archiving or removing it

## Big picture

We are no longer trying to prove only that the archive exists.

We are now trying to prove that:

- the archive can survive the older Mac going away
- the active workspace can continue cleanly from `~/Projects-All/public`
- Codex can restart with the right context and no hidden checkout-local dependency

## Next few steps

1. Validate the canonical `~/Projects-All/public` checkout with the start script after any continuity-layer change.
2. Resume preservation completeness from the canonical workspace.
3. Use the old recovery checkout only for spot-checks until you are fully comfortable retiring it.
