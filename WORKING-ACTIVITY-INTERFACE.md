# Working activity: privacy-safe daily reports

The owner approved this second view on October 22, 2026. Keep it separate from
public default-branch history and project-owned released status. It answers
"where is committed working activity occurring?", not "what has shipped?" or
"how many hours did this take?". The homepage links it at `#working-activity`.

## Why a separate view

- AI Briefing exports an allowlisted public code mirror. Its eight public commits
  were all dated October 22 at this audit, while its private working history had
  391 commits across October 5-22. Publication chronology is not working chronology.
- Aurora's currently reachable public histories contain 11 default-branch commits
  and 14 unique commits across all branches since August 31, most recently October
  15. Public documents describe sanitized delivery and preserved private history.
  The hub cannot infer daily development from these snapshots or recover private
  working history. Ask the active machine; do not change release labels.
- Star Swarm is the independent game/content platform being developed with Claude
  and Firstmate, as a parallel comparative attempt entirely separate from Aurora.
  Firstmate is the development platform, not a separate work project in this suite.
  Do not substitute its repository or private agent-state backups for Star Swarm work.

The initial AI Briefing report is a **hub-assisted baseline**, not an installed
source exporter. All 391 commits are **unclassified**, not presumed coding.
Its daily dates use America/Toronto; for example early-UTC October 15 work can
belong to October 14 locally. Counts were collected from a pinned head with all
pages read; only date aggregates were retained. The public workflow must never
query the private working repository to refresh this baseline.

## Ownership and privacy

Each project may publish **only** `data/activity/<project_id>.json`. These files
are separate from `data/projects/` release manifests. The hub validates them and
renders the view. Source code, diffs, commit hashes/messages/authors, private repo
or deployment URLs, branch/worktree names, filenames, logs, financial information,
subscriber/editorial data, and credentials must never cross this interface.

The schema deliberately has no free-text source metadata. The field allowlist is
a structural guard, not a substitute for owner approval of the first payload,
exporter, or later scope changes. Review staged files and raw JSON, not just its
rendered appearance. Never store raw private inputs in the public checkout, its
Git history, CI artifacts/logs, or an intermediate committed dataset.

Rental-property operations and personal finance remain separate:

| Project id | Meaning |
| --- | --- |
| `confidential-project` | Windigo's Costa Rica rental-property portal only |
| `financial-planner` | Personal financial planning |
| `woods-financial-dashboard` | Personal portfolio dashboard and reconciliation |

Star Swarm reports under `star-swarm`; Aurora reports under `aurora-galactica`.
They have independent code, history, releases, and roadmaps. `firstmate` is not a
registered report id. Registered software projects can add reports under their
existing ids. Archives retain their public
content-history view. Kanban remains excluded. New ids require hub review.

## Exact schema, version 1.0

Use the checked-in `data/activity/ai-briefing.json` as a structural example, not as
source data to copy forward. Top-level fields are exactly:

- `schema_version`: `1.0`.
- `project_id`: an existing software project id, never a development tool's id.
- `generated_at`: actual prepared/exported report time with timezone.
- `checked_at`: actual successful source measurement time, no later than generation.
  Rendering, page loads, failed measurements, and public observations never advance it.
- `timezone`: exactly `America/Toronto`.
- `scope`: `working-default-branch` or `working-all-branches` for the project itself.
- `report_basis`: `owner-approved-export`; the initial assisted audit uses
  `hub-assisted-baseline` and is explicitly not proof of automatic upkeep.
- `uncommitted_work`: `present`, `absent`, or `not_checked`. This is a safe signal,
  not a count of edits, files, or time. Commit totals exclude uncommitted work.
- `window_start`, `window_end`: local `YYYY-MM-DD`, start inclusive/end exclusive,
  covering 1-56 dates. The end can be tomorrow's local date when today is partial
  through `checked_at`; it cannot include an unobserved future day.
- `days`: one row for every date in that window, ascending, unique, no gaps.
  Each row has exactly `date`, `development`, `publication`, `automation`,
  `unclassified`. Counts are nonnegative integers, not estimates or booleans.

Every measured unique commit belongs to **one** category:

- `development`: deliberately classified implementation, tests, or technical
  documentation changes. Mixed changes count here only when this is supported
  by the owner's documented classification policy.
- `publication`: edition/site/email/audio or release-output publication without
  a development change. It does not prove delivery or a new release version.
- `automation`: automated backup, housekeeping, or agent-state snapshots without
  a classified development/publication change.
- `unclassified`: everything not reliably assigned. Do not infer classification
  from a bot author, a commit title, or a filename pattern alone.

Keep the classification policy and raw audit trail **in the private/source repo**.
Use an explicit override or leave ambiguous commits unclassified. Zero classified
development with unclassified work does **not** mean no coding occurred.

Pin source heads before collection. Deduplicate commits across branches/worktrees,
then bucket by actual committer time in Toronto. Source-private SHAs may be used
internally but must not be exported. For Star Swarm, measure the actual Star Swarm
working history, not Firstmate's upstream code, its tooling fork, or unrelated
agent-state backups. Never combine Star Swarm and Aurora histories for this view.

A missing report is **N/A**, not zero. Zero rows are legitimate only after a
complete successful measurement. Report windows can differ, so do not sum projects
as though coverage were identical. Reports over eight days old are flagged. Never
sum this view with public history: the same work can be represented in both.

## Export and upkeep

Implement on the owning machine, not inside the public hub. First validate and
preview a sanitized payload in a current hub clone:

```sh
python3 tools/working_activity.py --check-file /path/to/prepared-safe-report.json
python3 tools/test_working_activity.py
```

Use a rolling 28-day window initially, or an honest shorter window when coverage
starts later. After reviewing the exact payload, update only the project's own
`data/activity/<id>.json`. Preserve unrelated dirty work and fail clearly if the
source measurement, classification, or privacy review cannot be completed. On
failure retain the last good public report and its check time; do not fabricate
zeros or silently narrow the scope. The hub never acquires private-source access.

Publish at a daily checkpoint or a deliberate work checkpoint, not on every
autobackup. Only push a changed report; avoid unnecessary full-hub refresh runs.
Working reports do **not** wait for a release: their purpose is independent of
release/export cadence. Updating them does not authorize a release, promote a
branch, or modify the project's released-status manifest.

Use the source project's approved, narrowly scoped cross-repository token. Its
ordinary `GITHUB_TOKEN` has no automatic write access to the hub. GitHub tokens
cannot enforce per-file scope, so the exporter must enforce its own path allowlist.
Keep secrets only in the source environment. Do not give the public hub token
access to private repositories or embed a token in browser code.

An authenticated push to `data/activity/*.json` triggers `render-public-index.yml`.
The hub validates the complete set, regenerates the index, and explicitly requests
a Pages build. If the chosen mechanism suppresses push workflows, use the existing
supported hub notification after the approved report lands. Daily public refreshes
keep presentation current but cannot independently refresh private source reports.

First source setup: AI Briefing, using the prompt in `REPOSITORY-HANDOFFS.md`.
Star Swarm and Aurora separately remain awaiting source reports, not zero-activity projects.
