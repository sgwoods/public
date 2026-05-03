# Quack project state and recovery

Updated: 2026-05-03

## Precise goal

The Quack project is the canonical deep archive for the Quack.com company story within this workspace.

Its purpose is to preserve and organize:

- company history
- archived source material
- partner and investor context
- people and founder follow-up leads
- research outputs that can support later public pages and public-handoff summaries

The top-level `public` site is the Steven-centric downstream hub, not the owner of Quack-specific interpretation.

## Current state

- archive structure exists under `quack/`
- formal interface files exist:
  - `quack/project-manifest.json`
  - `quack/source-manifest.json`
  - `quack/public-handoff.json`
- generated research workspace exists:
  - `quack/research/source-leads.json`
  - `quack/research/timeline.json`
  - `quack/research/entities.json`
  - `quack/research/topic-briefs/`
  - `quack/research/run-report.md`
  - `quack/research/campaigns/`
- standalone public project page exists at `quack-com.html`
- public project card manifest exists at `data/projects/quack-com.json`
- Quack pipeline exists at `quack/tools/quack_research_pipeline.py`

## Current status

- project phase: active research archive
- current focus: targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press
- approved sources: 6
- deferred sources: 14
- local archive copies referenced in `source-manifest.json`: 5
- verified continuity status:
  - no machine-specific absolute paths remain in Quack's active research or manifest outputs
  - no repo docs still depend on external local Codex-skill paths
  - the checked-in workflow snapshot in `data/shared/` is sufficient to resume the method from a fresh checkout
- local-workspace policy:
  - going forward, substantive local work for this project should be done only from an iCloud-backed working folder
  - the current checkout at `/Users/stevenwoods/GitPages` should be treated as a transition workspace until that migration is complete
- remote continuity status:
  - the latest Quack continuity/recovery savepoint has been committed and pushed to remote branch `codex/public-recovery-stabilization`
  - the default branch may still trail this state until that work is merged

## Recommended next steps

1. Create or refresh an iCloud-backed checkout of the `public` repo and make that the canonical local workspace.
2. Check out `codex/public-recovery-stabilization` there or merge it there as appropriate.
3. Verify the iCloud-backed checkout by opening this file, rerunning the Quack pipeline, and confirming the project page and manifests regenerate cleanly.
4. Decide whether to merge the Quack continuity savepoint into the default branch once the iCloud-backed workspace is confirmed clean.
5. Preserve stronger first-party Quack or AOL by Phone captures.
6. Strengthen investor-outcome sources with better preserved or filing-style material.
7. Continue founder and related-people source collection, especially Alex Quilici and Jeromy Carriere.
8. Promote only well-supported deferred sources; keep weak leads explicit.
9. Keep manifests, project page, and campaign notes in sync whenever the archive materially changes.

## Forward plan

The working plan for the next stage is:

1. Use the pushed continuity branch as the current safe recovery point.
2. Move active local work to an iCloud-backed folder.
3. Validate Quack regeneration in that iCloud-backed checkout.
4. Treat the iCloud-backed checkout as the only place for new captures, artifact edits, research-ledger updates, and page/manifest regeneration.
5. Merge or publish from that stabilized workspace once verified.
6. Use this document as the running project-state note and update it whenever the archive materially changes.

## What is checked in

Checked-in Quack continuity surfaces inside the `public` repo include:

- all core Quack archive files under `quack/`
- the standalone public page `quack-com.html`
- the public project card manifest `data/projects/quack-com.json`
- the archive coordination contract `ARCHIVE_PROJECT_INTERFACE.md`
- tracked shared workflow and intake guidance under `data/shared/`

Checked-in artifact copies directly owned by Quack include:

- `quack/historic/artifacts/archive-html/computerworld-net-finds-voice-2001.html`
- `quack/historic/artifacts/archive-html/internetnews-another-feather-in-aols-cap-2000.html`
- `quack/historic/artifacts/archive-html/sfgate-earful-of-internet-2000.html`
- `quack/historic/artifacts/archive-html/usask-alumni-profile-2021.html`
- `quack/historic/artifacts/archive-html/uwaterloo-entrepreneurship-impact-series.html`

Checked-in external-but-relied-on archive context also exists elsewhere in the same repo:

- `steven-woods-research/research/media-sources-review.md`
- `steven-woods-research/historic/artifacts/archive-html/`
- `steven-woods-research/source-manifest.json`

## What is not checked in

The checked-in baseline is strong, and the latest Quack continuity work has been pushed to remote branch `codex/public-recovery-stabilization`.

This means:

- a fresh checkout can resume exactly from that branch
- the default branch may still lag until this work is merged
- because the current working tree is not in an iCloud-backed location, it should not be treated as the long-term canonical local workspace for new project work

The `public` repo also has unrelated local modifications outside this project:

- `ai-dystopia-quotes.html`
- `data/ai-dystopia-quotes.approved.json`
- `data/projects/ai-dystopia-quotes.json`

These unrelated files do not block Quack recovery, but they mean the overall `public` repo working tree is not globally clean.

Local Codex skills outside the `public` repo are not required for Quack recovery anymore. The checked-in workflow baseline is now:

- `data/shared/company-research-workflow.md`
- `data/shared/incoming-artifact-analysis-playbook.md`
- `data/shared/incoming-artifact-analysis-template.md`

## Artifact-state audit

Quack is now self-contained for continuation of archive work:

- local Quack-owned archive copies exist for the sources Quack explicitly mirrored
- source ledger, timeline, entities, campaigns, and public handoff are checked in
- the standalone public page and the generator that produces it are checked in

Not every source in `quack/source-manifest.json` has a local mirrored copy. Some entries still depend on canonical public URLs. These are mostly deferred sources plus a few approved institutional or patent sources that are cited by stable canonical URL rather than mirrored locally.

Sources currently still relying on canonical URLs rather than Quack-owned local mirrors include:

- investor and financing coverage such as `VC Buzz - $246.55+ Million in Today's Deals`
- post-acquisition and partner context such as `AOL Formalizes 'Anywhere' Strategy`, `Lycos, Quack.com Launch New Portal`, and `SpeechWorks: Calling on Investors`
- stronger market or outcome leads such as `If It Walks Like a Duck, Quack.com` and `AOL Buys a Voice Portal, Boosting Bid.com's Fortunes`
- institutional or patent references that remain acceptable by canonical URL, including the Jeromy Carriere Waterloo profile and two patent records

## Recovery guarantee

If the local directory tree is lost, the checked-in Quack baseline is sufficient to resume Quack work without rediscovery of the archive structure, manifests, source ledger, campaigns, topic briefs, or project page.

To resume from the exact latest continuity state documented here, use remote branch `codex/public-recovery-stabilization` until those changes are merged into the default branch.

Recovery steps on a new machine:

1. Check out the `public` repo.
2. Check out branch `codex/public-recovery-stabilization` if the default branch does not yet include this continuity state.
3. Open `ARCHIVE_PROJECT_INTERFACE.md`.
4. Open `quack/PROJECT-STATE-AND-RECOVERY.md`.
5. Use `data/shared/company-research-workflow.md` plus the tracked intake playbook/template.
6. Resume from `quack/research/run-report.md`, `quack/research/source-leads.json`, and the campaign notes.
7. Regenerate derived outputs with `python3 quack/tools/quack_research_pipeline.py run` if needed.
8. Validate portability with `python3 quack/tools/quack_research_pipeline.py validate`.

Preferred recovery/workflow policy going forward:

1. Clone or sync the repo into an iCloud-backed folder first.
2. Do substantive local archive work only from that iCloud-backed checkout.
3. Use non-iCloud copies only as temporary migration or verification workspaces, not as the place where new archive progress accumulates.

## Remaining continuity risks

- some manifest entries still rely on external canonical URLs rather than local mirrors
- some research leads still contain weaker deferred evidence that needs stronger sourcing before promotion
- unrelated files elsewhere in the `public` repo may still be locally modified, so whole-repo publishing should still be done with care
- until the continuity branch is merged, the default branch still trails the documented Quack state
