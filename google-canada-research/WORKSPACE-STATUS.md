# Google Canada Workspace Status

Last updated: `2026-05-11`

This note labels the active Google Canada workspace, the archive ownership
model, and which path references should be treated as historical only.

## Canonical active workspace

Canonical shared-public repo workspace:

- `/Users/steven/Projects-All/public`

Canonical Google Canada deep archive root:

- `/Users/steven/Projects-All/public/google-canada-research`

Canonical public summary page:

- `/Users/steven/Projects-All/public/google-canada-research.html`

## Archive model

Google Canada is currently an era-specific archive inside the shared `public`
repo.

That means:

- `google-canada-research/` is the canonical deep archive root for the Google
  Canada era
- `google-canada-research.html` is the public-facing summary page
- the shared homepage reads `google-canada-research/project-manifest.json`
  through the supplemental manifest path, not through a dedicated
  `data/projects/...` card record
- `repo_url` remains unset while the archive stays intentionally monorepo-owned

## Relationship to Steven research

The intended split is:

- `steven-woods-research` owns the canonical person-centric layer
- `google-canada-research` owns the era-specific deep archive for the Google
  Canada period

Overlap is allowed when context differs.

That means:

- Steven may keep concise person-centric interpretation of Google-era sources
- Google Canada should keep its own era-specific deep interpretation and local
  preservation baseline

## Support scaffold status

Unlike Kinitos, Google Canada currently has no separate
`data/google-canada...` support scaffold tree.

That is not an error. The continuity and archive structure live directly under
`google-canada-research/` plus the top-level public summary page.

## Historical or deprecated path references

The following path family is deprecated for active Google Canada work:

- `/Users/stevenwoods/GitPages/public`

If you encounter it in older notes or historical recovery material, treat it as
reference-only.

Steven-layer overlap is still useful as context, but do not treat
`steven-woods-research` as the active Google Canada workspace.

## Restart rule

If Google Canada is resumed on a new machine:

1. clone or open the canonical `public` repo
2. work from `/Users/steven/Projects-All/public` or an equivalent canonical
   local clone
3. run `bash google-canada-research/tools/start-google-canada-codex.sh`
4. read:
   - `google-canada-research/WORK-PLAN.md`
   - `google-canada-research/PROJECT-STATE-AND-RECOVERY-2026-05-11.md`
   - `google-canada-research/project-manifest.json`
   - `google-canada-research/source-manifest.json`
   - `google-canada-research/public-handoff.json`
