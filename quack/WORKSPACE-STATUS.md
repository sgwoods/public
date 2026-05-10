# Quack Workspace Status

Last updated: `2026-05-10`

This note labels the active Quack workspace, the staged-archive ownership model, and which path references should be treated as historical only.

## Canonical active workspace

Canonical shared-public repo workspace:

- `/Users/steven/Projects-All/public`

Canonical Quack deep archive root:

- `/Users/steven/Projects-All/public/quack`

Canonical public summary page:

- `/Users/steven/Projects-All/public/quack-com.html`

Canonical project card source:

- `/Users/steven/Projects-All/public/data/projects/quack-com.json`

## Archive model

Quack is currently a staged company archive inside the shared `public` repo.

That means:

- `quack/` is the canonical deep archive root for Quack company history
- `quack-com.html` is the public-facing summary page
- `data/projects/quack-com.json` is the top-level project-status export used by the shared public index
- `repo_url` remains unset until there is an intentional standalone-repo extraction

## Support scaffold status

Unlike Kinitos, Quack currently has no separate `data/quack...` support scaffold tree.

That is not an error by itself. It means the continuity and archive structure live directly under `quack/` plus the shared top-level public surfaces.

## Historical or deprecated path references

The following path family is deprecated for active Quack work:

- `/Users/stevenwoods/GitPages/public`

If you encounter it inside older research metadata or notes, treat it as historical reference only.

Cross-project copies under `steven-woods-research/` can still be useful as related context, but they are not the canonical Quack artifact lane. Prefer Quack-owned copies under:

- `/Users/steven/Projects-All/public/quack/historic/artifacts/archive-html`

## Restart rule

If Quack is resumed on a new machine:

1. clone or open the canonical `public` repo
2. work from `/Users/steven/Projects-All/public` or an equivalent canonical local clone
3. run `bash quack/tools/start-quack-codex.sh`
4. read:
   - `quack/WORK-PLAN.md`
   - `quack/PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
   - `quack/project-manifest.json`
   - `quack/source-manifest.json`
   - `quack/public-handoff.json`

