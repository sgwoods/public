# Quack Archive Instructions

This directory is the Quack.com company archive workspace.

Use the tracked shared workflow at `data/shared/company-research-workflow.md` for company-history research, source discovery, manifest updates, timeline/entity extraction, project-page upkeep, and archive coordination work in this subtree.

Read `WORKSPACE-STATUS.md` before doing substantial local work so active work happens in the current canonical checkout rather than a deprecated or parallel one.

Working rules:

- Read `public/ARCHIVE_PROJECT_INTERFACE.md` before making structure, metadata, or publishing decisions.
- Treat Quack as the canonical deep archive for Quack company history.
- Treat `public` as the Steven-centric downstream hub.
- Keep detailed company-specific interpretation in this project.
- Flow only short Steven-relevant summaries upward through `public-handoff.json`.
- Keep `project-manifest.json`, `source-manifest.json`, and `public-handoff.json` current whenever research materially changes the archive.
- Keep the Quack project summary page in sync with the current manifests and research outputs.
- Treat the manifests and project page as ongoing coordination surfaces, not optional polish.
- When Quack discovers a reusable research method, classification rule, page pattern, or preservation practice, update `data/shared/company-research-workflow.md` or another tracked shared workflow file so Kinitos and Quack stay aligned.
- Do not rewrite top-level Steven biography or cross-company pages directly from this subtree.

Collaboration rule:

- Project-specific findings stay in Quack.
- Reusable workflow improvements go into tracked shared workflow files under `data/shared/`.
