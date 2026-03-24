# Archive Project Interface

Purpose: define how independent archive projects coordinate with the top-level `public` site.

This document applies to projects such as:

- `steven-woods-research`
- `quack`
- `kinitos-neoedge`

The top-level site is the Steven Woods hub shell. The archive projects are the deep historical archives.

## Ownership model

Use this split consistently:

- `public` owns the top-level shell, navigation, and cross-project summary
- `steven-woods-research` owns the canonical person-centric deep archive
- each company archive project owns its company-centric deep history

That means:

- `public` presents Steven Woods, his background, career phases, active archive projects, and cross-project summaries
- `steven-woods-research` presents the detailed person-centric record: talks, interviews, profiles, awards, and cross-company media
- each archive project presents the detailed company story, artifacts, demos, code, press, timelines, and recovery notes for that company

## Canonical roles

`public` is canonical for:

- top-level navigation
- shared visual style
- high-level summaries of the archive projects

`steven-woods-research` is canonical for:

- person-level biography and background
- talks, interviews, podcasts, profiles, and awards
- cross-company career timeline and person-centric source interpretation

An archive project is canonical for:

- company timeline
- company-specific source interpretation
- memories, demos, artifacts, scans, recovered code
- press and media in company context
- technical and product history

## Duplication policy

Duplication is allowed only when the context differs.

Allowed:

- `public`: short hub summary and navigation
- `steven-woods-research`: short or medium person-centric interpretation
- archive project: full, company-centric detail

Not allowed:

- two separate long-form canonical descriptions of the same source
- conflicting dates, titles, or source URLs without an explicit note

## Required exports

Each archive project should maintain and publish three machine-readable files:

1. `project-manifest.json`
2. `source-manifest.json`
3. `public-handoff.json`

These may live in the archive project repo itself, but their contents are intended for `public` to consume.

## Project manifest

Each archive project owns one top-level summary record.

Recommended shape:

```json
{
  "schema_version": "1.0",
  "project_id": "quack-archive",
  "active": true,
  "display_name": "Quack.com Archive Recovery",
  "description": "Collection of memories, demos, artifacts, press, and recovered code from the Quack.com era.",
  "person_context": "Steven Woods co-founded Quack.com, an early interactive voice assistant company acquired by AOL in 2000.",
  "project_page_url": "https://example.com/quack/",
  "repo_url": "https://github.com/sgwoods/quack",
  "timeline_span": {
    "start_year": 1998,
    "end_year": 2000,
    "label": "Quack.com era"
  },
  "repo_pushed_at": "2026-03-24T12:00:00Z",
  "status_generated_at": "2026-03-24T12:10:00Z",
  "current_focus": "Press archive recovery and demo reconstruction",
  "notable_items": [
    {
      "label": "AOL acquisition coverage",
      "url": "https://example.com/item"
    },
    {
      "label": "Recovered voice portal materials",
      "url": "https://example.com/item"
    }
  ],
  "featured_source_ids": [
    "src-quack-2000-internetnews-aol-cap",
    "src-quack-2000-sfgate-voice-portals"
  ]
}
```

### Project manifest field rules

- `schema_version`
  - currently `1.0`
- `project_id`
  - stable slug; do not rename casually
- `active`
  - whether this archive should appear in the top-level hub
- `display_name`
  - top-level card title
- `description`
  - short company/archive summary
- `person_context`
  - one sentence connecting the project to Steven Woods
- `project_page_url`
  - canonical public URL for the archive landing page
- `repo_url`
  - canonical repository URL
- `timeline_span`
  - start and end years for display
- `repo_pushed_at`
  - latest repository state reflected by the manifest
- `status_generated_at`
  - when the manifest was produced
- `current_focus`
  - current archival/recovery focus
- `notable_items`
  - short featured links suitable for homepage or summary use
- `featured_source_ids`
  - stable source IDs that `public` may surface

## Source manifest

Each archive project should export all approved and in-review source records that matter to that company.

Recommended shape:

```json
{
  "schema_version": "1.0",
  "project_id": "quack-archive",
  "sources": [
    {
      "source_id": "src-quack-2000-internetnews-aol-cap",
      "title": "Another Feather In AOL's Cap",
      "source_type": "media-mention",
      "company_context": "Quack.com",
      "person_relevance": "Steven Woods co-founded Quack.com and this source covers the AOL acquisition.",
      "date": {
        "display": "2000",
        "sort": "2000-01-01",
        "precision": "year"
      },
      "urls": {
        "canonical": "https://www.internetnews.com/it-management/another-feather-in-aols-cap/",
        "archive_local": "data/archive-html/internetnews-another-feather-in-aols-cap-2000.html",
        "archive_web": null
      },
      "ownership": {
        "canonical_repo": "quack-archive",
        "person_hub_use": "summary-ok",
        "company_deep_link": "preferred"
      },
      "tags": [
        "acquisition",
        "press",
        "aol",
        "quack"
      ],
      "status": "approved",
      "notes": "Use in top-level Steven career timeline and Quack exit section."
    }
  ]
}
```

### Source manifest field rules

- `source_id`
  - stable identifier
- `title`
  - exact or best-verified display title
- `source_type`
  - suggested values:
    - `appearance`
    - `profile`
    - `media-mention`
    - `press-release`
    - `artifact`
- `company_context`
  - company or era this source belongs to
- `person_relevance`
  - one sentence reusable by `public`
- `date.display`
  - user-facing display date
- `date.sort`
  - ISO-sortable best estimate
- `date.precision`
  - `day`, `month`, `year`, or `approximate`
- `urls.canonical`
  - best public source URL
- `urls.archive_local`
  - local path in the archive project if preserved
- `urls.archive_web`
  - external archive URL if applicable
- `ownership.canonical_repo`
  - owning archive project
- `ownership.person_hub_use`
  - suggested values:
    - `summary-ok`
    - `do-not-surface-yet`
- `ownership.company_deep_link`
  - usually `preferred`
- `tags`
  - short topical tags
- `status`
  - `approved`, `deferred`, or `rejected`
- `notes`
  - concise archival/editorial note

## Source ID convention

Use stable source IDs of the form:

- `src-quack-2000-internetnews-aol-cap`
- `src-quack-2023-risking-it-all-repost`
- `src-kinitos-2003-usask-sorenson-lecture`
- `src-neoedge-2009-gamedeveloper-offspring`

Pattern:

- `src-{company-or-era}-{year}-{short-slug}`

## Public handoff file

Each archive project should keep a handoff file for material that should appear in the top-level hub.

Recommended shape:

```json
{
  "schema_version": "1.0",
  "project_id": "kinitos-neoedge-archive",
  "handoff_generated_at": "2026-03-24T12:30:00Z",
  "items_for_public": [
    {
      "source_id": "src-kinitos-2003-usask-sorenson-lecture",
      "reason": "Important Steven public appearance",
      "recommended_section": "public-appearances",
      "summary": "P.G. Sorenson Lecture at the University of Saskatchewan while Steven Woods was CEO of Kinitos."
    }
  ],
  "open_questions": [
    {
      "question": "Exact event context for the 2012 keynote deck still needs confirmation."
    }
  ]
}
```

## Status rules

Use these consistently:

- `approved`
  - verified enough for public use
- `deferred`
  - worth keeping, but not yet strong enough for public use
- `rejected`
  - keep only as review history; do not surface in `public`

## Formal instructions for archive projects

Each archive project must follow these rules:

1. Maintain the deep historical archive for your company as the canonical detailed source.
2. Export a `project-manifest.json` for top-level summary use.
3. Export a `source-manifest.json` for source-level coordination.
4. Export a `public-handoff.json` for newly surfaced Steven-relevant items.
5. Do not edit Steven biography pages or cross-company timeline pages in `public` directly.
6. Do not own person-level narrative outside your company context.
7. When you discover a new source:
   - record it in your archive project
   - assign a stable `source_id`
   - capture canonical URL
   - capture local archive path if preserved
   - set `status`
   - add `person_relevance` if it matters to the top-level hub
8. When a source is only weakly verified, mark it `deferred`.
9. When a source belongs mainly to the company archive, keep the detailed note there and let `public` use only the short summary.
10. When a source should appear in the Steven hub, add it to `public-handoff.json`.

## Formal instructions for the public repo

The `public` repo should:

- consume archive project manifests
- render top-level project summaries
- render Steven-centric cross-company summaries
- use archive projects as the preferred deep-link destinations
- avoid duplicating full company histories

The `public` repo should not:

- become the canonical store of company-specific detailed annotations
- drift away from archive project metadata for project status and featured items

## Recommended project focus areas

`quack`

- Quack.com company history
- voice portal product story
- AOL acquisition coverage
- patents, demos, artifacts, memories

Suggested tags:

- `quack`
- `voice-portal`
- `aol`
- `acquisition`
- `press`
- `demo`

`kinitos-neoedge`

- Kinitos origin story
- enterprise software phase
- transition to NeoEdge
- casual games / ad network phase
- press, talks, artifacts, code

Suggested tags:

- `kinitos`
- `neoedge`
- `lecture`
- `enterprise-software`
- `games`
- `adtech`
- `press`

## Handoff expectation

Archive projects will progress independently and may discover important person-level material over time.

Because of that, each archive project should treat these files as a formal handoff interface:

- `project-manifest.json`
- `source-manifest.json`
- `public-handoff.json`

New discoveries that matter to Steven Woods broadly should be pushed through that interface rather than through direct edits to the top-level hub.

## Summary rule

Use this sentence as the governing principle:

`public` owns the hub shell. `steven-woods-research` owns person-centric depth. Company archives own company-centric depth.
