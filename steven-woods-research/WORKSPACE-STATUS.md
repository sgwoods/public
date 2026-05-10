# Steven Woods Research Workspace Status

Last updated: `2026-05-10`

This note labels the active Steven archive workspace, the staged shared-layer model, and which path references should be treated as historical only.

## Canonical active workspace

Canonical shared-public repo workspace:

- `/Users/steven/Projects-All/public`

Canonical Steven archive root:

- `/Users/steven/Projects-All/public/steven-woods-research`

Canonical public summary page:

- `/Users/steven/Projects-All/public/steven-woods-research.html`

Canonical shared homepage wiring:

- supplemental manifest path `steven-woods-research/project-manifest.json`

## Archive model

`steven-woods-research` is the canonical shared person-centric layer inside the `public` repo.

That means:

- `steven-woods-research/` owns person-level biography, public appearances, profiles, awards, and cross-company interpretation
- `steven-woods-research.html` is the public-facing summary page
- `project-manifest.json`, `source-manifest.json`, and `public-handoff.json` are the coordination exports for this archive
- there is intentionally no `data/projects/steven-woods-research.json`; the shared homepage loads this project through the supplemental manifest path

## Support scaffold status

Unlike Kinitos, this project currently has no separate `data/steven-woods-research/...` support scaffold.

That is not an error by itself. The continuity and archive structure live directly under `steven-woods-research/` plus the top-level public page and shared homepage wiring.

## Source-of-truth split

Use these files intentionally:

- `source-manifest.json` = machine-readable approved-source baseline
- `research/media-sources-review.md` = broader working review ledger, including supporting captures, blocked preservation targets, and review-only items not yet promoted into the manifest

## Cross-project dependency role

This project intentionally acts as the shared person-centric layer for the wider archive program.

That means:

- Quack may reference this archive for Steven-specific review context or shared person-level captures
- company archives remain the canonical home for company-specific interpretation and company-critical preserved copies
- cross-project links into `steven-woods-research/` are expected when the purpose is person-centric context, but they should not become a substitute for company-owned preservation

## Historical or deprecated path references

The following path family is deprecated for active Steven archive work:

- `/Users/stevenwoods/GitPages/public`

If you encounter it in older notes or metadata, treat it as historical reference only.

## Restart rule

If the Steven archive is resumed on a new machine:

1. clone or open the canonical `public` repo
2. work from `/Users/steven/Projects-All/public` or an equivalent canonical local clone
3. run `bash steven-woods-research/tools/start-steven-woods-codex.sh`
4. read:
   - `steven-woods-research/WORK-PLAN.md`
   - `steven-woods-research/PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
   - `steven-woods-research/project-manifest.json`
   - `steven-woods-research/source-manifest.json`
   - `steven-woods-research/public-handoff.json`
   - `steven-woods-research/research/media-sources-review.md`
