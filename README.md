# Public information created by Steven Woods

This repository is the shared Steven Woods public hub, reporting layer, and coordination surface across multiple projects.

It is not just a standalone project site. Its job is to provide one clear public entry point for:

- cross-project summaries and status
- shared navigation and presentation
- published exports from standalone repos
- shared-public archive and research subprojects that still live inside this repo

Start here in this repo:

- [PROJECT-SUITE-OVERVIEW.md](PROJECT-SUITE-OVERVIEW.md)
- [PUBLIC-REPOSITORY-INVENTORY.md](PUBLIC-REPOSITORY-INVENTORY.md)
- [PROJECT-STATUS-CONTRACT.md](PROJECT-STATUS-CONTRACT.md)
- [PUBLIC-OPERATING-MODEL.md](PUBLIC-OPERATING-MODEL.md)
- [PROJECT-STATE-AND-RECOVERY.md](PROJECT-STATE-AND-RECOVERY.md)
- [START-HERE-NEW-MAC.md](START-HERE-NEW-MAC.md)
- [OLD-MACHINE-CLOSEOUT-2026-05-16.md](OLD-MACHINE-CLOSEOUT-2026-05-16.md)
- [ARCHIVE_PROJECT_INTERFACE.md](ARCHIVE_PROJECT_INTERFACE.md)
- [PUBLIC_STATUS_INTERFACE.md](PUBLIC_STATUS_INTERFACE.md)

Common coordination refresh:

- `python3 tools/refresh_public_coordination.py`
  validates the suite notes and rerenders `PROJECT-SUITE-OVERVIEW.md`,
  `project-suite-overview.html`, `index.html`, and opted-in external project pages
- `python3 tools/refresh_public_coordination.py --check`
  verifies those generated coordination surfaces are still in sync while
  ignoring only the intentionally volatile homepage render timestamps

Current important rule:

- the preferred active shared-public clone is `~/Projects-All/public` on `main`
- the older continuity/recovery lane is optional and should be used only for deliberate reconciliation work
- `/Users/stevenwoods/GitPages/public` is a deprecated historical bridge checkout, not the normal active location
- older iCloud recovery clones remain useful for continuity and reconciliation, but they are not the preferred default active clone model for ongoing shared-public work
# Repository freshness

Run `python3 tools/refresh_public_coordination.py --observe` to check GitHub and
refresh the portfolio. Published source dates and observed development dates are
separate. See [the status contract and Aurora handoff](PROJECT-STATUS-CONTRACT.md).

Star Swarm imports its existing public `build.json`; no agent-specific exporter or
source-repository credentials are needed. Weekly and manual refreshes use the same
path. Archive content fingerprints are deliberately reviewed separately: run
`python3 tools/snapshot_archive_provenance.py --check` to detect changed content,
then review the evidence before recording a new baseline without `--check`.
