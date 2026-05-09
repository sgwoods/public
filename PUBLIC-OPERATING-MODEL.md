# Public Repo Operating Model

Updated: `2026-05-07`

This file defines the intended ongoing role of `sgwoods/public`.

The key rule is simple:

- this repo is the shared Woods presentation, reporting, and coordination layer
- it is not just another standalone project repo
- other projects may publish into it, but they should not redefine its structure ad hoc

## What this repo is for

`sgwoods/public` is the top-level shared public layer for:

- cross-project summary and navigation
- shared public presentation
- ingestion and reporting coordination
- selected public-facing exports from standalone repos
- shared-public research/archive subprojects that still live inside this repo
- durable public/archive assets that belong to the common Woods layer rather than to one standalone repo

The default public starting point is:

- `index.html`

That page should remain the one clear place to:

- see project summaries
- see current status/focus for active projects
- link out to deeper project pages, dashboards, handbooks, and archive sections

## Structure classes

Use these classes consistently when deciding where work belongs.

| Class | What it contains | Current examples | Ownership model |
| --- | --- | --- | --- |
| Shared navigation and reporting layer | Cross-project homepage, shared assets, shared renderers, shared workflow docs | `index.html`, `assets/`, `tools/render_index.py`, `data/shared/`, `README.md`, `PUBLIC_STATUS_INTERFACE.md`, `ARCHIVE_PROJECT_INTERFACE.md` | Owned by the `public` repo itself |
| Standalone project exports and summary cards | Public pages and status manifests published in from true standalone repos | `data/projects/aurora-galactica.json`, `data/projects/phd-renovation.json`, `data/projects/mmath-renovation.json`, `data/projects/ai-dystopia-quotes.json`, top-level pages such as `phd-renovation.html`, `phd-renovation-dashboard.html`, `phd-renovation-handbook.html`, `mmath-renovation.html`, `aurora-galactica.html` | Owned by the originating standalone repo; `public` only renders and presents them |
| Shared-public subprojects | Deep archive/research areas that still live inside `public` as subdirectories | `steven-woods-research/`, `quack/`, `kinitos-neoedge/`, `canberra-research/`, `google-canada-research/`, `inovia-research/`, `sei-pittsburgh-research/` plus their top-level landing pages | Maintained inside the canonical `public` clone unless deliberately split into separate repos later |
| Legacy, compatibility, or deprecated patterns | Transitional aliases, duplicate publication paths, or older local clone habits that should not expand casually | `data/projects/codex-test1.json`, `codex-test1.html`, the bridge `data/projects/quack-com.json`, the bridge `data/projects/kinitos-neoedge.json`, older sparse single-purpose local clones of `public`, deprecated `/Users/stevenwoods/GitPages/public` checkout, recovery-only iCloud clone conventions | Keep only when needed for continuity or compatibility; label them clearly |

## Ongoing ownership model

### 1. Shared top-level layer

`public` owns:

- homepage rendering
- shared navigation wording
- card ordering
- shared CSS/JS/assets
- shared ingestion/reporting docs
- rules for how other projects publish into this layer

### 2. Standalone repos

A true standalone repo owns:

- its own durable Git history
- its own detailed docs and status logic
- its own dashboard or handbook generation
- its own exported status facts

The standalone repo may publish selected outputs into `public`, but it should only write:

- its own top-level public page(s)
- its own canonical `data/projects/<project>.json`
- any intentionally owned exported artifacts for that project

It should not directly edit shared homepage presentation logic.

### 3. Shared-public subprojects

A shared-public subproject owns:

- its own subdirectory content inside this repo
- its own top-level landing page in the repo root
- its own `project-manifest.json`
- its own `source-manifest.json`
- its own `public-handoff.json`

Those subprojects should not automatically create or depend on separate top-level clones under `Projects-All`.

The default model is:

- one canonical `public` clone
- multiple named subproject directories inside it

If one of those subprojects is later split into its own standalone repo, document that decision explicitly and update its ownership and publishing rules at the same time.

## Preferred active clone model

For the newer machine and for ongoing work going forward, the preferred active clone is:

- `~/Projects-All/public`

Interpretation:

- `Projects-All/public` is the canonical active working clone for the shared public layer
- true standalone repos should each have their own sibling working clone under `Projects-All`
- shared-public subprojects should normally be edited inside `Projects-All/public`
- do not casually create extra top-level clones for `quack`, `steven-woods-research`, `google-canada-research`, and similar subprojects unless there is a deliberate operational reason

Recommended `Projects-All` shape:

```text
~/Projects-All/
  public
  phd-renovation-working
  mmath-renovation-working
  sci-fi-ai-dystopian-project-working
  Codex-Test1
  abtweak-experiments-ui
```

The exact sibling repo names can vary, but the category split should stay the same.

## Publishing model

### Standalone repo into public

Default flow:

1. Update the standalone repo.
2. Generate or refresh its own public-facing outputs.
3. Sync only the owned exported artifacts into `public`.
4. Let `public` render the homepage from those published facts.

The usual `public` export lane for a standalone repo is:

- `data/projects/<project>.json`
- top-level project page(s) owned by that repo

### Shared-public subproject inside public

Default flow:

1. Work inside the canonical `public` clone.
2. Update the subproject directory and its top-level landing page.
3. Refresh `project-manifest.json`, `source-manifest.json`, and `public-handoff.json` as needed.
4. Let the shared `public` navigation and homepage surface those materials coherently.

The default export lane for a shared-public subproject is:

- `<subproject>/project-manifest.json`
- `<subproject>/source-manifest.json`
- `<subproject>/public-handoff.json`

Do not create new `data/projects/*.json` entries for shared-public subprojects unless there is a documented compatibility reason.

## Duplicate and bridge rules

Some duplicate paths exist today for compatibility.

Current examples:

- `codex-test1` is a legacy compatibility alias for `aurora-galactica`
- `quack-com` and `kinitos-neoedge` currently appear both as shared-public subprojects and as bridge records in `data/projects/`

Treat these as bridge patterns, not as the preferred default for new work.

When a duplicate exists, document which copy is:

- canonical
- compatibility-only
- temporary bridge logic

## Big-picture rule

We want one durable pattern:

- standalone repo truth stays in the standalone repo
- shared-public subproject truth stays inside the canonical `public` clone
- `public` remains the one cross-project public summary and presentation layer

That is the model to preserve as more projects move into `Projects-All`.
