# Company research workflow snapshot

This tracked file is the checked-in recovery copy of the shared Quack and Kinitos archive workflow.

It exists so a fresh checkout of the `public` repo can continue company-archive work even if local Codex skills or machine-specific helper files are unavailable.

## Purpose

- keep company archives deep and company-centric
- treat `public` as the Steven-centric downstream consumer
- research in batches, not just one artifact at a time
- keep source IDs, manifests, public handoff, and project pages in sync
- share one repeatable workflow across Quack and Kinitos

## Canonical outputs

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

## Internal research outputs

- `research/source-leads.json`
- `research/timeline.json`
- `research/entities.json`
- `research/topic-briefs/`
- `research/run-report.md`
- named campaign notes when needed

## Core workflow

1. Read `ARCHIVE_PROJECT_INTERFACE.md` and current manifests before changing structure or publishing outputs.
2. Discover targeted source leads by company history, partners, investors, regional context, patents, key people, and retrospectives.
3. Fetch metadata for all leads and preserve local copies for strong, fragile, or company-central sources.
4. Analyze title, date, provenance, entity mentions, source type, and likely archive lane.
5. Classify each source as `approved`, `deferred`, or `rejected`.
6. Update manifests, timeline, entities, topic briefs, run report, and the project summary page together when the archive materially changes.

## Shared rules

- Keep detailed company-specific interpretation in the company archive.
- Push only short Steven-relevant summaries upward through `public-handoff.json`.
- Treat LinkedIn and Wikipedia as discovery pointers, not final authority by themselves.
- Keep date uncertainty explicit.
- Prefer doing substantive local archive work only from an iCloud-backed workspace when that is the active operating policy.
- Treat `urls.archive_local` as archive-project-root-relative, and verify those paths during recovery audits instead of assuming a repo-root base.
- Use named campaigns for multi-source follow-up threads such as investor trail, site-capture gaps, product-transition evidence, or exit/IP evidence.
- Treat archived first-party site captures as a source family of their own.
- For company endgames, triangulate press, legal/ownership records, and first-party or archived-site evidence where possible.

## Recovery note

This file is the checked-in continuity surface. If a local Codex skill exists outside the repo, treat it as optional acceleration only. The repo itself must remain sufficient to resume work on a new machine.

When an iCloud-backed local-workspace rule is in effect, the practical sequence is:

1. commit and push any important continuity work from the current checkout
2. refresh or recreate the repo inside the iCloud-backed folder
3. validate regeneration there before treating that checkout as the active local workspace
