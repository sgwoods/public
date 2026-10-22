# Private projects: public-safe status interface

Approved October 22, 2026: include three private projects in the portfolio, while
keeping **all code and underlying data private**. Kanban is explicitly excluded.
Windigo replaces the old generic rental-portal description; it is not a fourth
private project. Its existing identifier and URL stay stable.

| Project | Manifest owned by its exporter | Hub-rendered page |
| --- | --- | --- |
| Windigo Portfolio Portal | `data/projects/confidential-project.json` | `confidential-project.html` |
| Financial Planner | `data/projects/financial-planner.json` | `financial-planner.html` |
| Woods Financial Dashboard | `data/projects/woods-financial-dashboard.json` | `woods-financial-dashboard.html` |

These are three distinct applications. Do not consolidate their implementation,
financial records, release lanes, or priorities. Only Windigo is the old generic
confidential entry, as confirmed by the owner.

## What may be published

Owner-approved names, short non-confidential descriptions, high-level focus,
status, verified release version/date, metadata-check time, last default-branch
committer date, and fixed-window aggregate default-branch commit counts.
Counts include merges and all file types: they are not code-only edit counts,
financial-data freshness, hours, effort, quality, or releases. Other branches and
local edits are excluded. A zero in this series does not mean no work occurred.

Do not export code, diffs, data, balances, client/property details, filenames,
commit hashes/messages/authors, private repository or deployment URLs, credentials,
logs, source-document metadata, or underlying per-commit histories. A field
allowlist is a structural guard, not automatic confidential-text detection;
review every public string and the staged diff before the first export or a
change in scope. Previously published data can remain in Git history.

## Manifest shape

Use the existing 15 base fields, **plus exactly** `status_sync` and
`private_metadata`. `schema_version` stays `1.0`; `status_sync` is
`private-summary-v1`. Copy the project's current manifest as the template.

- `repo_url`, `dashboard_url`, `experience_url`, and `repo_pushed_at` must be null.
  A metadata check is not a released snapshot. Do not add public-source provenance
  fields such as `source_commit` to this private-summary interface.
- `status_generated_at` is the actual approved-summary export time.
- `private_metadata.checked_at` records the actual successful private review.
  The hub renderer never advances it. Reports over eight days old need review.
- `report_basis` is `Owner-approved export`, or `Hub-assisted metadata review`
  for the initial owner-authorized audit. Do not relabel the initial audit as an
  automated source-owned export.
- `last_default_branch_commit_at` is the real committer timestamp, or null when
  unavailable. Do not substitute repository `pushed_at` or today's date.
- `release_version` and `released_at` are both null until the source owner verifies
  an actual release. A package version, tag alone, push, or successful test does
  not establish deployment. A private application need not create GitHub Releases.
- `activity` is null if not measured. Otherwise it has exactly `window_start`,
  `window_end` (timezone-aware timestamps), and a nonnegative integer
  `commit_count`. Count unique commits reachable from a pinned default-branch SHA
  using committer timestamps, start-inclusive/end-exclusive. Keep hashes only in
  the private calculation. The window end must not exceed the check time.

The initial review used August 31, 2026 at midnight Toronto through the October 22
check. It found 63 commits for Financial Planner and zero for the other two in
that **default-branch** window. These remain fixed-window reports, not rolling
charts. No release was verified for any of the three.

## Export and notification

Implement the exporter **in the owning private project**, after its owner reviews
the public payload. Export only that project's manifest to `sgwoods/public`.
The hub renders its summary page; the source exporter must not write the page,
homepage, suite judgments, other manifests, or observation datasets.

Run `python3 tools/refresh_public_coordination.py --check` in a matching hub checkout
to validate the payload after regenerating locally. Validation is also run by CI.
Use an authenticated, narrowly scoped token that can push contents to the hub
(or a reviewed PR); the private repository's normal `GITHUB_TOKEN` does not gain
cross-repository access automatically. Store secrets in the source environment,
never a manifest, public workflow, browser bundle, or Git history. GitHub tokens
do not enforce per-file access, so the exporter needs an explicit path allowlist.

Authenticated manifest pushes trigger the hub workflow. It regenerates pages
and explicitly requests the Pages build. If the publication mechanism does not
trigger push workflows, send the supported hub notification **after** the approved
export lands. Never notify a private release from a branch push alone.

Daily public observations cannot refresh private reports. **Do not grant private
repository access to the public hub workflow**, poll private APIs from visitors'
browsers, or place private commit records in the public activity dataset. On a
failed source check, retain the last good report without advancing its check time;
report failure privately. Disable export until confidentiality can be verified.
