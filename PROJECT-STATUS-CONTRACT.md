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

The GitHub workflow checks weekly and on relevant changes. It updates all three
generated coordination pages. An eight-day threshold marks observations stale.

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
  explicitly; add provenance on their next deliberate content export rather than
  relabeling old content as newly researched.
