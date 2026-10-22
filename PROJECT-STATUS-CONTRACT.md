# Project status and repository freshness

Published snapshots and observed repository activity are independent. A newer
commit does not prove a new production release. A successful render does not
prove a recent export.

## Export contract (additive schema 1.0)

- `source_commit`: full Git commit represented by this export.
- `source_commit_at`: that commit's committer timestamp, in ISO 8601.
- `source_ref`: checkout ref, or `HEAD` for a detached checkout.
- `source_dirty`: whether tracked or untracked changes exist when exported.
- `status_generated_at`: actual export-generation time.
- `repo_pushed_at`: compatibility alias for `source_commit_at`, not a GitHub push time.
- Existing release/status labels remain project-owned. Do not update them from an activity check.

The four `source_*` fields above are the approved additive extension to the 15
base fields in PUBLIC_STATUS_INTERFACE.md; new exporting projects publish all 19.

For production exports, source fields identify the released commit, not an
unrelated newer development commit. Avoid exporting dirty source as an approved
release. Record it truthfully if a preview export is needed.

## Observer

Run `python3 tools/refresh_public_coordination.py --observe` with authenticated
`gh`. This writes `data/shared/repository-observations.json` and renders the hub.
Use `python3 tools/refresh_public_coordination.py --check` for a no-write check.

The observer checks public default branches. Shared archives use path-scoped
history, so another project's commit does not imply activity in that archive.
Private projects are excluded. Each row records its successful check time;
failed checks preserve previous observations and return nonzero. Dates without
an exported commit identity cannot establish equality. A different commit is a
review signal, not proof that a release needs promotion. Historical branches,
local edits, runtime health, and hosted release lanes require a separate review.

The GitHub workflow checks daily at 13:17 UTC, on relevant hub changes, and on
workflow dispatch. It updates the coordination pages and opted-in external project
pages. An eight-day threshold marks observations stale. Hub-generated project
pages show the last successful check and its comparison with the published build;
failed checks retain the previous observation and visibly report the failure.
The workflow explicitly requests a Pages rebuild after publishing, using the
[GitHub Pages build API](https://docs.github.com/en/rest/pages/pages#request-a-github-pages-build),
so scheduled bot commits also reach the branch-published website.

## Aurora handoff prompt (other machine)

Update the Aurora public exporter and verifier to follow the additive contract at
https://github.com/sgwoods/public/blob/main/PROJECT-STATUS-CONTRACT.md.
Start by reading the repo instructions, current Git state, and release authority.
Preserve existing local work. Keep production source metadata tied to the actual
production build; do not substitute newer Guardians development for a release.
Add source_commit_at, source_ref, and truthful source_dirty metadata, retain
repo_pushed_at as a compatibility alias, and keep status_generated_at as export
time. Never fall back to today's date when the source commit cannot be resolved:
fail clearly instead. Update verify-public-sync and run the supported validation
and public export workflow. Commit and push the validated changes, report the
source commit and actual hosted release, and identify any unfinished local work.
The public hub now independently observes default-branch activity, so no code
here needs to manufacture a fresh production date.

## October 3 implementation record

- MMath exporter: `sgwoods/mmath-renovation` commit `408c933`; clean-source export
  includes the hosted runner URL (HTTP 200 verified, experiment execution not tested).
- PhD exporter: `sgwoods/phd-renovation` commit `f5eea43`; use
  `PHD_PUBLIC_SITE_DIR=/path/to/public python3 tools/generate-release-dashboard.py --status-only`
  for metadata-only publication. Stable thesis artifact dates are unchanged.
- Quotes exporter: `sgwoods/sci-fi-ai-dystopian-project` commit `3cbaf56`; existing
  approved outputs were republished without corpus changes.
- Kinitos: merge `993055e` integrates the six preservation commits. All 24 approved
  source records resolve to local artifacts. Private log filenames were removed
  from the public corroboration note; raw logs remain outside this repo.
- Source fixes used temporary clean clones; existing working checkouts were not
  changed. Pull the published main-branch fixes before future work on those machines.
- Aurora exporter migration remains the other-machine task above. Three older PhD
  migration/reporting branch commits remain a separate documentation review.
- Older archive manifests lack source commit identity. The observer reports this
  explicitly until their content has been reviewed and baselined. The seven
  existing archive manifests were baselined in the follow-up below.

## Shared archive provenance

Run `python3 tools/snapshot_archive_provenance.py` after reviewing and committing
archive changes, then run the coordination refresh and commit the generated metadata.
`--check` verifies current committed content against the recorded fingerprints.
The script refuses uncommitted archive content and is idempotent.

Each archive records its last content commit, that commit's real date, and
`source_content_sha256`: SHA-256 over sorted Git entries (path, mode, type, blob
identity) below its directory, excluding only its own `project-manifest.json`.
The observer recomputes the same fingerprint from GitHub. This avoids a circular
"manifest updates its own source commit" cycle. Changes to evidence, source
ledgers, plans, or archive pages are detected; metadata-only updates are ignored.
Quack and Kinitos compatibility manifests receive the same provenance metadata.

All seven archive provenance gaps are repaired. This is not an evidence-completeness
claim: Canberra has no source records; Quack has 3 of 6 approved sources localized;
Steven Woods has 18 of 22. All paths declared as localized existed at review time.
Google Canada (9), Inovia (3), SEI (12), and Kinitos (24) have local artifacts for
all currently approved records. Counts describe the October 3 review.

## Star Swarm: Claude / Firstmate handoff

No new exporter or cross-repository credentials are needed. The hub reads
`https://sgwoods.github.io/star-swarm/build.json`, which the existing source CI
already deploys with the tested game. Opt-in is `status_sync: github-pages-build-v1`
in the hub manifest. The importer requires release mode, a clean tree, and a
commit resolvable in the public source repository. Invalid or unreachable builds
retain the last snapshot and fail the refresh visibly. A new deployment updates
the source fields and build label; it does not invent a semantic release version.

Agent handoff prompt:

> Maintain Star Swarm's existing build.json contract when publishing: commit,
> dirty, mode, and builtAt must identify the bundle actually deployed. Keep
> ARCHITECTURE.md as the tested state document and ROADMAP.md as planned work.
> The public portfolio now consumes build.json, so no public-repo token or
> second export is required. After a successful deployment, run
> `python3 tools/refresh_public_coordination.py --observe` in sgwoods/public,
> or dispatch its Render Public Index workflow; the daily run also picks it up.
> If the project's purpose, URLs, or priorities change, update the hub's
> data/projects/star-swarm.json and data/shared/project-suite-overview.json.
> Do not treat a main-branch commit as deployed until the build identity confirms it.

The hub generates star-swarm.html from that manifest. Feature descriptions link
to the canonical source docs instead of maintaining another feature checklist.
Other projects can opt in only if they publish the same release build identity
and use the same documented architecture/roadmap page convention.

## Notifications after publication

Projects ask the hub to run `render-public-index.yml` on `main` through
`workflow_dispatch`. The request means "look now". The hub imports or reads the
published snapshot, observes public repository activity separately, regenerates
its pages, commits the results, and explicitly requests a Pages build. A successful
notification or render does not prove a new export. Release and status labels
remain controlled by the project's published artifact, never by an activity check.

- **Observed projects:** the released artifact follows a successful deployment of
  the default branch. Notify only after deployment succeeds and the live build
  identity resolves to the commit that was deployed. Star Swarm is the reference:
  [PR 51](https://github.com/sgwoods/star-swarm/pull/51) adds a separate notification
  job after deployment. The hub reads the served `build.json`; a newer branch
  commit alone does not replace that identity.
- **Exporting projects:** MMath, the PhD work, and the quotes project publish
  explicit exports whose released commit can differ from the default branch.
  Notify only AFTER the exporter has published its approved outputs and canonical
  manifest to the hub. A branch push is not the notification trigger. Resolve the
  released source commit and its real date before publishing; fail clearly if
  resolution fails, without substituting today's date. Observation differences
  are review signals and must not rewrite exported release labels or source fields.

AI Briefing (`ai-briefing`, public code `sgwoods/news-pipeline`) uses this exporting
pattern. Its publisher owns only `data/projects/ai-briefing.json` and
`ai-briefing.html`. Registration can observe public development before the first
manifest, explicitly labeled `awaiting_export` with no released source identity.
Once the active manifest arrives, the observer compares its `source_commit` with
the public default branch. The hub never imports its private operational state
or promotes `main` into a released commit. See [AI-BRIEFING-EXPORT.md](AI-BRIEFING-EXPORT.md).

A push of `data/projects/*.json` to hub `main` triggers this workflow; daily
13:17 UTC runs are a fallback. A push of `ai-briefing.html` also triggers it.
Use a fine-grained PAT or GitHub App token with Contents read/write on
`sgwoods/public` for the two-file export. Such a push triggers the workflow
normally. GitHub does not scope Contents write to individual paths, so the
exporter must enforce the two-file allowlist. The source repository's automatic
`GITHUB_TOKEN` cannot push into this different repository. Actions write is only
needed for a separate workflow dispatch; it is not required for a normal PAT
push. A hub-side `GITHUB_TOKEN` bot push does not trigger another push workflow,
so explicitly dispatch or rely on the scheduled fallback in that case.

Exporter-owned pages may use `assets/project-freshness.js` and a
`data-project-freshness` panel containing the page's exact exported source commit
and dirty flag. The script reads the hub's current observations, evaluates their
age at page load, and reports a match only against the same snapshot. It leaves
release labels and page content under the exporter's control. Failed requests
show an unavailable comparison; a successful render alone never establishes an
export or a fresh observation.

For an optional cross-repository notification, Star Swarm uses
`PUBLIC_HUB_DISPATCH_TOKEN`, a fine-grained token restricted to `sgwoods/public`
with Actions read/write (and GitHub's automatic Metadata read permission). It can
dispatch the hub workflow without writing hub contents. The project's own
`GITHUB_TOKEN` cannot dispatch another repository's workflow. Keep the token in
the source project's secret store. Private projects remain excluded from public
imports and observations, including after a notification.

The reference job warns and succeeds if the secret is absent, leaving the daily
hub refresh as the fallback. With a configured secret, failure to serve the
expected commit or a refused dispatch fails the separate notification job while
preserving the successful deployment.

Verified October 12, 2026: the notification job ran after deployment in
[the October 11 run](https://github.com/sgwoods/star-swarm/actions/runs/38149588310/job/114501956725)
and [the October 12 run](https://github.com/sgwoods/star-swarm/actions/runs/38290391794/job/114952463867).
Both warned that `PUBLIC_HUB_DISPATCH_TOKEN` was missing. The deployment gate and
missing-secret fallback have therefore run; a successful authenticated dispatch
has not yet been demonstrated. The Star Swarm owner must configure that secret
and verify the next notification produces a corresponding hub run. No source
project was modified by this hub change.

`render_external_project.py` currently generates Star Swarm's hub page. It adds
freshness to every page generated through that renderer. MMath, PhD, quotes, and
Aurora pages are published by their source exporters; adding the same panel to
those pages requires their owners to adopt it in their export templates. Their
observations remain available on the hub's Repository Activity section.
