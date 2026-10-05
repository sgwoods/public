# Project Suite Overview

Updated: `2026-10-03`

Repo-owned portfolio coordination. October 3, 2026: 13 active projects, including Star Swarm. Repository observations independently track public default branches and archive paths. All seven shared archives now have verified source commits and content fingerprints; snapshot metadata changes do not count as content drift. MMath, PhD, and AI Quotes use source-aware exports. Star Swarm status imports its existing clean deployed build identity, independent of the coding agent. Private repositories are excluded. See PROJECT-STATUS-CONTRACT.md for upkeep and the Aurora handoff.

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

- **Protect public surfaces** (3): Keep already-public software, docs, and dashboards trustworthy before expanding scope.
- **Publish local progress** (0): High-value, usually lower-energy work where repo docs or manifests are already ahead of the public surface.
- **Steady advance** (8): Important ongoing work that benefits from regular small batches rather than a one-off push.
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
| [Star Swarm](star-swarm.html) | Standalone repo / hosted build import | Public | Protect public surfaces | Build 9b03b10; Playable formation shooter and promptable content system; canonical architecture and roadmap remain in the source repository. |
| [Plan private rental portal](confidential-project.html) | Private project summary | Mixed public summary / private implementation | Private tracking | Confidential project; Private rental portal and related product work |
| [AI Dystopia Quotes](ai-dystopia-quotes.html) | Standalone repo export | Public | Steady advance | Active curation + publishing; Growing the approved canon and widening discovery |
| [PhD renovation project](phd-renovation.html) | Standalone repo export | Public | Steady advance | 1.0.0; Intake triage |
| [Masters of Mathematics renovation project](mmath-renovation.html) | Standalone repo export | Public | Protect public surfaces | 1.0.0-rc.1; Portability hardening and disciplined post-RC continuation |
| [Steven Woods Public Record Project](https://sgwoods.github.io/public/steven-woods-research.html) | Shared-public archive subproject | Public | Steady advance | Active research archive; Continuity layer, baseline identity, timeline, current profile sources, and one-page CV |
| [Steven at Google Canada Archive](https://sgwoods.github.io/public/google-canada-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; Expanded baseline with original-provenance interview coverage and first-party transition context |
| [Steven at Inovia Archive](https://sgwoods.github.io/public/inovia-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; First-source baseline, continuity-safe restartability, and the next round of current-role and ecosystem capture |
| [Canberra / CSIRO / Knights Archive](https://sgwoods.github.io/public/canberra-research.html) | Shared-public archive subproject | Public | Seed and clarify | Scaffolded research project; CSIRO references, Knights records, and Australian local context |
| [SEI Pittsburgh Archive](https://sgwoods.github.io/public/sei-pittsburgh-research.html) | Shared-public archive subproject | Public | Steady advance | Seeded era archive; Expanded baseline with two additional SEI papers and a localized AOL bridge |
| [Quack.com Archive Project](https://sgwoods.github.io/public/quack-com.html) | Shared-public bridge archive | Public | Steady advance | Active research archive; Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press |
| [Kinitos / NeoEdge Networks Archive](https://sgwoods.github.io/public/kinitos-neoedge.html) | Shared-public bridge archive | Public | Steady advance | Active research archive; Approved-source preservation floor completed; all twenty-four approved sources now have local copies, and the next pass can shift to deferred-source and corroboration follow-up |

## Project Records

### Aurora Galactica

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short
- Current manifest state: Current release: 1.4.1. Current focus: Aurora 1.4.1 is the production quality release for hosted `/production`, promoted from the accepted 1.4.1 beta review with Stage 3 keepers, audio/theme clarity, sign-in repair, and stronger release gates.. Last repo update: June 11, 2026.
- Likely current work: GitHub main at 181d8e296a (September 24) promotes a bounded Guardians Stage 5 dive policy after candidate/readability work. The local checkout also has uncommitted review-launcher, gameplay-adapter, rendering, and UI changes. The exported production baseline remains Aurora 1.4.1 build 1164 from June 11.
- Next step: Use the Aurora handoff prompt in PROJECT-STATUS-CONTRACT.md on the active machine. Keep production source metadata tied to the released build, verify the active release lanes, and export only validated changes.
- Quality: This is the strongest product-style public surface in the suite, so small inconsistencies are disproportionately expensive.
- Coordination note: High-value continuity task: preserve and review current local work before starting another gameplay or publication batch.
- Drift note: The GitHub observer now shows newer development independently of the June production export. No Aurora checkout was edited in this pass.
- Public links: [Project page](aurora-galactica.html), [Dashboard](https://sgwoods.github.io/Aurora-Galactica/release-dashboard.html), [Live experience](https://sgwoods.github.io/Aurora-Galactica/), [Repository](https://github.com/sgwoods/Codex-Test1), [Open beta build](https://sgwoods.github.io/Aurora-Galactica/beta/), [Open project guide](https://sgwoods.github.io/Aurora-Galactica/project-guide.html), [Open Platinum guide](https://sgwoods.github.io/Aurora-Galactica/platinum-guide.html)

### Star Swarm

- Surface class: Standalone repo / hosted build import
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short
- Current manifest state: Published build: Build 9b03b10. Project direction: Playable formation shooter and promptable content system; canonical architecture and roadmap remain in the source repository.. Last repo update: October 5, 2026.
- Likely current work: Active Claude/Firstmate development. The reviewed architecture describes playable formation-shooter mechanics, selectable variants, and a prompt-assisted content forge. Recent commits fix exit-card controls and remembered-variant rendering; the October 3 main CI run and Pages deployment passed.
- Next step: Follow the source roadmap: configurable pack/stage editing and playability validation, broader lab previews, and art/audio provenance review. Choose one bounded batch; do not treat roadmap items as shipped.
- Quality: State documentation is checked by tests, and deployment is gated by CI. This audit verified build identity and CI, not exhaustive gameplay quality.
- Coordination note: Agent-neutral integration: Claude, Firstmate, and Codex share the same source repo and deployed build contract. No credentials for the public hub are needed by the source project.
- Drift note: The hub imports clean deployed build.json identities on refresh. Default-branch development is observed separately; detailed feature claims remain in the source architecture.
- Public links: [Project page](star-swarm.html), [Dashboard](https://github.com/sgwoods/star-swarm/actions/workflows/ci.yml), [Live experience](https://sgwoods.github.io/star-swarm/), [Repository](https://github.com/sgwoods/star-swarm), [Canonical architecture](https://github.com/sgwoods/star-swarm/blob/main/docs/ARCHITECTURE.md), [Roadmap](https://github.com/sgwoods/star-swarm/blob/main/docs/ROADMAP.md), [Deployed build identity](https://sgwoods.github.io/star-swarm/build.json)

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
- Current manifest state: Current stage: Active curation + publishing. Current focus: Growing the approved canon and widening discovery. Last repo update: October 3, 2026.
- Evidence status: Approved corpus: 32 entries.
- Likely current work: Public manifest refreshed from clean source 3cbaf56 with explicit commit provenance. The scan-ledger increase to 145 does not imply new approved quotes.
- Next step: Favor one targeted editorial intake batch, then publish through the updated exporter.
- Quality: The public page already reads cleanly and feels complete enough to trust; the main question is breadth and selection quality.
- Coordination note: Source metadata reconciled. Measure future curation value by approved additions rather than scan count.
- Drift note: Export reconciled October 3; the repository observer will flag subsequent source differences.
- Public links: [Project page](ai-dystopia-quotes.html), [Repository](https://github.com/sgwoods/sci-fi-ai-dystopian-project), [Open approved JSON](data/ai-dystopia-quotes.approved.json), [Open project manifest](data/projects/ai-dystopia-quotes.json)

### PhD renovation project

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium; value high; horizon medium
- Current manifest state: Current build line: 1.0.0. Current focus: Intake triage. Last repo update: October 3, 2026.
- Likely current work: Exporter metadata now uses the source commit and real export time. A new --status-only mode refreshes public status without rebuilding thesis artifacts; the release remains 1.0.0.
- Next step: Review the three pre-existing remote migration/reporting documentation commits separately, then continue intake triage.
- Quality: One of the most mature documentation and validation surfaces in the suite.
- Coordination note: Metadata fix published; the remote documentation branch remains a separate integration task.
- Drift note: Public metadata now represents clean source f5eea43. Artifact dates remain independent. The older local checkout was not altered.
- Public links: [Project page](phd-renovation.html), [Dashboard](https://sgwoods.github.io/public/phd-renovation-dashboard.html), [Repository](https://github.com/sgwoods/phd-renovation), [Open handbook](phd-renovation-handbook.html), [Open thesis PDF](phd-renovation-thesis.pdf), [Open roadmap](https://github.com/sgwoods/phd-renovation/blob/main/RENOVATION.md)

### Masters of Mathematics renovation project

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short-medium
- Current manifest state: Current release: 1.0.0-rc.1. Current focus: Portability hardening and disciplined post-RC continuation. Last repo update: October 3, 2026.
- Likely current work: Exporter provenance and public runner-link reconciliation completed October 3. The exported release remains 1.0.0-rc.1.
- Next step: Continue bounded portability or benchmark work; use the updated exporter for subsequent factual status changes.
- Quality: Strong research-restoration presentation with clear public framing; still benefits from discipline more than expansion.
- Coordination note: Small publication gap closed; defer broader benchmark expansion until deliberately prioritized.
- Drift note: Public status now identifies source commit 408c933 and the live runner URL. The runner responded HTTP 200 during this pass; experiment execution was not tested.
- Public links: [Project page](mmath-renovation.html), [Dashboard](https://sgwoods.github.io/public/mmath-renovation-release-dashboard.html), [Live experience](https://abtweak-experiments-ui.vercel.app), [Repository](https://github.com/sgwoods/mmath-renovation), [Open remote experiments guide](mmath-renovation-remote-experiments.html), [Open thesis PDF](mmath-thesis.pdf), [Open roadmap](https://github.com/sgwoods/mmath-renovation/blob/main/docs/project-goal-roadmap.md)

### Steven Woods Public Record Project

- Surface class: Shared-public archive subproject
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Continuity layer, baseline identity, timeline, current profile sources, and one-page CV. Last repo update: May 11, 2026.
- Evidence status: Evidence baseline: 22 approved / 0 deferred / 0 rejected (22 total).
- Likely current work: Person-centric continuity work, baseline identity tightening, profile preservation, and keeping the source-manifest and review-ledger split deliberate.
- Next step: Preserve the remaining URL-backed baseline pages and reconcile the review-ledger-only captures that should become formal source records.
- Quality: One of the best organized archive areas, with clear role boundaries and strong continuity surfaces.
- Coordination note: Use this as the canonical person-centric layer, not a dumping ground for company-depth material.
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
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
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
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
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
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
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
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
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
- Public links: [Project page](https://sgwoods.github.io/public/sei-pittsburgh-research.html), [Open working repository](sei-pittsburgh-research/), [Open work plan](sei-pittsburgh-research/WORK-PLAN.md), [Open recovery audit](sei-pittsburgh-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md)

### Quack.com Archive Project

- Surface class: Shared-public bridge archive
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium-high; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press. Last repo update: May 11, 2026.
- Evidence status: Evidence baseline: 6 approved / 14 deferred / 0 rejected (20 total).
- Likely current work: Preservation and source-completeness work around AOL by Phone, investor outcomes, first-party capture gaps, and stronger preserved press.
- Next step: Keep working campaign-by-campaign, preserving fragile or first-party evidence before widening the editorial surface.
- Quality: A strong archive workflow is in place, but evidence completeness still matters more than polish.
- Coordination note: Treat the bridge record as compatibility, not as a second canonical home.
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
- Public links: [Project page](https://sgwoods.github.io/public/quack-com.html), [Open working repository](quack/), [Open work plan](quack/WORK-PLAN.md), [Open run report](quack/research/run-report.md)

### Kinitos / NeoEdge Networks Archive

- Surface class: Shared-public bridge archive
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium-high; value high; horizon medium
- Current manifest state: Current phase: Active research archive. Current focus: Approved-source preservation floor completed; all twenty-four approved sources now have local copies, and the next pass can shift to deferred-source and corroboration follow-up. Last repo update: October 3, 2026.
- Evidence status: Evidence baseline: 24 approved / 8 deferred / 0 rejected (32 total).
- Likely current work: The preservation branch has been integrated in 993055e after reviewing its derivatives and removing private log filenames from the public lead note. All 24 approved records have existing local artifacts.
- Next step: Resume deferred-source and public-corroboration research in bounded batches; raw private logs remain outside the repository.
- Quality: One of the strongest deep archives in the suite after Steven and Quack, with clear continuity discipline.
- Coordination note: Publication backlog closed; pursue source depth next, rather than repeating preservation setup.
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
- Public links: [Project page](https://sgwoods.github.io/public/kinitos-neoedge.html), [Open working repository](kinitos-neoedge/), [Open work plan](kinitos-neoedge/WORK-PLAN.md), [Open recovery audit](kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md)
