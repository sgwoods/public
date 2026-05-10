# Steven Woods Research Project State And Recovery Audit

Audit timestamp: `2026-05-10T20:42:54Z`

Repo: `public`

Canonical active local workspace:

- `/Users/steven/Projects-All/public`

Canonical Steven archive root:

- `public/steven-woods-research/`

Canonical public summary page:

- `public/steven-woods-research.html`

Shared homepage wiring:

- supplemental manifest path `steven-woods-research/project-manifest.json`

## Project meaning

`steven-woods-research` is the canonical person-centric archive inside the shared `public` repo.

It owns:

- Steven-level biography and public-facing identity record
- talks, interviews, podcasts, profiles, and awards
- cross-company media interpretation where Steven Woods is the person-level focus
- locally preserved source captures used for person-centric continuity

It does not own:

- long-form company history that belongs in `quack/` or `kinitos-neoedge/`
- top-level site shell and shared navigation that belong to the repo root `public`

## Current archive state

Confirmed machine-readable baseline:

- `22` total source records
- `22` approved
- `0` deferred
- `0` rejected

Confirmed local preservation baseline:

- `18` approved source records currently resolve to checked-in local archive files
- all `18` manifest-referenced local archive files resolve successfully
- `24` files currently live under `public/steven-woods-research/historic/artifacts/archive-html/`
- `6` of those archive files are still tracked only through the review ledger rather than the source manifest:
  - `betakit-google-accelerator-2022.html`
  - `betakit-joins-inovia-2021.html`
  - `computerworld-net-finds-voice-2001.html`
  - `gamedeveloper-neoedge-merges-offspring-2009.html`
  - `newswire-hyperdrive-2012.html`
  - `riddick-show-feed.xml`

Confirmed continuity baseline:

- `project-manifest.json`, `source-manifest.json`, and `public-handoff.json` all parse cleanly
- the project now has a repo-owned continuity layer:
  - `WORK-PLAN.md`
  - `WORKSPACE-STATUS.md`
  - `PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
  - `tools/start-steven-woods-codex.sh`

## Source-of-truth clarification

The Steven archive uses two intentional ledgers:

- `source-manifest.json` is the machine-readable approved-source baseline that drives the collected-content indexes
- `research/media-sources-review.md` is the broader working review ledger for supporting captures, blocked preservation targets, and review-only items not yet promoted into the manifest

This means a checked-in capture may legitimately appear in the review ledger before it becomes a formal `source-manifest.json` entry. That is acceptable as long as the split is explicit and future work reconciles it deliberately.

## Cross-project dependency baseline

Quack intentionally depends on `steven-woods-research` as a supporting person-centric layer.

That dependency is currently visible through:

- Quack links to the Steven review ledger for person-centric source context
- Quack research metadata records some Steven archive copies as shared context
- the ownership contract still leaves company-specific depth and company-critical preservation with Quack itself

This is an intentional hybrid, not a bug, but it should remain documented so future cleanup does not mistake shared person-layer references for accidental coupling.

## Remaining risk

The main remaining risk is not workspace ambiguity. It is preservation and reconciliation completeness:

- four approved baseline/profile sources remain URL-backed:
  - current Inovia team profile
  - current LinkedIn profile
  - bio.link page
  - Wikipedia comparison page
- several checked-in captures still live only in the review ledger rather than the manifest
- overlap with Quack and Kinitos remains intentional but should stay well bounded

## Practical verdict

`steven-woods-research` is now `continuity-safe and restartable` inside the canonical shared-public workspace, but it is not yet `fully preservation-complete and fully reconciled between the review ledger and manifest`.

The next sensible Steven pass is:

- preservation of the remaining URL-backed approved sources where feasible
- deliberate promotion or classification of the review-ledger-only archive files
- continued company/archive boundary discipline, not a broad redesign
