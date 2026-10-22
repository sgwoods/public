# Portfolio dates and activity metrics

The homepage tracks 16 project summaries after the October 22 follow-up: six
public software/publication projects, seven shared archive projects, and three
private summaries. Windigo is the former generic confidential entry, not another
project. Kanban is excluded. Public activity charts cover 13 source/archive
projects. Private cards separately show approved fixed-window aggregate reports,
not a combined or rolling chart. These are different counts for different purposes.

## Two Activity Views

**Public Repository Commits** is the renamed existing chart, not a new collection
policy: it still counts public default-branch history. It is not a complete record
of daily coding. AI Briefing's allowlisted code export and Aurora's sanitized
delivery make that distinction important. Star Swarm's own development is tracked
separately from Aurora; Firstmate is its development platform, not another series.

**Working Activity** shows separately approved daily aggregates from the actual
working history. Development, publication, automation, and unclassified commits
are distinct categories. Missing reports are N/A, not zero. Never add these counts
to the public charts, since the same work can occur in both. Each row has its own
window and check time; uncommitted edits and hours are not counted.

The initial AI Briefing baseline contains 391 unclassified commits across October
5-22, using Toronto dates. It is not 391 verified code changes or an installed
automatic exporter. Aurora, Star Swarm, and other software projects
await source-owned reports. Private projects' earlier fixed-window metadata cards
cannot be converted into invented daily histories. Firstmate has no separate
portfolio or working-report entry. Its repository and agent-state backups are
not proxies for Star Swarm's coding activity.

See [WORKING-ACTIVITY-INTERFACE.md](WORKING-ACTIVITY-INTERFACE.md) for the exact
payload, privacy boundary, classification policy, and source-export workflow.

## Dates

- **Snapshot source date** is the real source commit date represented by the
  approved export, not a general last-worked date. Older released artifacts can
  remain correct. A legacy summary without commit identity says **Reported snapshot
  date** instead. Private summaries have no released snapshot date until verified;
  their metadata-check and default-branch commit dates are labeled separately.
- **Status exported** is when the owning project generated its public record.
- **Repository checked** is the last successful observation of the public default
  branch or archive scope. Its age does not change a released version.
- **Homepage rendered** records presentation generation, not a new release or export.
- **History checked** records collection of the history used by the activity chart.
  Reloading a page does not reset it to today's time.

The newest source date at the top of the page belongs to one snapshot. It does
not assert that every project was updated that day. Times use America/Toronto.

## Counts

`python3 tools/refresh_public_coordination.py --observe` collects public GitHub
history with the existing authenticated `gh` token, including all result pages.
Each repository's default-branch SHA is pinned during collection. The result is
saved in [repository-activity.json](data/shared/repository-activity.json), then
rendered into the HTML so charts work before JavaScript or without browser API
access. Browser refreshes read that same published file instead of making dozens
of unauthenticated GitHub requests.

- Dates are commit **committer** timestamps, not author timestamps. Old authored
  work committed recently is counted consistently by the collector and browser.
- Daily buckets cover seven local calendar days; weekly buckets cover eight
  Monday-started local weeks. Boundaries are start-inclusive/end-exclusive and
  respect daylight saving. The current period is partial through the recorded check.
- Software counts include reachable public default-branch commits, including
  merges. AI Briefing counts `news-pipeline` public code commits, not private
  operational commits, editions, podcasts, or emails.
- Archive counts include commits changing their directory or public project
  page. Their own `project-manifest.json` is excluded. An edit only to that
  metadata does not represent archive-content activity. Overlapping paths are
  deduplicated by SHA within one archive. A shared commit can count for multiple
  archives when it changes content in each.
- Hosting mirrors, companion runners, support forks, branches other than the
  default, private repositories, and local uncommitted work are outside these public series.
- A completed successful history request with no commits is zero. Missing,
  failed, incompatible, or insufficient-window history is **Unavailable/N/A**.
  Partial series are never presented as a complete total. Prior evidence is
  retained on failure, and the refresh reports failure visibly.

Commit counts describe public repository history. They do not measure time,
effort, editorial quality, research progress, output volume, or release readiness.
For current release facts use the owning manifest and source artifact; for
priority decisions use [the portfolio overview](PROJECT-SUITE-OVERVIEW.md).

Private summaries follow [PRIVATE-PROJECT-STATUS.md](PRIVATE-PROJECT-STATUS.md).
Their initial owner-authorized review publishes aggregate counts and dates only,
never private source histories. A fixed-window zero does not rule out local or
other-branch work. No private release was verified. Source-owned sanitized exports
are the next setup step; daily public checks do not refresh these private reports.

## Checks

```sh
python3 tools/test_repository_freshness.py
python3 tools/test_activity.py
python3 tools/test_working_activity.py
python3 tools/test_private_status.py
node --test tools/test_project_freshness.cjs tools/test_public_index.cjs
python3 tools/refresh_public_coordination.py --check
```

Daily and publication-triggered runs use the same collector. They explicitly
request a Pages build after committing observations and rendered output.
