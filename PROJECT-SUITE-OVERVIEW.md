# Project Suite Overview

Updated: `2026-10-03`

Repo-owned coordination layer for the full Steven Woods public suite. Per-project manifests remain the factual status layer; this file is the judgment layer for priority, quality, likely current work, and next-step tradeoffs. October 3, 2026 audit checked GitHub default-branch commits for the four public standalone projects and the MMath runner, local checkout status, and selected unmerged shared-hub and PhD branches. Aurora has September development beyond its June production export; Kinitos has unmerged preservation work; MMath, PhD, and AI Quotes have smaller May status gaps. This is a repository evidence audit, not a runtime or deployment certification. Private implementation and the full set of historical development branches were not audited.

This overview tracks the current repo coordination state in this checkout.
Per-project manifests remain the factual status layer; this overview is the portfolio judgment layer.

Current branch snapshot: `main`

## What This Page Is For

- Keep one durable portfolio-level mental model in the repo instead of in chat only.
- Separate factual project status from portfolio judgment, so the manifest exports can stay factual while priority and time-energy-value tradeoffs can change faster.
- Make reprioritization explicit by editing one small source file and rerendering the public and repo-readable overview surfaces.

## Update Workflow

- Update the owning project manifest or archive manifest first when factual project status changes.
- Edit this file when priority_now, likely_current_work, next_step, quality_note, or drift_note changes materially.
- Run `python3 tools/refresh_public_coordination.py` to validate the suite notes and rerender the repo overview plus homepage from the current manifests.
- Use `python3 tools/refresh_public_coordination.py --check` when you want a no-write drift check for the generated coordination surfaces.

## Time-Energy-Value Rules

- Protect already-public software and reference surfaces before starting wide new research lanes.
- Prefer publish-refresh work when local archive or documentation progress already exists but the public surface is behind; that is often the best time-energy-value move.
- Use small seeding passes for scaffolded archives instead of broad redesigns.
- Treat this overview as the place to reprioritize, and the per-project manifests as the place to state factual current status.

## Current Priority Lanes

- **Protect public surfaces** (2): Keep already-public software, docs, and dashboards trustworthy before expanding scope.
- **Publish local progress** (1): High-value, usually lower-energy work where repo docs or manifests are already ahead of the public surface.
- **Steady advance** (7): Important ongoing work that benefits from regular small batches rather than a one-off push.
- **Seed and clarify** (1): Early-stage areas where a small baseline is more valuable than broad exploration.
- **Private tracking** (1): Keep only a high-level public summary while the underlying work remains private.

## Web Entry Point

### Reference Pages

- [Project suite overview](project-suite-overview.html): Portfolio map, public/private surface guide, and reprioritization layer across the full project suite.
- [Profile](steven-woods-profile.html): Compact executive profile with current links to LinkedIn, Inovia, and the open archive projects.
- [Academic ancestry](academic.html): Direct advisor lineage with links to the Mathematics Genealogy Project.
- [Patents and publications](patents-publications.html): Selected books, patents, and academic publications.

### Recovered Legacy Archives

- [Old Research Archive Recovery](Spectra/Html/index-spectra.html): Recovered entry point for the historical Spectra research site, including preserved publication, course, bibliography, reserve, and raw research-artifact archives.

### Active Project Cards

| Project | Surface Class | Visibility | Priority | Current Manifest State |
| --- | --- | --- | --- | --- |
| [Aurora Galactica](aurora-galactica.html) | Standalone repo export | Public | Protect public surfaces | 1.4.1; Aurora 1.4.1 is the production quality release for hosted `/production`, promoted from the accepted 1.4.1 beta review with Stage 3 keepers, audio/theme clarity, sign-in repair, and stronger release gates. |
| [Plan private rental portal](confidential-project.html) | Private project summary | Mixed public summary / private implementation | Private tracking | Confidential project; Private rental portal and related product work |
| [AI Dystopia Quotes](ai-dystopia-quotes.html) | Standalone repo export | Public | Steady advance | Active curation + publishing; Growing the approved canon and widening discovery |
| [PhD renovation project](phd-renovation.html) | Standalone repo export | Public | Steady advance | 1.0.0; Intake + continuity |
| [Masters of Mathematics renovation project](mmath-renovation.html) | Standalone repo export | Public | Protect public surfaces | 1.0.0-rc.1; Portability hardening and disciplined post-RC continuation |
| [Steven Woods Public Record Project](https://sgwoods.github.io/public/steven-woods-research.html) | Shared-public archive subproject | Public | Steady advance | Active research archive; Continuity layer, baseline identity, timeline, current profile sources, and one-page CV |
| [Steven at Google Canada Archive](https://sgwoods.github.io/public/google-canada-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; Expanded baseline with original-provenance interview coverage and first-party transition context |
| [Steven at Inovia Archive](https://sgwoods.github.io/public/inovia-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; First-source baseline, continuity-safe restartability, and the next round of current-role and ecosystem capture |
| [Canberra / CSIRO / Knights Archive](https://sgwoods.github.io/public/canberra-research.html) | Shared-public archive subproject | Public | Seed and clarify | Scaffolded research project; CSIRO references, Knights records, and Australian local context |
| [SEI Pittsburgh Archive](https://sgwoods.github.io/public/sei-pittsburgh-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; Expanded baseline with two additional SEI papers and a localized AOL bridge |
| [Quack.com Archive Project](https://sgwoods.github.io/public/quack-com.html) | Shared-public bridge archive | Public | Steady advance | Active research archive; Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press |
| [Kinitos / NeoEdge Networks Archive](https://sgwoods.github.io/public/kinitos-neoedge.html) | Shared-public bridge archive | Public | Publish local progress | Active research archive; Preservation completeness underway; sixteen approved sources now have local copies, including the GamesBeat funding-and-merger cluster |

## Project Records

### Aurora Galactica

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short
- Current manifest state: Current release: 1.4.1. Current focus: Aurora 1.4.1 is the production quality release for hosted `/production`, promoted from the accepted 1.4.1 beta review with Stage 3 keepers, audio/theme clarity, sign-in repair, and stronger release gates.. Last repo update: June 11, 2026.
- Likely current work: GitHub main at 181d8e296a (September 24) promotes a bounded Guardians Stage 5 dive policy after candidate/readability work. The local checkout also has uncommitted review-launcher, gameplay-adapter, rendering, and UI changes. The exported production baseline remains Aurora 1.4.1 build 1164 from June 11.
- Next step: Finish and validate the local Guardians review work in the owning repo, commit it there, then reconcile development versus hosted production and export an accurate status. Do not label September development as a new production release without release evidence.
- Quality: This is the strongest product-style public surface in the suite, so small inconsistencies are disproportionately expensive.
- Coordination note: High-value continuity task: preserve and review current local work before starting another gameplay or publication batch.
- Drift note: Verified October 3: public export source 54398ff5 is dated June 11; GitHub main is 181d8e296a dated September 24. The owning repo also has local uncommitted work. Repository activity and the production release are distinct.
- Public links: [Project page](aurora-galactica.html), [Dashboard](https://sgwoods.github.io/Aurora-Galactica/release-dashboard.html), [Live experience](https://sgwoods.github.io/Aurora-Galactica/), [Repository](https://github.com/sgwoods/Codex-Test1), [Open beta build](https://sgwoods.github.io/Aurora-Galactica/beta/), [Open project guide](https://sgwoods.github.io/Aurora-Galactica/project-guide.html), [Open Platinum guide](https://sgwoods.github.io/Aurora-Galactica/platinum-guide.html)

### Plan private rental portal

- Surface class: Private project summary
- Visibility: Mixed public summary / private implementation
- Priority now: Private tracking
- Time-energy-value: energy medium; value high; horizon ongoing
- Current manifest state: Current phase: Confidential project. Current focus: Private rental portal and related product work. Last repo update: April 1, 2026.
- Likely current work: Private rental-portal delivery and related product execution.
- Next step: Keep the public summary minimal and accurate; do not expand the public surface unless there is a deliberate client-safe artifact to add.
- Quality: The public/private boundary is already clear, which is the main quality goal here.
- Coordination note: Track only high-level continuity in public.
- Public links: [Project page](confidential-project.html)

### AI Dystopia Quotes

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy low; value medium-high; horizon short
- Current manifest state: Current stage: Active curation + publishing. Current focus: Growing the approved canon and widening discovery. Last repo update: May 9, 2026.
- Evidence status: Approved corpus: 32 entries.
- Likely current work: GitHub main 7b71714c14 (May 9) updates the source-scan ledger from 139 to 145 and aligns status documentation. The added scans report no new quotes or source leads. The local checkout is clean.
- Next step: Reconcile status metadata through the existing export path, then favor one targeted editorial intake batch over repeating broad scans that produced no additions.
- Quality: The public page already reads cleanly and feels complete enough to trust; the main question is breadth and selection quality.
- Coordination note: Low effort status reconciliation; measure future curation value by approved additions, not scan count.
- Drift note: October 3 audit found a May 9 scan-log/status commit after the hub's May 9 export timestamp; that commit does not demonstrate approved-corpus growth. No newer default-branch commit was found.
- Public links: [Project page](ai-dystopia-quotes.html), [Repository](https://github.com/sgwoods/sci-fi-ai-dystopian-project), [Open approved JSON](data/ai-dystopia-quotes.approved.json), [Open project manifest](data/projects/ai-dystopia-quotes.json)

### PhD renovation project

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium; value high; horizon medium
- Current manifest state: Current build line: 1.0.0. Current focus: Intake + continuity. Last repo update: May 3, 2026.
- Likely current work: GitHub main 2bdf7a8bf6 (May 4) records the proven other-Mac clone after bootstrap and artifact-pipeline cleanup. Remote codex/fix-artifact-pipeline has three later migration/reporting documentation commits through 2b4e519210. The clean local checkout is on that branch name but still at 2bdf7a8.
- Next step: Fetch and reconcile the owning checkout with its remote documentation branch, review the three documentation commits for integration, then refresh the public status export. Keep intake/recovery as the next research lane; no new release was identified.
- Quality: One of the most mature documentation and validation surfaces in the suite.
- Coordination note: Good candidate for steady, bounded progress rather than urgent intervention.
- Drift note: October 3 audit: public manifest is dated May 3; main and the remote documentation branch have May 4 work. Local tracking status alone did not reveal the remote branch advance because its tracking ref was stale.
- Public links: [Project page](phd-renovation.html), [Dashboard](https://sgwoods.github.io/public/phd-renovation-dashboard.html), [Repository](https://github.com/sgwoods/phd-renovation), [Open handbook](phd-renovation-handbook.html), [Open thesis PDF](phd-renovation-thesis.pdf), [Open roadmap](https://github.com/sgwoods/phd-renovation/blob/main/RENOVATION.md)

### Masters of Mathematics renovation project

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short-medium
- Current manifest state: Current release: 1.0.0-rc.1. Current focus: Portability hardening and disciplined post-RC continuation. Last repo update: May 4, 2026.
- Likely current work: GitHub main ff7b8f4ae8 (May 9) clarifies the hosted-runner contract after portability and public-export cleanup. Runner main b71c6a8cc4 also documents that role. Both local checkouts are clean; no newer default-branch commits were found.
- Next step: Review preserved public commit 11329bd, which points experience_url to the hosted runner, verify that destination, and integrate the link correction. Re-export status through the owning repo while retaining the 1.0.0-rc.1 release unless release evidence changes.
- Quality: Strong research-restoration presentation with clear public framing; still benefits from discipline more than expansion.
- Coordination note: Small, bounded integration task with good coordination value; this audit does not establish a new release.
- Drift note: October 3 audit: hub repo_pushed_at still says May 4; owning main has May 9 documentation and export work. Shared-hub branch codex/excluded-mmath-11329bd contains an unmerged runner-link change.
- Public links: [Project page](mmath-renovation.html), [Dashboard](https://sgwoods.github.io/public/mmath-renovation-release-dashboard.html), [Live experience](https://sgwoods.github.io/public/mmath-renovation-remote-experiments.html), [Repository](https://github.com/sgwoods/mmath-renovation), [Open remote experiments guide](mmath-renovation-remote-experiments.html), [Open thesis PDF](mmath-thesis.pdf), [Open roadmap](https://github.com/sgwoods/mmath-renovation/blob/main/docs/project-goal-roadmap.md)

### Steven Woods Public Record Project

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Continuity layer, baseline identity, timeline, current profile sources, and one-page CV. Last repo update: May 10, 2026.
- Evidence status: Evidence baseline: 22 approved / 0 deferred / 0 rejected (22 total).
- Likely current work: Person-centric continuity work, baseline identity tightening, profile preservation, and keeping the source-manifest and review-ledger split deliberate.
- Next step: Preserve the remaining URL-backed baseline pages and reconcile the review-ledger-only captures that should become formal source records.
- Quality: One of the best organized archive areas, with clear role boundaries and strong continuity surfaces.
- Coordination note: Use this as the canonical person-centric layer, not a dumping ground for company-depth material.
- Public links: [Project page](https://sgwoods.github.io/public/steven-woods-research.html), [Open one-page CV](steven-woods-cv.pdf), [Open work plan](steven-woods-research/WORK-PLAN.md), [Open review ledger](steven-woods-research/research/media-sources-review.md)

### Steven at Google Canada Archive

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy low-medium; value high; horizon short
- Current manifest state: Current phase: Seeded era archive. Current focus: Expanded baseline with original-provenance interview coverage and first-party transition context. Last repo update: May 11, 2026.
- Evidence status: Evidence baseline: 9 approved / 0 deferred / 0 rejected (9 total).
- Likely current work: Now that the seeded baseline is public, deepen interview, media, and transition coverage in small, high-signal batches.
- Next step: Add one more interview or ecosystem source batch, then tighten the public summary only if the center of gravity changes materially.
- Quality: Now has a seeded, continuity-safe public baseline with room for deeper source density.
- Coordination note: Good candidate for steady, source-batch progress rather than another structural pass.
- Public links: [Project page](https://sgwoods.github.io/public/google-canada-research.html), [Open working repository](google-canada-research/), [Open work plan](google-canada-research/WORK-PLAN.md), [Open recovery audit](google-canada-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md)

### Steven at Inovia Archive

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy low; value medium-high; horizon short
- Current manifest state: Current phase: Seeded era archive. Current focus: First-source baseline, continuity-safe restartability, and the next round of current-role and ecosystem capture. Last repo update: May 11, 2026.
- Evidence status: Evidence baseline: 3 approved / 0 deferred / 0 rejected (3 total).
- Likely current work: Seeded-baseline maintenance plus current-role, team-profile, and ecosystem appearance capture.
- Next step: Localize the current team profile and add one more public-appearance or ecosystem source batch.
- Quality: The continuity structure is in place; the main gap now is source depth rather than project setup.
- Coordination note: Best advanced through small, explicit source batches.
- Public links: [Project page](https://sgwoods.github.io/public/inovia-research.html), [Open working repository](inovia-research/), [Open work plan](inovia-research/WORK-PLAN.md), [Open recovery audit](inovia-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md)

### Canberra / CSIRO / Knights Archive

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Seed and clarify
- Time-energy-value: energy medium; value medium; horizon short
- Current manifest state: Current phase: Scaffolded research project. Current focus: CSIRO references, Knights records, and Australian local context. Last repo update: March 24, 2026.
- Evidence status: Evidence baseline: no formal source records yet.
- Likely current work: Still mostly a scaffold, with the core value in establishing a first honest source baseline rather than broad research.
- Next step: Seed the first CSIRO, Canberra Knights, and local-context sources so the archive has a real evidence floor.
- Quality: Clear structure exists, but there is not yet enough source depth to treat it as active archive work in the same way as the stronger projects.
- Coordination note: Good candidate for a small, bounded seeding pass rather than a big research campaign.
- Public links: [Project page](https://sgwoods.github.io/public/canberra-research.html), [Open working repository](canberra-research/), [Open seed leads](canberra-research/research/seed-leads.md)

### SEI Pittsburgh Archive

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy low-medium; value high; horizon short
- Current manifest state: Current phase: Seeded era archive. Current focus: Expanded baseline with two additional SEI papers and a localized AOL bridge. Last repo update: May 11, 2026.
- Evidence status: Evidence baseline: 12 approved / 0 deferred / 0 rejected (12 total).
- Likely current work: Seeded-baseline maintenance plus additional staff, paper, and startup-transition context around the SEI-to-Quack bridge.
- Next step: Add one more staff or transition-context batch, then refresh the summary only when the bridge story materially improves.
- Quality: Strong continuity and evidence progress, with a published baseline that now supports steady deepening.
- Coordination note: Good steady research lane now that the scaffold phase is over.
- Public links: [Project page](https://sgwoods.github.io/public/sei-pittsburgh-research.html), [Open working repository](sei-pittsburgh-research/), [Open work plan](sei-pittsburgh-research/WORK-PLAN.md), [Open recovery audit](sei-pittsburgh-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md)

### Quack.com Archive Project

- Surface class: Shared-public bridge archive
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium-high; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press. Last repo update: May 10, 2026.
- Likely current work: Preservation and source-completeness work around AOL by Phone, investor outcomes, first-party capture gaps, and stronger preserved press.
- Next step: Keep working campaign-by-campaign, preserving fragile or first-party evidence before widening the editorial surface.
- Quality: A strong archive workflow is in place, but evidence completeness still matters more than polish.
- Coordination note: Treat the bridge record as compatibility, not as a second canonical home.
- Public links: [Project page](https://sgwoods.github.io/public/quack-com.html), [Open working repository](quack/), [Open work plan](quack/WORK-PLAN.md), [Open run report](quack/research/run-report.md)

### Kinitos / NeoEdge Networks Archive

- Surface class: Shared-public bridge archive
- Visibility: Public
- Priority now: Publish local progress
- Time-energy-value: energy medium-high; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Preservation completeness underway; sixteen approved sources now have local copies, including the GamesBeat funding-and-merger cluster. Last repo update: May 10, 2026.
- Evidence status: Evidence baseline: 24 approved / 8 deferred / 0 rejected (32 total).
- Likely current work: Remote branch codex/kinitos-private-evidence-first-contact remains six commits ahead of public main for this work, ending at 3992c6e. Its manifest reports all 24 approved sources localized, versus the public summary's 16; it also contains evidence-derived corroboration notes.
- Next step: Review the six branch commits and evidence-derived notes for public suitability, integrate the approved preservation work, and regenerate the archive's public outputs and bridge manifest. Then continue deferred-source and corroboration work.
- Quality: One of the strongest deep archives in the suite after Steven and Quack, with clear continuity discipline.
- Coordination note: Highest-value publication candidate: substantial preservation work already exists. Integration needs a content review; this audit did not merge or certify the evidence-derived notes.
- Drift note: Verified October 3 after fetching shared-hub refs: the preservation-complete branch remains unmerged. Branch manifest dated May 17 reports 24 approved sources localized; current public bridge still reports 16.
- Public links: [Project page](https://sgwoods.github.io/public/kinitos-neoedge.html), [Open working repository](kinitos-neoedge/), [Open work plan](kinitos-neoedge/WORK-PLAN.md), [Open recovery audit](kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md)
