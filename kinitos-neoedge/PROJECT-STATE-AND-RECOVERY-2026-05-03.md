# Kinitos / NeoEdge Project State and Recovery Audit

Audit timestamp: `2026-05-03T14:15:35Z`

Repo: `public`

Repo HEAD at audit time: `bebd97b0264ea21312724c52a46f65707f396145`

Canonical public project page: `public/kinitos-neoedge.html`

Canonical deep archive root: `public/kinitos-neoedge/`

Supporting intake scaffold: `public/data/kinitos-neoedge/`

## Precise goal

This project is the canonical deep archive for the company line that began as Kinitos, evolved into NeoEdge Networks, passed through the Blue Noodle phase, and ended in the 2011 Double Fusion asset and IP transfer story.

The archive is meant to preserve:

- company history and phase transitions
- memories and narrative context
- demos and video leads
- historic artifacts and archived web captures
- recovered code and technical clues
- source manifests and Steven-facing public handoff outputs

The top-level `public` site is not the canonical company-history layer. It only consumes short Steven-relevant summaries from this archive.

## Current state and status

The project is beyond setup and already has a usable archive backbone.

Confirmed archive state:

- canonical archive manifests exist in `public/kinitos-neoedge/`
- a public summary page exists at `public/kinitos-neoedge.html`
- a working repository page exists at `public/kinitos-neoedge/index.html`
- source research has already produced three substantial research passes
- five local Wayback HTML captures are preserved in git
- the company arc now covers Kinitos, NeoEdge, MostFun, Blue Noodle, and the Double Fusion endgame
- the archive coordination contract with `public` is in place

Recommended project status label:

- `Active archive with continuity hardening in progress`

Recommended immediate focus:

- `Recovery audit, preservation completeness, and fresh-checkout continuability`

## What is checked in

At the committed-history level, the archive already has `31` tracked Kinitos-related files in git:

- public pages:
  - `kinitos-neoedge.html`
  - `kinitos-neoedge/index.html`
- machine-readable coordination files:
  - `kinitos-neoedge/project-manifest.json`
  - `kinitos-neoedge/source-manifest.json`
  - `kinitos-neoedge/public-handoff.json`
  - `data/projects/kinitos-neoedge.json`
- archive documentation and research notes:
  - `kinitos-neoedge/README.md`
  - `kinitos-neoedge/incoming/README.md`
  - `kinitos-neoedge/incoming/document-leads.md`
  - `kinitos-neoedge/incoming/research-pass-2026-03-24.md`
  - `kinitos-neoedge/incoming/research-pass-2026-03-24-endgame.md`
  - `kinitos-neoedge/incoming/research-pass-2026-03-24-site-captures.md`
- typed historic lanes:
  - `kinitos-neoedge/historic/README.md`
  - `kinitos-neoedge/historic/memories/README.md`
  - `kinitos-neoedge/historic/demos/README.md`
  - `kinitos-neoedge/historic/code/README.md`
  - `kinitos-neoedge/historic/artifacts/README.md`
  - `kinitos-neoedge/historic/artifacts/archive-html/README.md`
- checked-in local HTML artifact captures:
  - `kinitos-neoedge/historic/artifacts/archive-html/mostfun-homepage-2007-03-20-wayback.html`
  - `kinitos-neoedge/historic/artifacts/archive-html/neoedge-homepage-2007-02-05-wayback.html`
  - `kinitos-neoedge/historic/artifacts/archive-html/mostfun-homepage-2008-04-07-wayback.html`
  - `kinitos-neoedge/historic/artifacts/archive-html/neoedge-homepage-2008-03-15-wayback.html`
  - `kinitos-neoedge/historic/artifacts/archive-html/bluenoodle-homepage-2011-02-08-wayback.html`
- earlier intake scaffold retained for continuity:
  - `data/kinitos-neoedge/AGENTS.md`
  - `data/kinitos-neoedge/README.md`
  - `data/kinitos-neoedge/memories/README.md`
  - `data/kinitos-neoedge/demos/README.md`
  - `data/kinitos-neoedge/demos/video-leads.md`
  - `data/kinitos-neoedge/artifacts/README.md`
  - `data/kinitos-neoedge/code/README.md`

## What is not checked in yet

The Kinitos archive is close to continuity-safe, but not at a perfect fresh-checkout guarantee yet.

Tracked Kinitos-related files with local modifications still outside the last commit:

- `data/kinitos-neoedge/AGENTS.md`
- `data/kinitos-neoedge/README.md`
- `data/projects/kinitos-neoedge.json`
- `kinitos-neoedge.html`
- `kinitos-neoedge/README.md`
- `kinitos-neoedge/index.html`
- `kinitos-neoedge/project-manifest.json`

Related generated public surface with local modifications still outside the last commit:

- `index.html`

Current untracked continuity files:

- `kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
- `data/shared/company-research-workflow.md`

This means:

- the committed repository already preserves the main Kinitos archive structure and research outputs
- the current working tree contains additional continuity improvements that would be lost if this machine disappeared before they were committed

There are also unrelated modified files elsewhere in `public`, but they are outside the Kinitos archive boundary and do not change the company-history record directly.

## State of source preservation

The current `source-manifest.json` contains `32` source records:

- `24` approved
- `8` deferred
- `0` rejected

Approved-source preservation status:

- `5` approved sources have checked-in local archive copies
- `1` approved source depends on an external archive URL
- `18` approved sources currently depend only on canonical live URLs
- `0` approved local archive paths are broken when resolved relative to `public/kinitos-neoedge/`

### Approved sources with checked-in local copies

- `src-mostfun-2007-wayback-homepage-game-player`
- `src-neoedge-2007-wayback-homepage-patent-pending-delivery`
- `src-mostfun-2008-wayback-homepage-game-network`
- `src-neoedge-2008-wayback-homepage-marketplace`
- `src-blue-noodle-2011-wayback-homepage-casual-social`

### Approved source with archive-web only

- `src-neoedge-2008-yahoo-ad-supported-online-gaming` - Yahoo! Announces Ad-Supported Online Gaming

### Approved sources not yet preserved locally

- `src-kinitos-2003-usask-pg-sorenson-lecture` - P.G. Sorenson Lecture: Dr. Steven Woods, CEO of Kinitos, Inc.
- `src-kinitos-2004-internetnews-microsoft-sneak-peek` - Microsoft Offers Sneak Peek to Developers
- `src-kinitos-2005-microsoft-experience-capital-markets-partners` - Microsoft Experience Capital Markets Is Supported by More Than 20 Leading Solution Partners
- `src-neoedge-2007-gamespot-bushnell-joins-board` - Bushnell joins NeoEdge board
- `src-neoedge-2008-gamesbeat-neomom-product-tastes` - NeoEdge Networks launches NeoMOM to measure product tastes
- `src-neoedge-2009-gamesbeat-raises-4m` - NeoEdge raises $4M for in-game video ads from game-focused VC firm
- `src-neoedge-2009-gamesbeat-offspring-merger` - Game ad firm NeoEdge merges with game developer, hires new CEO
- `src-neoedge-2010-gamesbeat-raises-3m` - NeoEdge raises $3M for ad platform for games
- `src-neoedge-2011-gamedeveloper-double-fusion-acquisition` - Double Fusion Expands Its In-Game Advertising With NeoEdge Acquisition
- `src-mostfun-2007-gamezebo-try-before-you-buy` - MostFun.com shakes up try-before-you-buy
- `src-blue-noodle-2010-uspto-trademark-filing` - BLUE NOODLE INC. trademark filing in USPTO Official Gazette
- `src-blue-noodle-2011-adtechdaily-clickstrip-gdc` - Blue Noodle Premiers New Video Ad-Bar, Clickstrip, at Game Developers Conference
- `src-blue-noodle-2011-fortune-mmv-financial-trouble` - Exclusive: MMV Financial in trouble
- `src-blue-noodle-2011-fortune-investor-immorality` - Investor immorality: The strange case of Blue Noodle
- `src-double-fusion-2011-adtechdaily-major-expansion-neoedge-assets` - Major Expansion at In-Gaming Ad Leader Double Fusion
- `src-neoedge-ip-2008-google-patents-interstitial-advertising-chain` - US20080207328A1 - Interstitial advertising in a gaming environment
- `src-neoedge-ip-2010-google-patents-distraction-free-content-chain` - US20100175058A1 - System for providing distraction-free content in a flash-based gaming environment
- `src-kinitos-neoedge-2023-waterloo-rdd-founding-innovation-keynote` - Math and Computing Research Discovery Days: Founding Innovation Keynote: Steven Woods

## Recovery assessment

### What is recoverable from a fresh checkout right now

A fresh checkout of the committed repository is already sufficient to recover:

- the project structure
- the public project summary page
- the working repository page
- the machine-readable manifests
- the three research passes
- the lead tracker
- the five preserved HTML captures
- the distinction between the active deep archive and the earlier intake scaffold

That means the archive can be resumed meaningfully on a new machine without rediscovering the company arc from scratch.

### What is not yet guaranteed from git history alone

The current repository is not yet a perfect `100% complete from latest commit` recovery point for this exact working state, because:

- three Kinitos-related tracked files have uncommitted local edits
- one shared continuity file used by those edits is still untracked
- nineteen approved sources are still not locally preserved, so full source review still depends partly on the public web

### Practical verdict

The Kinitos archive is `continuable`, but not yet `fully self-contained and exact-state reproducible` from git history alone.

To reach that stronger guarantee, the archive should do two things:

1. commit the current local continuity files
2. keep converting approved external-only sources into checked-in local captures where legally and practically appropriate

## Fresh-machine restart procedure

On a new machine, the intended restart path is:

1. clone the `public` repository
2. open `public/kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md`
3. open:
   - `public/kinitos-neoedge/project-manifest.json`
   - `public/kinitos-neoedge/source-manifest.json`
   - `public/kinitos-neoedge/public-handoff.json`
4. read the research passes in `public/kinitos-neoedge/incoming/`
5. inspect the preserved HTML captures in `public/kinitos-neoedge/historic/artifacts/archive-html/`
6. continue work from the canonical deep archive root at `public/kinitos-neoedge/`

The older `public/data/kinitos-neoedge/` tree should be treated as supporting intake and workflow context, not as the canonical deep archive root.

## Recommended next steps

The next-step path has changed because local working activity is now expected to happen in an iCloud-backed folder only.

Revised order:

1. Commit and push the current continuity-oriented working-tree changes so the latest Kinitos workflow state is no longer machine-local only.
2. Check in `data/shared/company-research-workflow.md` so the repo contains its own recovery copy of the shared research method.
3. Establish an iCloud-backed active workspace for ongoing local archive work, then reopen the project there before doing more local ingest.
4. After migration, prioritize local capture of the `19` approved non-local sources, especially fragile press sources and the Yahoo Games cluster.
5. Add a lightweight verification script or repeatable command that reports:
   - Kinitos tracked/untracked status
   - approved-source preservation counts
   - any broken `archive_local` paths
6. After those continuity and migration steps, pause broad research and resume only when:
   - new documents arrive
   - a targeted source-capture campaign is chosen
   - code or artifact restoration work is ready to begin

See also: `WORK-PLAN.md` for the living version of this plan.

## Bottom line

The project is already a real archive, not just a loose lead list.

It is strong enough to continue from a fresh checkout, but not yet strong enough to claim that the exact present working state and all approved-source evidence are fully self-contained in committed git history.
