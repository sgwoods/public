# Inovia Workspace Status

Last updated: `2026-05-11`

This note labels the active Inovia workspace, the archive ownership model, and
which path references should be treated as historical only.

## Canonical active workspace

Canonical shared-public repo workspace:

- `/Users/steven/Projects-All/public`

Canonical Inovia deep archive root:

- `/Users/steven/Projects-All/public/inovia-research`

Canonical public summary page:

- `/Users/steven/Projects-All/public/inovia-research.html`

## Archive model

Inovia is currently an era-specific archive inside the shared `public` repo.

That means:

- `inovia-research/` is the canonical deep archive root for the Inovia era
- `inovia-research.html` is the public-facing summary page
- the shared homepage reads `inovia-research/project-manifest.json` through the
  supplemental manifest path, not through a dedicated `data/projects/...` card
  record
- `repo_url` remains unset while the archive stays intentionally monorepo-owned

## Relationship to Steven research

The intended split is:

- `steven-woods-research` owns the canonical person-centric layer
- `inovia-research` owns the era-specific deep archive for the Inovia period

Overlap is allowed when context differs.

That means:

- Steven may keep concise person-centric interpretation of Inovia-era sources
- Inovia should keep its own era-specific deep interpretation and local
  preservation baseline

## Support scaffold status

Unlike Kinitos, Inovia currently has no separate `data/inovia...` support
scaffold tree.

That is not an error. The continuity and archive structure live directly under
`inovia-research/` plus the top-level public summary page.

## Historical or deprecated path references

The following path family is deprecated for active Inovia work:

- `/Users/stevenwoods/GitPages/public`

If you encounter it in older notes or historical recovery material, treat it as
reference-only.

Steven-layer overlap is still useful as context, but do not treat
`steven-woods-research` as the active Inovia workspace.

## Restart rule

If Inovia is resumed on a new machine:

1. clone or open the canonical `public` repo
2. work from `/Users/steven/Projects-All/public` or an equivalent canonical
   local clone
3. run `bash inovia-research/tools/start-inovia-codex.sh`
4. read:
   - `inovia-research/WORK-PLAN.md`
   - `inovia-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
   - `inovia-research/project-manifest.json`
   - `inovia-research/source-manifest.json`
   - `inovia-research/public-handoff.json`
