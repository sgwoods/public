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
- tracked shared workflow: `data/shared/company-research-workflow.md`
- tracked intake playbook: `data/shared/incoming-artifact-analysis-playbook.md`
- tracked intake template: `data/shared/incoming-artifact-analysis-template.md`
- if local Codex skills exist, they are optional accelerators; the checked-in workflow files above are the recovery baseline
- when Quack discovers a reusable archive method, fold it back into tracked shared workflow files under `data/shared/` so Kinitos and Quack keep the same research workflow

Recovery and audit note:

- current project-state, recoverability, and continuity status: `PROJECT-STATE-AND-RECOVERY.md`
- active local-workspace rule: substantive local Quack work should move to an iCloud-backed checkout and this current path should be treated as transitional until that happens

Formal export files:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

Layout:

- `incoming/` for raw unsorted captures and newly found documents
- `historic/memories/` for interviews, recollections, and timeline notes
- `historic/demos/` for reconstructed demos and presentation flows
- `historic/artifacts/` for scans, screenshots, HTML captures, and source documents
- `historic/code/` for recovered source, build notes, and compatibility work
