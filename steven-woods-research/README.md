# Steven Woods Research

Person-centric archive project for Steven Gregory Woods.

This project collects:

- talks, interviews, podcasts, and presentations
- profile pages and recognition material
- cross-company public record and media mentions
- locally preserved source captures

This project is the canonical deep archive for Steven-centric public-record research, while the top-level `public` pages provide only short summary presentation.

## Coordination files

Machine-readable coordination state lives in:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

Working review state lives in:

- `research/media-sources-review.md`

Use that split intentionally:

- `source-manifest.json` is the machine-readable approved-source baseline used by the collected-content pages
- `research/media-sources-review.md` is the broader working ledger for supporting captures, blocked preservation targets, and source candidates that have not been promoted into the manifest yet

## Continuity surfaces

This project should now be restartable from the canonical shared-public workspace through:

- `WORK-PLAN.md`
- `WORKSPACE-STATUS.md`
- `PROJECT-STATE-AND-RECOVERY-2026-05-10.md`
- `tools/start-steven-woods-codex.sh`

## Shared-layer rule

This project is the canonical shared person-centric layer inside `public`.

- person-centric biography, talks, interviews, profiles, awards, and cross-company interpretation belong here
- company-specific depth belongs in the company archives such as `quack/` and `kinitos-neoedge/`
- Quack may intentionally depend on this archive for person-centric context, but company-critical captures should still be preserved in the company archive as well
