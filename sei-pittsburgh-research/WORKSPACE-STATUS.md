# SEI Pittsburgh Workspace Status

Last updated: `2026-05-11`

This note labels the active SEI Pittsburgh workspace, the archive ownership
model, and which path references should be treated as historical only.

## Canonical active workspace

Canonical shared-public repo workspace:

- `/Users/steven/Projects-All/public`

Canonical SEI Pittsburgh deep archive root:

- `/Users/steven/Projects-All/public/sei-pittsburgh-research`

Canonical public summary page:

- `/Users/steven/Projects-All/public/sei-pittsburgh-research.html`

## Archive model

SEI Pittsburgh is currently an era-specific archive inside the shared `public`
repo.

That means:

- `sei-pittsburgh-research/` is the canonical deep archive root for the SEI
  Pittsburgh era
- `sei-pittsburgh-research.html` is the public-facing summary page
- the shared homepage reads `sei-pittsburgh-research/project-manifest.json`
  through the supplemental manifest path, not through a dedicated
  `data/projects/...` card record
- `repo_url` remains unset while the archive stays intentionally monorepo-owned

## Relationship to Steven research

The intended split is:

- `steven-woods-research` owns the canonical person-centric layer
- `sei-pittsburgh-research` owns the era-specific deep archive for the SEI
  Pittsburgh period

Overlap is allowed when context differs.

That means:

- Steven may keep concise person-centric interpretation of SEI-era sources
- SEI Pittsburgh should keep its own era-specific deep interpretation and local
  preservation baseline

## Support scaffold status

Unlike Kinitos, SEI Pittsburgh currently has no separate
`data/sei-pittsburgh...` support scaffold tree.

That is not an error. The continuity and archive structure live directly under
`sei-pittsburgh-research/` plus the top-level public summary page.

## Historical or deprecated path references

The following path family is deprecated for active SEI Pittsburgh work:

- `/Users/stevenwoods/GitPages/public`

If you encounter it in older notes or historical recovery material, treat it as
reference-only.

Steven-layer overlap is still useful as context, but do not treat
`steven-woods-research` as the active SEI Pittsburgh workspace.

## Restart rule

If SEI Pittsburgh is resumed on a new machine:

1. clone or open the canonical `public` repo
2. work from `/Users/steven/Projects-All/public` or an equivalent canonical
   local clone
3. run `bash sei-pittsburgh-research/tools/start-sei-codex.sh`
4. read:
   - `sei-pittsburgh-research/WORK-PLAN.md`
   - `sei-pittsburgh-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
   - `sei-pittsburgh-research/project-manifest.json`
   - `sei-pittsburgh-research/source-manifest.json`
   - `sei-pittsburgh-research/public-handoff.json`
