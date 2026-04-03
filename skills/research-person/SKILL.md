---
name: research-person
description: Use when building or maintaining a person-centric research archive or profile project, especially when the goal is to discover, verify, organize, and synthesize a person's public record across LinkedIn, employer bios, institutional pages, media, talks, patents, publications, and related company archives. Supports source review, timeline extraction, manifest exports, local archive captures, and Wikipedia-style biography draft preparation.
---

# Research Person

Use this skill for person-centric archival research and biography work.

Typical tasks:

- build a person timeline from public sources
- use LinkedIn and other self-approved profiles as a baseline identity map
- expand by employer, institution, company era, publication, patent, and media trail
- separate person-centric interpretation from company-centric interpretation
- preserve local source captures when possible
- favor inline viewing or playback on archive pages, with separate-open fallback links
- build `project-manifest.json`, `source-manifest.json`, and `public-handoff.json`
- draft concise public-facing profile pages
- draft a Wikipedia-style biography candidate when requested

## Start here

1. Confirm or create the project structure:
   - `incoming/`
   - `historic/`
   - `research/`
   - `project-manifest.json`
   - `source-manifest.json`
   - `public-handoff.json`
2. Read:
   - `/Users/stevenwoods/GitPages/public/ARCHIVE_PROJECT_INTERFACE.md`
   - [references/source-hierarchy.md](references/source-hierarchy.md)
3. If a Wikipedia-style draft is requested, also read:
   - [references/wikipedia-biography-drafts.md](references/wikipedia-biography-drafts.md)

## Core workflow

1. Build a baseline identity record.
2. Extract a structured timeline.
3. Expand each career or institution phase with better sources.
4. Keep a review ledger in `research/` before promoting records into the manifest.
5. Preserve local HTML, metadata, or document captures when feasible.
6. When building archive pages, prefer inline viewers or players for preserved local copies, and always keep a separate-open option for external pages.
7. Promote only reviewed records into `source-manifest.json`.
8. For overlapping company-era sources:
   - keep the short person-centric interpretation in the person project
   - link the deeper company context to the owning company archive

## Baseline identity record

Start with the best self-approved or self-presented sources you can verify:

- LinkedIn
- current employer biography
- personal site
- bio.link / about.me
- Wikipedia, if a page already exists

Use those sources first to extract:

- preferred display name
- current role and organization
- prior employers and rough dates
- education and degrees
- geography
- public link network
- major company names and transitions

Treat LinkedIn as a major baseline source for living people. It is not the sole authority, but it is often the best starting map for roles, employers, chronology, and approved public identity.

## Timeline extraction requirements

Every mature person archive should be able to answer:

- where the person studied
- where the person worked
- what they founded or built
- what public talks or interviews they gave
- what publications, patents, or awards matter
- what the major transitions were

Keep a working timeline in `research/` even before every item is fully sourced.

Minimum timeline lanes:

- education
- research / academic work
- companies founded
- employment / executive roles
- talks and interviews
- publications / patents / awards

## Source handling

Classify each discovered source into one of:

- `appearance`
- `profile`
- `media-mention`
- `press-release`
- `publication`
- `patent`
- `artifact`

Mark each record:

- `approved`
- `deferred`
- `rejected`

Preserve:

- exact or best-verified title
- date display text
- ISO-sortable date
- date precision: `day`, `month`, `year`, or `approximate`
- canonical URL
- local archive path if preserved
- short note on why the source matters

Prefer:

- local archive capture when the source is likely to drift or disappear
- local archive playback or viewing inside the project page when feasible
- a separate-open fallback for any external source

Use stable IDs like:

- `src-steven-2023-riddick-show`
- `src-steven-2021-usask-alumni-profile`
- `src-steven-2013-google-canada-interview`

## Required distinctions

- top-level shell:
  - summary and navigation only
- person project:
  - canonical deep archive for the person-centric record
- company project:
  - canonical deep archive for company-specific detail

Never let the person archive silently absorb the company archive's deeper interpretation.

## Discovery and expansion pattern

Once the baseline identity record exists, expand source collection by phase:

1. For each employer or company:
   - official bio pages
   - interviews
   - talks
   - company announcements
   - press coverage
2. For each academic phase:
   - university profiles
   - genealogy pages
   - publications
   - theses
   - talks and awards
3. For each company founded:
   - acquisition or funding coverage
   - product pages
   - patents
   - demos
   - executive bios
4. For later public identity:
   - podcasts
   - keynote videos
   - alumni profiles
   - investor and board profiles

## Wikipedia-style draft mode

When asked for a Wikipedia-style biography draft:

- do not write from self-published sources alone
- first test whether the person appears to satisfy notability through multiple independent reliable secondary sources
- prefer independent coverage over primary biography pages
- write conservatively for a living person
- avoid promotional tone, unverified claims, and resume-style lists
- produce a draft that can replace or improve an existing page only if the sourcing is strong enough

The output should include:

- a neutral lead
- a short chronological structure
- inline citation placeholders or source mapping notes
- a note describing which claims are strongly supported and which should stay out

If the source base is not strong enough for a compliant article draft, say so explicitly and produce:

- a notability assessment
- a gap list
- a safer draft outline instead of a full article

## Output expectations

When doing this work, produce some or all of:

- a reviewed source ledger
- a working timeline
- a `source-manifest.json`
- a `project-manifest.json`
- a `public-handoff.json`
- a concise public-facing profile page summary
- a Wikipedia-style biography draft or notability assessment when requested

## Notes

- Treat LinkedIn as a strong baseline identity source for living people, but not a substitute for independent sourcing.
- Treat weak aggregators and mirrors as discovery aids unless the workflow explicitly marks them as internal scaffolding only.
- Promote claims into public-facing pages only after the source quality is good enough.
