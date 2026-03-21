# Public Status Interface

This document defines how independent project repositories must publish status
for the shared public homepage in this repository.

The shared homepage is:

- [/Users/stevenwoods/GitPages/public/index.html](/Users/stevenwoods/GitPages/public/index.html)

That file is shared and must not be edited directly by independent project
update flows.

## Purpose

Each active project may update its own public-facing project materials without
clobbering other projects' homepage entries.

To make that work:

- each project owns only its own status manifest
- the `public` repo owns homepage rendering and homepage wording

## Rule

Each project may update:

- its own repository
- its own dashboard
- its own public project page
- its own status manifest file for the shared homepage

Each project must not update:

- [/Users/stevenwoods/GitPages/public/index.html](/Users/stevenwoods/GitPages/public/index.html)
- any other project's status manifest

The `public` project alone is responsible for rendering `index.html` from the
status manifests.

## Status Manifest Ownership

Each active project owns exactly one file under `data/projects/`.

Current expected files:

- `data/projects/codex-test1.json`
- `data/projects/phd-renovation.json`
- `data/projects/mmath-renovation.json`

Only the owning project may write its file.

## Required JSON Schema

Each project must write one JSON object with this exact structure:

```json
{
  "schema_version": "1.0",
  "project_id": "codex-test1",
  "active": true,
  "display_name": "Codex-Test1 game project",
  "project_page_path": "codex-test1.html",
  "repo_url": "https://github.com/sgwoods/Codex-Test1",
  "dashboard_url": "https://sgwoods.github.io/Codex-Test1/release-dashboard.html",
  "experience_url": "https://sgwoods.github.io/Codex-Test1/",
  "repo_pushed_at": "2026-03-21T19:57:53Z",
  "status_generated_at": "2026-03-21T20:01:28Z",
  "status_label": "Current release",
  "status_value": "0.5.0-alpha.1",
  "focus_label": "Current focus",
  "focus_value": "Polished four-stage 1.0 slice"
}
```

## Field Definitions

- `schema_version`
  - Must be `1.0`
- `project_id`
  - Stable slug for the project
- `active`
  - `true` if the project should appear on the homepage
- `display_name`
  - Text used for the homepage entry
- `project_page_path`
  - Relative path to the project page in the `public` repo
- `repo_url`
  - Canonical GitHub repository URL
- `dashboard_url`
  - Dashboard URL, or `null` if none
- `experience_url`
  - Public playable/live experience URL, or `null` if none
- `repo_pushed_at`
  - Latest repository state represented by this payload
  - Must be ISO 8601 UTC
- `status_generated_at`
  - When this payload was produced
  - Must be ISO 8601 UTC
- `status_label`
  - Short label such as `Current release`, `Current build line`, or
    `Current track`
- `status_value`
  - Value for the status label
- `focus_label`
  - Usually `Current focus`
- `focus_value`
  - Short current-focus value

## Formatting Requirements

All project updaters must produce deterministic JSON:

- two-space indentation
- stable key order
- trailing newline
- UTF-8 encoding
- use `null` for missing optional URLs
- do not add extra fields unless the schema is formally updated

## Allowed Project Update Flow

Each project's automation may do the following:

1. Update its own repository state.
2. Generate or refresh its own dashboard.
3. Generate or refresh its own public project page.
4. Compute its current public status values.
5. Write only its own JSON file in `data/projects/`.
6. Commit only if that JSON file changed.

## Forbidden Actions

A project updater must not:

- edit [/Users/stevenwoods/GitPages/public/index.html](/Users/stevenwoods/GitPages/public/index.html)
- edit another project's JSON file
- rewrite homepage wording directly
- reorder homepage entries
- update the shared "Repository work last updated" line itself

## Homepage Rendering Responsibility

The `public` repo owns the homepage renderer.

That renderer will:

- read all `data/projects/*.json`
- include only records where `active` is `true`
- render homepage entries in a fixed order
- compute the homepage "Repository work last updated" value from the maximum
  `repo_pushed_at`
- generate [/Users/stevenwoods/GitPages/public/index.html](/Users/stevenwoods/GitPages/public/index.html)

## Suggested Homepage Sentence Template

The `public` renderer should build homepage entry text centrally from the
manifest fields.

Suggested template:

- `{display_name}. Last repo update: {repo_pushed_at as local date}. {status_label}: {status_value}.`

Optional additions:

- add `Dashboard: {dashboard_url}.` when present
- add `Live experience: {experience_url}.` when present

This keeps all homepage wording centralized in `public` while letting each
project own only factual state.

## Project-Specific Guidance

Codex-Test1 should publish:

- repo URL
- dashboard URL
- live experience URL
- release/build state

PhD renovation should publish:

- repo URL
- dashboard URL
- build-line or track state
- no experience URL unless one exists

MMath renovation should publish:

- repo URL
- dashboard URL
- release state
- no experience URL unless one exists

## Commit Guidance

When a project updates its homepage status manifest, prefer a commit message
like:

- `Update public status manifest for Codex-Test1`
- `Update public status manifest for phd-renovation`
- `Update public status manifest for mmath-renovation`

## Summary Rule

Independent projects own facts about themselves.

The `public` project owns homepage presentation.

That separation is what prevents `index.html` collisions.
