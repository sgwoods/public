# Portfolio verification: October 22, 2026

This is a dated audit, not an assertion that every project releases daily.
The current facts remain in the owning manifests and the latest repository and
activity observations. Fourteen active project summaries are tracked.

## Project status and dates

| Project | Exported source date | Verified state / next action |
| --- | --- | --- |
| AI Briefing | October 22 | v0.1.4-beta / October 22 edition and deep dive; clean public SHA e701aaca matches the public tag, main, manifest, and page. Freshness widget and export-triggered hub refresh work. |
| Star Swarm | October 22 | Clean deployed build 65d1434 matches main and the hub import. Deployment, notification, and hub dispatch have succeeded. |
| Aurora Galactica | June 11 | Hosted production build-info.json still identifies 1.4.1 build 1164 / source 54398ff5. The old source date is correct; October 15 main contains beta work. Review newer work on its owning machine rather than relabeling production. |
| AI Dystopia Quotes | October 3 | Main a0e7cc8 is one commit ahead of the exported 3cbaf56. The source change includes artwork and editorial output. Owning project should deliberately publish its approved batch; a manifest-only change is insufficient. |
| PhD renovation | October 3 | Exported 1.0.0 / f5eea43 still matches default main. A repository push date on another branch does not change this source date. |
| MMath renovation | October 3 | Exported 1.0.0-rc.1 / 408c933 matches main. Public runner link responds. Experiment execution was not tested. |
| Kinitos / NeoEdge | October 3 | Archive content fingerprint matches; preservation merge supplies the one content-changing archive commit in the eight-week window. |
| Quack | May 11 | Fingerprint matches; 3 of 6 approved sources localized at the last content review. Metadata checks do not close preservation gaps. |
| Steven Woods | May 11 | Fingerprint matches; 18 of 22 approved sources localized at the last content review. |
| Google Canada | May 11 | Fingerprint matches; seeded archive baseline remains unchanged. |
| Inovia | May 11 | Fingerprint matches; seeded archive baseline remains unchanged. |
| SEI Pittsburgh | May 11 | Fingerprint matches; seeded archive baseline remains unchanged. |
| Canberra | March 24 | Fingerprint matches; still a scaffold with no formal source baseline at the last content review. |
| Confidential project summary | April 1 | Public summary only; repository observations and activity metrics intentionally excluded. |

All 28 project, source, dashboard, and live-experience links tested returned HTTP
200. Another 43 portfolio/reference link checks also returned 200. HTTP success
is not a full gameplay, email, editorial, or experiment quality test.

## Repaired dashboard defects

- CI rendered missing local source checkouts as zero activity. It now collects
  authenticated GitHub history and publishes a durable snapshot.
- Browser charts made overlapping unauthenticated API requests and used author
  dates while the renderer used commit dates. Both now use the same published
  committer-date history and recorded check times.
- Absolute archive page URLs were being passed as Git paths. They now normalize
  to repository paths, and overlapping results deduplicate by SHA.
- Archive provenance-only edits inflated the eight-week count from eight to one.
  The seven manifest-only edits are now excluded; the Kinitos content merge remains.
- The private summary no longer appears as a misleading zero-valued coding series.
- Cards show source, export, and repository-check dates separately. Rendering or
  loading a page no longer makes old releases look newly exported.
- Obsolete AI Briefing pending/tag-missing notes were replaced with verified
  export evidence. Project-owned release labels and outputs were preserved.

At collection, the eight-week public software totals were Aurora 11, Star Swarm
63, AI Quotes 2, AI Briefing 8, PhD 1, and MMath 1. These are public default-branch
commits, including merges, not a measure of work effort or private operations.
See [the metric definitions](PORTFOLIO-METRICS.md) and current JSON for later counts.

## Repository discovery

All 18 public account repositories have a recorded role in
[PUBLIC-REPOSITORY-INVENTORY.md](PUBLIC-REPOSITORY-INVENTORY.md). AI Briefing's
publication repository is a hosting companion, not a second product. Firstmate
is supporting forked tooling, and seven old examples remain historical.
No additional unregistered standalone public project was found.

Private repository metadata was reviewed only to identify possible private
tracking gaps. Four application candidates need reconciliation with the existing
private summary; their names, links, and contents are not published here. No
private data was added to observation or metric snapshots.

## Owner-approved private-summary follow-up

After this audit, the owner approved public-safe summaries and aggregate activity
for three private projects, while keeping all code and underlying data private:
Windigo Portfolio Portal, Financial Planner, and Woods Financial Dashboard.
Kanban is excluded as a throwaway. The owner confirmed Windigo is the existing
generic rental-portal card, so it is consolidated rather than counted twice.
The portfolio now contains 16 summaries. The paragraph above records the earlier
discovery boundary, not the new publication policy.

Only approved descriptions, default-branch commit dates, fixed-window counts,
and check times were added. No source histories, hashes, messages, deployment
addresses, or financial contents were published. All three private releases are
unverified, not inferred from pushes or activity. Initial fixed-window counts
are 63 / 0 / 0 for Financial Planner / Windigo / Woods Dashboard; they do not
cover other branches or local work. Private reports remain separate from the
13 public-history chart series and require source-owned sanitized exports next.
See [PRIVATE-PROJECT-STATUS.md](PRIVATE-PROJECT-STATUS.md) and the
[one-at-a-time handoff queue](REPOSITORY-HANDOFFS.md).

## Working-activity follow-up

The owner reported daily work not reflected by the public coding charts. The
audit confirmed a scope mismatch, not evidence of inactivity: AI Briefing's eight
public code commits are October 22 exports, while its working history has 391
commits across October 5-22. Aurora's public histories contain 11 default-branch
commits and 14 across all branches since August 31, most recently October 15;
its public docs describe sanitized delivery and preserved private history.
Firstmate was excluded as supporting forked tooling even though the owner has
attributable upstream contributions. Agent-state backups must not be called coding.

The approved remedy keeps the existing public-history charts, names them Public
Repository Commits, and adds the separate Working Activity view. Its first report
is an assisted AI Briefing baseline with all commits unclassified and Toronto-day
aggregates only. No private histories, hashes, messages, or source URLs were added.
Other source reports are awaiting setup, not zero. The first new handoff is the
AI Briefing working exporter; no source repository was edited by the hub work.
