---
name: research-person
description: Use when building or maintaining a person-centric research archive or profile project. Organize interviews, talks, profiles, awards, and cross-company media into a structured source review, local archive captures, and manifest exports that can coordinate with top-level summary pages and related company archives.
---

# Research Person

Use this skill for person-centric archival research projects.

Typical tasks:

- collect talks, interviews, podcasts, profiles, awards, and media mentions
- separate person-centric sources from company-centric sources
- preserve local source captures when possible
- build `project-manifest.json`, `source-manifest.json`, and `public-handoff.json`
- coordinate with company archives without duplicating their deep interpretation

## Core workflow

1. Create or confirm a project structure:
   - `incoming/`
   - `historic/`
   - `research/`
   - `project-manifest.json`
   - `source-manifest.json`
   - `public-handoff.json`
2. Gather sources and classify them into:
   - `appearance`
   - `profile`
   - `media-mention`
   - `press-release`
3. Keep a review ledger in `research/` before promoting sources into the manifest.
4. Preserve local HTML or metadata captures when feasible.
5. For overlapping company-era sources:
   - keep the short person-centric interpretation in the person project
   - link the deeper company context to the owning company archive

## Required distinctions

- top-level shell:
  - summary and navigation only
- person project:
  - canonical deep archive for the person-centric record
- company project:
  - canonical deep archive for company-specific detail

## Source rules

- prefer exact titles and dates
- note date precision as `day`, `month`, `year`, or `approximate`
- preserve canonical URL and local archive path separately
- mark records `approved`, `deferred`, or `rejected`
- use stable IDs like:
  - `src-steven-2023-riddick-show`
  - `src-steven-2021-usask-alumni-profile`

## Output expectations

When doing this work, produce:

- a reviewed source ledger
- a `source-manifest.json`
- a `project-manifest.json`
- a `public-handoff.json`
- a public-facing project page summary when requested

## References

For this repo, read:

- `/Users/stevenwoods/GitPages/public/ARCHIVE_PROJECT_INTERFACE.md`
