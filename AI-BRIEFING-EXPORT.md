# AI Briefing export handoff

AI Briefing is registered after AI Dystopia Quotes in the homepage order and as a
high-value, short-horizon **Protect public surfaces** portfolio priority. Its
newsletter and podcast have outside beta readers, so reliable publication and
source accuracy take precedence over wider distribution. The public code and
live site are linked from the portfolio. The first active export has arrived;
the homepage card, source comparison, and freshness panel are verified working.

## Ownership and first export

The project writes only these two hub files after a successful publication:

- `data/projects/ai-briefing.json`
- `ai-briefing.html`

Commit message: `Update public status manifest for ai-briefing`.
The hub owns ordering, portfolio judgments, observations, and generated indexes.
Do not commit those hub-owned files from `./np hub push`. Use a clean, current
hub checkout, stage the two literal paths, check the staged path list against the
allowlist, and push without force. If the hub bot races the export, reconcile
against current `main` and retry; preserve other projects' updates.

At the October 22 registration check, no hub manifest had arrived and the public
code repository exposed no `v0.1.0-beta` tag. The live site's legacy `/hub/`
manifest had only 15 fields and pointed to the site repository. Registration
initially observed public code as **awaiting first published export**, without
inventing a released identity or timestamp. Later on October 22 the project
published a verified 19-field v0.1.4-beta export identifying clean public commit
`e701aaca6fc66059efe41e177f81128a8fc30e91`; the public tag, canonical page, and
observer match were confirmed. The initial handoff is complete. For future
exports, publish the intended public released commit/ref first. A GitHub Release
object is optional; a public resolvable released commit is required.

## Manifest values

Use the 15 base schema 1.0 fields in PUBLIC_STATUS_INTERFACE.md, followed by the
four approved provenance fields from PROJECT-STATUS-CONTRACT.md:

| Field | Value or rule |
| --- | --- |
| `schema_version` | `"1.0"` |
| `project_id` | `"ai-briefing"` |
| `active` | `true` |
| `display_name` | `"AI Briefing"` |
| `description` | One public sentence about the daily AI briefing, newsletter, and podcast for early-stage investors |
| `project_page_path` | `"ai-briefing.html"` |
| `repo_url` | `"https://github.com/sgwoods/news-pipeline"` |
| `dashboard_url` | `null` unless a real public dashboard exists; the local operations dashboard stays private |
| `experience_url` | `"https://sgwoods.github.io/ai-briefing/"` |
| `repo_pushed_at` | Exactly `source_commit_at`, in UTC; not the edition/publication time |
| `status_generated_at` | Actual export generation time, in UTC |
| `status_label`, `status_value` | Project-owned; `"Current release"` / `"v0.1.4-beta"` is suitable at this audit. A truthful edition label or release-plus-edition value is also supported |
| `focus_label`, `focus_value` | Project-owned public focus, such as beta editorial accuracy, dependable delivery, and reader feedback |
| `source_commit` | Full 40-character SHA of the released clean code in `sgwoods/news-pipeline`; never a private working-repository SHA |
| `source_commit_at` | That public commit's real committer timestamp in UTC |
| `source_ref` | Actual released ref; `"v0.1.4-beta"` at the October 22 verification |
| `source_dirty` | JSON boolean `false` for an approved clean release; fail publication if that cannot be established |

Retain two-space indentation, base-field order followed by the four source
fields, UTF-8, and a trailing newline. Resolve the released public commit and its
date before exporting. Failure must be explicit; never use today's date or
unrelated public `main` as a fallback. The observer discovers the public default
branch (currently `main`) and compares its commit identity against this export.
Differences are review signals, not instructions to promote a release.

Do not add `status_sync: github-pages-build-v1` or `source_build_at`: those belong
to Star Swarm's deployed-build importer. This project owns an explicit export,
and the hub will not rewrite its manifest or HTML page.

## Page template and freshness

Keep the exporter-owned page. Star Swarm's renderer assumes a game build,
gameplay image, and specific architecture/roadmap paths; AI Briefing should not
use that renderer. The shared stylesheet and freshness script provide the common
hub appearance and current observation without duplicating those assumptions.

At the root of `sgwoods/public`, use `assets/public-site.css`,
`shell shell--narrow`, `hero`, `heroTop`, `eyebrow`, `heroHomeLink`, `links`,
`button`, and `panel`. Include a home link and an accessible freshness section:

```html
<link rel="stylesheet" href="assets/public-site.css">
<script src="assets/project-freshness.js" defer></script>
<main class="shell shell--narrow">
  <header class="hero">
    <div class="heroTop">
      <span class="eyebrow">Public project</span>
      <a class="heroHomeLink" href="index.html">Steven Woods</a>
    </div>
    <h1>AI Briefing</h1>
    <!-- Project-owned description, release or edition, and public links. -->
  </header>
  <section class="panel" id="repository-freshness"
           data-project-freshness="ai-briefing"
           data-source-commit="REPLACE_WITH_THIS_PAGES_EXPORTED_PUBLIC_SHA"
           data-source-dirty="false" aria-live="polite">
    <h2>Repository freshness</h2>
    <p>See <a href="index.html#repository-activity">the latest hub observation</a>.
       A current repository comparison has not yet been loaded.</p>
  </section>
</main>
```

Write the page's exact `source_commit` from the same payload as the JSON. Escape
attribute values. The script fetches hub observations with cache disabled and
uses text nodes. It shows last successful check time, matching/differing source,
an eight-day age warning, missing checks, or a failed/unavailable comparison.
It cannot claim a match against a different snapshot, and never changes release
or edition labels. The fallback link remains usable without JavaScript.

For a copy served under another site's `/hub/` path, use absolute hub asset URLs
and absolute hub navigation URLs; relative paths above are for the canonical
page in `sgwoods/public`. Keep the local dashboard, private source lists,
subscriber details, settings, and operational identifiers out of both outputs.
The live site's email link is currently `https://sgwoods.github.io/ai-briefing/#email`
and the podcast feed is `https://sgwoods.github.io/ai-briefing/podcast.xml`.

## Trigger and credentials

A push on hub `main` touching `data/projects/*.json` triggers
`render-public-index.yml` immediately through its push event. `ai-briefing.html`
is also a watched path, so a page-only export triggers a refresh. The daily
13:17 UTC schedule is a fallback, not the only route. GitHub may delay scheduled
runs; it is not an exact publication deadline. The hub explicitly requests a
Pages build after committing refreshed coordination output.

For a local `./np hub push`, use the owner's normal authenticated Git credential,
or a fine-grained PAT / GitHub App installation token restricted to
`sgwoods/public` with **Contents read/write** (plus automatic Metadata read).
No Workflows write, Pages write, or private-repository access is needed for this
two-file push. Contents write is repository-wide: GitHub cannot restrict that
token to these two paths, so enforce the allowlist in the exporter.

A normal PAT/App push triggers the hub workflow. A source workflow's automatic
`GITHUB_TOKEN` is scoped to its own repository and cannot push into this hub.
The Actions-only token used for Star Swarm notifications cannot perform this
export. A separate explicit dispatch requires **Actions write** on `sgwoods/public`
and must happen only after the approved export reaches hub `main`. Dispatch is
optional when the normal push already triggers the workflow. Do not add skip-CI
markers to the export commit. See [GitHub's workflow-trigger rules](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow).

## Acceptance evidence

After the first owner publication, verify the public release tag resolves, both
owned files identify the intended published source, the hub push run succeeds,
the homepage places AI Briefing after AI Dystopia Quotes, the portfolio uses the
exported factual state, and the canonical page's freshness panel loads the new
observation. Compare source commits; do not infer a release from an edition date.
