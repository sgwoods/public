# Kinitos / NeoEdge Networks working repository

This folder is the working repository for the Kinitos / NeoEdge Networks archive project.

Current operating note:

- the living execution plan is `WORK-PLAN.md`
- the canonical workspace label and deprecated-checkout notes live in `WORKSPACE-STATUS.md`
- the new-machine startup and Mac handoff guide lives in `PORTABILITY-AND-MAC-HANDOFF.md`
- going forward, active local work for this archive should happen in the canonical `~/Projects-All/public` checkout
- the canonical active local workspace is `/Users/steven/Projects-All/public`
- older recovery or legacy checkouts should be treated as reference-only for Kinitos local work
- the Codex startup validation script is `tools/start-kinitos-codex.sh`

Workflow:

- place raw finds in `incoming/`
- process and summarize them
- move curated material into `historic/` by type
- use named lead clusters and themed research passes when a campaign such as site captures, investor trail, or exit evidence needs to stay visible

Shared analysis guidance:

- playbook: `public/data/shared/incoming-artifact-analysis-playbook.md`
- template: `public/data/shared/incoming-artifact-analysis-template.md`
- tracked shared workflow: `data/shared/company-research-workflow.md`
- tracked intake playbook: `data/shared/incoming-artifact-analysis-playbook.md`
- tracked intake template: `data/shared/incoming-artifact-analysis-template.md`

Layout:

- `incoming/` for raw unsorted captures and newly found documents
- `historic/memories/` for interviews, recollections, and timeline notes
- `historic/demos/` for video leads, demo reconstructions, and presentation flows
- `historic/artifacts/` for scans, screenshots, HTML captures, and source documents
- `historic/code/` for recovered source, build notes, and compatibility work
