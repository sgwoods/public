# Project Suite Overview

Updated: `2026-10-22`

Repo-owned portfolio coordination: 16 active summaries, comprising six public software/publication projects, seven archives, and three private projects with approved public metadata only. Windigo is the Costa Rica rental portal under confidential-project, separate from personal financial planning and the Woods Financial Dashboard. Kanban is excluded. Star Swarm is an entirely separate parallel comparison with Aurora, developed using Claude and Firstmate; Firstmate is tooling, not a separate portfolio project or work series. Thirteen public histories feed the public commit/archive charts. Working Activity reports approved daily aggregates; AI Briefing has a 391-commit unclassified assisted baseline, not 391 verified code changes or installed upkeep. Other projects, including Star Swarm and Aurora separately, await source-owned reports. No activity measure changes release labels. See REPOSITORY-HANDOFFS.md for one-at-a-time coordination.

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

- **Protect public surfaces** (4): Keep already-public software, docs, and dashboards trustworthy before expanding scope.
- **Publish local progress** (0): High-value, usually lower-energy work where repo docs or manifests are already ahead of the public surface.
- **Steady advance** (8): Important ongoing work that benefits from regular small batches rather than a one-off push.
- **Seed and clarify** (1): Early-stage areas where a small baseline is more valuable than broad exploration.
- **Private tracking** (3): Keep only a high-level public summary while the underlying work remains private.

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
| [Star Swarm](star-swarm.html) | Standalone repo / hosted build import | Public | Protect public surfaces | Build 65d1434; Playable formation shooter and promptable content system; canonical architecture and roadmap remain in the source repository. |
| [Windigo Portfolio Portal](confidential-project.html) | Private project summary | Private code and data / approved public summary | Private tracking | Private development; release not verified; Reviewable property operations and reconciliation |
| [Financial Planner](financial-planner.html) | Private project summary | Private code and data / approved public summary | Private tracking | Private development; release not verified; Evidence-backed planning and explicit assumptions |
| [Woods Financial Dashboard](woods-financial-dashboard.html) | Private project summary | Private code and data / approved public summary | Private tracking | Private development; release not verified; Source-faithful financial review with clear modeling assumptions |
| [AI Dystopia Quotes](ai-dystopia-quotes.html) | Standalone repo export | Public | Steady advance | Active curation + publishing; Growing the approved canon and widening discovery |
| [AI Briefing](ai-briefing.html) | Standalone repo export | Public code and publication / private operations | Protect public surfaces | v0.1.12-beta · edition 2026-10-23 + deep dive; Beta: aggressive fact checking before email and audio, wider source coverage; podcast listing after four green weeks. |
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
- Current manifest state: Current release: 1.4.1. Current focus: Aurora 1.4.1 is the production quality release for hosted `/production`, promoted from the accepted 1.4.1 beta review with Stage 3 keepers, audio/theme clarity, sign-in repair, and stronger release gates.. Snapshot source date: June 11, 2026.
- Likely current work: Public main at 148f82e (October 15) records a beta dry-run pass and music acceptance hold. The live production build-info.json still identifies Aurora 1.4.1 build 1164, source 54398ff5, from June 11; the older exported production date is accurate.
- Next step: On the active machine, review the full working history and prepare an approved daily aggregate report under WORKING-ACTIVITY-INTERFACE.md after the AI Briefing setup. Keep production source metadata tied to the released build; this does not authorize promotion or change release ownership.
- Quality: This is the strongest product-style public surface in the suite, so small inconsistencies are disproportionately expensive.
- Coordination note: High-value continuity task: preserve and review current local work before starting another gameplay or publication batch.
- Drift note: October 22: source main differs from the exported production commit, while the hosted production build matches that export. Review development on its owning machine; do not manufacture a fresh production date.
- Public links: [Project page](aurora-galactica.html), [Dashboard](https://sgwoods.github.io/Aurora-Galactica/release-dashboard.html), [Live experience](https://sgwoods.github.io/Aurora-Galactica/), [Repository](https://github.com/sgwoods/Codex-Test1), [Open beta build](https://sgwoods.github.io/Aurora-Galactica/beta/), [Open project guide](https://sgwoods.github.io/Aurora-Galactica/project-guide.html), [Open Platinum guide](https://sgwoods.github.io/Aurora-Galactica/platinum-guide.html)

### Star Swarm

- Surface class: Standalone repo / hosted build import
- Visibility: Public
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short
- Current manifest state: Published build: Build 65d1434. Project direction: Playable formation shooter and promptable content system; canonical architecture and roadmap remain in the source repository.. Snapshot source date: October 22, 2026.
- Likely current work: Independent Star Swarm game/content-platform development using Claude and Firstmate, as a parallel comparative attempt entirely separate from Aurora. October 22 deployment, notification, and hub import identify clean build 65d1434; source-owned docs remain authoritative for tested features.
- Next step: Follow the source roadmap: configurable pack/stage editing and playability validation, broader lab previews, and art/audio provenance review. Choose one bounded batch; do not treat roadmap items as shipped.
- Quality: State documentation is checked by tests, and deployment is gated by CI. This audit verified build identity and CI, not exhaustive gameplay quality.
- Coordination note: Firstmate names the development platform used to build Star Swarm, not another project to measure. Attribute Star Swarm's working report to star-swarm, never Firstmate's own repository or agent-state backups. Keep Aurora's code, activity, releases, and roadmap separate. Agent-neutral deployed-build imports and the verified post-deployment notification remain unchanged.
- Drift note: The hub imports clean deployed build.json identities on refresh. Default-branch development is observed separately; detailed feature claims remain in the source architecture.
- Public links: [Project page](star-swarm.html), [Dashboard](https://github.com/sgwoods/star-swarm/actions/workflows/ci.yml), [Live experience](https://sgwoods.github.io/star-swarm/), [Repository](https://github.com/sgwoods/star-swarm), [Canonical architecture](https://github.com/sgwoods/star-swarm/blob/main/docs/ARCHITECTURE.md), [Roadmap](https://github.com/sgwoods/star-swarm/blob/main/docs/ROADMAP.md), [Deployed build identity](https://sgwoods.github.io/star-swarm/build.json)

### Windigo Portfolio Portal

- Surface class: Private project summary
- Visibility: Private code and data / approved public summary
- Priority now: Private tracking
- Time-energy-value: energy medium; value high; horizon ongoing
- Current manifest state: Public status: Private development; release not verified. Scope: Reviewable property operations and reconciliation. Visibility: Private code and data; approved summary only; Metadata checked: October 22, 2026 at 1:49 PM; Metadata freshness: Recorded metadata check; not a live repository check; Report basis: Hub-assisted metadata review; Default-branch commit date: April 6, 2026 at 10:39 AM; Release: Not verified; no release claimed; Reported default-branch activity: 0 commits; August 31, 2026 at 12:00 AM to October 22, 2026 at 1:49 PM; Activity scope: Fixed window; includes merges and all file types; excludes other branches and local edits.
- Likely current work: Owner-facing reconciliation, evidence review, and property operations. These are scope observations, not a verified release or current runtime assessment.
- Next step: On the owning machine, review the active work lane and establish a sanitized status export under PRIVATE-PROJECT-STATUS.md. Verify a real release before naming it publicly.
- Quality: Public boundary is explicit. Application correctness and deployment were not tested in this metadata review.
- Coordination note: Private code and data remain fully private. Only approved descriptions, aggregate commit activity, and verified release metadata may be exported.
- Drift note: User confirmed this is the former Plan private rental portal entry. Keep the confidential-project id and page for link compatibility. Default-branch activity excludes other branches and local work; zero is not inactivity.
- Public links: [Project page](confidential-project.html)

### Financial Planner

- Surface class: Private project summary
- Visibility: Private code and data / approved public summary
- Priority now: Private tracking
- Time-energy-value: energy medium; value high; horizon ongoing
- Current manifest state: Public status: Private development; release not verified. Scope: Evidence-backed planning and explicit assumptions. Visibility: Private code and data; approved summary only; Metadata checked: October 22, 2026 at 1:49 PM; Metadata freshness: Recorded metadata check; not a live repository check; Report basis: Hub-assisted metadata review; Default-branch commit date: September 27, 2026 at 9:37 AM; Release: Not verified; no release claimed; Reported default-branch activity: 63 commits; August 31, 2026 at 12:00 AM to October 22, 2026 at 1:49 PM; Activity scope: Fixed window; includes merges and all file types; excludes other branches and local edits.
- Likely current work: Financial planning with explicit assumptions, source provenance, and review workflows. Current execution and release readiness need owner confirmation.
- Next step: Establish a sanitized owner-approved status export; validate the active runtime, tests, and release policy privately before publishing a release label.
- Quality: High-level documentation describes structured planning and auditability. This hub review did not validate calculations or financial advice.
- Coordination note: Separate from Woods Financial Dashboard and Windigo. Keep all implementation and planning data private.
- Drift note: Initial metadata review reports 63 default-branch commits in the fixed August 31 to October 22 window. Counts are not code-only changes, effort, financial-data freshness, or a release.
- Public links: [Project page](financial-planner.html)

### Woods Financial Dashboard

- Surface class: Private project summary
- Visibility: Private code and data / approved public summary
- Priority now: Private tracking
- Time-energy-value: energy medium; value high; horizon ongoing
- Current manifest state: Public status: Private development; release not verified. Scope: Source-faithful financial review with clear modeling assumptions. Visibility: Private code and data; approved summary only; Metadata checked: October 22, 2026 at 1:49 PM; Metadata freshness: Recorded metadata check; not a live repository check; Report basis: Hub-assisted metadata review; Default-branch commit date: May 4, 2026 at 9:02 AM; Release: Not verified; no release claimed; Reported default-branch activity: 0 commits; August 31, 2026 at 12:00 AM to October 22, 2026 at 1:49 PM; Activity scope: Fixed window; includes merges and all file types; excludes other branches and local edits.
- Likely current work: Local-first source-faithful financial review and reconciliation; the current work lane needs owner confirmation.
- Next step: Review the discrepancy ledger privately, confirm the active runtime, and establish a sanitized owner-approved status export without publishing financial records.
- Quality: This is a distinct personal-finance dashboard, not the rental portal. The hub has not validated its calculations or current data.
- Coordination note: Keep source documents, balances, model details, code, and deployment addresses private. Publish approved aggregates only.
- Drift note: No default-branch commits in the reported fixed window does not establish that no local or branch work occurred. Release remains unverified.
- Public links: [Project page](woods-financial-dashboard.html)

### AI Dystopia Quotes

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy low; value medium-high; horizon short
- Current manifest state: Current stage: Active curation + publishing. Current focus: Growing the approved canon and widening discovery. Snapshot source date: October 3, 2026.
- Evidence status: Approved corpus: 32 entries.
- Likely current work: Public main a0e7cc8 (October 4) adds cached artwork, work links, and editorial updates. The hub still represents the approved October 3 export from 3cbaf56; one source commit is ahead of the public export.
- Next step: Have the owning project review a0e7cc8 and deliberately publish its approved JSON, page, and local artwork assets through its exporter. Do not update the manifest alone to imply those outputs were deployed.
- Quality: The public page already reads cleanly and feels complete enough to trust; the main question is breadth and selection quality.
- Coordination note: Source metadata reconciled. Measure future curation value by approved additions rather than scan count.
- Drift note: October 22 audit confirms a one-commit source/export difference. Public links work; the source owner must decide whether to publish the editorial and artwork batch.
- Public links: [Project page](ai-dystopia-quotes.html), [Repository](https://github.com/sgwoods/sci-fi-ai-dystopian-project), [Open approved JSON](data/ai-dystopia-quotes.approved.json), [Open project manifest](data/projects/ai-dystopia-quotes.json)

### AI Briefing

- Surface class: Standalone repo export
- Visibility: Public code and publication / private operations
- Priority now: Protect public surfaces
- Time-energy-value: energy medium; value high; horizon short
- Current manifest state: Current release: v0.1.12-beta · edition 2026-10-23 + deep dive. Current focus: Beta: aggressive fact checking before email and audio, wider source coverage; podcast listing after four green weeks.. Snapshot source date: October 23, 2026.
- Likely current work: Beta publication, reader feedback, and development/release workflow improvements. The verified hub export is v0.1.4-beta, public source e701aaca, with the October 22 edition and deep dive.
- Next step: Implement the separate approved daily working-activity report using REPOSITORY-HANDOFFS.md. Classify the private working history without exposing it, preserving the existing two-file release export and release facts. Then prioritize editorial accuracy and bounded reader feedback.
- Quality: The 19-field export, public tag, canonical page, links, and freshness panel are verified. This audit did not validate editorial accuracy, email delivery, or audio quality.
- Coordination note: Release exports own data/projects/ai-briefing.json and ai-briefing.html. The new independent working report may own only data/activity/ai-briefing.json. Source-owned upkeep remains to be installed; daily public checks cannot refresh private working activity. Keep operational and subscriber data private.
- Drift note: Initial registration gaps are resolved: the canonical manifest points to news-pipeline, source identity matches v0.1.4-beta, and its page loads current hub observations. Public code commit counts exclude private operations and editions.
- Public links: [Project page](ai-briefing.html), [Live experience](https://sgwoods.github.io/ai-briefing/), [Repository](https://github.com/sgwoods/news-pipeline), [Read AI Briefing](https://sgwoods.github.io/ai-briefing/), [Public code](https://github.com/sgwoods/news-pipeline), [Podcast feed](https://sgwoods.github.io/ai-briefing/podcast.xml), [Hub export handoff](AI-BRIEFING-EXPORT.md)

### PhD renovation project

- Surface class: Standalone repo export
- Visibility: Public
- Priority now: Steady advance
- Time-energy-value: energy medium; value high; horizon medium
- Current manifest state: Current build line: 1.0.0. Current focus: Intake triage. Snapshot source date: October 3, 2026.
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
- Current manifest state: Current release: 1.0.0-rc.1. Current focus: Portability hardening and disciplined post-RC continuation. Snapshot source date: October 3, 2026.
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
- Current manifest state: Current phase: Active research archive. Current focus: Continuity layer, baseline identity, timeline, current profile sources, and one-page CV. Snapshot source date: May 11, 2026.
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
- Current manifest state: Current phase: Seeded era archive. Current focus: Expanded baseline with original-provenance interview coverage and first-party transition context. Snapshot source date: May 11, 2026.
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
- Current manifest state: Current phase: Seeded era archive. Current focus: First-source baseline, continuity-safe restartability, and the next round of current-role and ecosystem capture. Snapshot source date: May 11, 2026.
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
- Current manifest state: Current phase: Scaffolded research project. Current focus: CSIRO references, Knights records, and Australian local context. Snapshot source date: March 24, 2026.
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
- Current manifest state: Current phase: Seeded era archive. Current focus: Expanded baseline with two additional SEI papers and a localized AOL bridge. Snapshot source date: May 11, 2026.
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
- Current manifest state: Current phase: Active research archive. Current focus: Targeted follow-up on AOL by Phone, investor outcomes, first-party capture gaps, and preserved press. Snapshot source date: May 11, 2026.
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
- Current manifest state: Current phase: Active research archive. Current focus: Approved-source preservation floor completed; all twenty-four approved sources now have local copies, and the next pass can shift to deferred-source and corroboration follow-up. Snapshot source date: October 3, 2026.
- Evidence status: Evidence baseline: 24 approved / 8 deferred / 0 rejected (32 total).
- Likely current work: The preservation branch has been integrated in 993055e after reviewing its derivatives and removing private log filenames from the public lead note. All 24 approved records have existing local artifacts.
- Next step: Resume deferred-source and public-corroboration research in bounded batches; raw private logs remain outside the repository.
- Quality: One of the strongest deep archives in the suite after Steven and Quack, with clear continuity discipline.
- Coordination note: Publication backlog closed; pursue source depth next, rather than repeating preservation setup.
- Drift note: October 3 provenance repair records the archive's actual committed content and a fingerprint that excludes its own manifest. Dates retain the source history; this repair does not claim new research or completeness.
- Public links: [Project page](https://sgwoods.github.io/public/kinitos-neoedge.html), [Open working repository](kinitos-neoedge/), [Open work plan](kinitos-neoedge/WORK-PLAN.md), [Open recovery audit](kinitos-neoedge/PROJECT-STATE-AND-RECOVERY-2026-05-03.md)
