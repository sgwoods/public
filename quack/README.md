# Quack.com working repository

This folder is the working repository for the Quack.com archive project.

Archive coordination contract:

- governed by `public/ARCHIVE_PROJECT_INTERFACE.md`
- `public` is the Steven-centric hub
- this archive owns Quack-specific depth, sources, and interpretation

Current conflict to keep explicit:

- this archive is currently staged inside the `public` repo instead of a separate canonical deep-archive repo
- because of that, `repo_url` in `project-manifest.json` is still unset
- top-level Steven biography and cross-company pages should not be treated as archive-owned here

Workflow:

- place raw finds in `incoming/`
- process and summarize them
- move curated material into `historic/` by type

Shared analysis guidance:

- playbook: `public/data/shared/incoming-artifact-analysis-playbook.md`
- template: `public/data/shared/incoming-artifact-analysis-template.md`
- if your local Codex environment provides a shared `company-research` or artifact-intake skill, treat it as a helper rather than a path dependency
- when Quack discovers a reusable archive method, fold it back into the shared workflow so Kinitos and Quack keep the same research process

Formal export files:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

Continuity and restart surfaces:

- `WORK-PLAN.md`
- `WORKSPACE-STATUS.md`
- `PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
- `tools/start-quack-codex.sh`

Layout:

- `incoming/` for raw unsorted captures and newly found documents
- `historic/memories/` for interviews, recollections, and timeline notes
- `historic/demos/` for reconstructed demos and presentation flows
- `historic/artifacts/` for scans, screenshots, HTML captures, and source documents
- `historic/code/` for recovered source, build notes, and compatibility work

Active local continuity rule:

- active Quack work should now happen from the canonical shared-public checkout at `/Users/steven/Projects-All/public`
- older `GitPages/public` absolute paths that still appear inside historic research metadata should be treated as deprecated reference paths, not as the active workspace
