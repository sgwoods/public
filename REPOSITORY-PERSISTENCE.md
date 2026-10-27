# Repository persistence inventory

Audited October 26, 2026 in the canonical `Projects-All/public` checkout.
Repository: [sgwoods/public](https://github.com/sgwoods/public), public, default
branch `main`. This inventories local persistence, not a new release or research
completeness claim. Private projects' code/data must remain in their own private
repositories; only their approved summaries belong here.

## Findings and actions

- The initial working tree was clean: no staged, modified, deleted, or untracked
  project files were waiting for a normal commit.
- Local `main` was **45 commits behind**, not ahead of, GitHub. A fast-forward
  brought in the already-published observations, exports, and coordination pages.
  The pre-inventory baseline is `ae61474e3e258b3686f2e6708531a614edaf856f`.
- All eight original local branch tips were already reachable through fetched
  GitHub refs. A branch without a configured upstream was not necessarily unsaved.
- One May 20 autostash was local-only. Its seven changed files were reviewed:
  README, new-Mac guide, bootstrap helper, portfolio notes, and generated overview
  and index files. Its base also retained an older workflow-hardening commit.
- The exact stash and its three previously local-only commits are now preserved at
  [codex/preserved-autostash-2026-10-26](https://github.com/sgwoods/public/tree/codex/preserved-autostash-2026-10-26),
  commit `e4faba77ee2289f4cf17b098185a69d6ff4c09c5`. The original local stash was
  retained. **Do not merge this old snapshot into current main.** The startup helper
  and new-Mac guide in that stash already match current main; the portfolio
  judgments and generated pages are historical, not current status.
- After that recovery push, `git rev-list --count --all --not --remotes` returned
  zero. All commits reachable through current local refs, including the stash,
  are now reachable through GitHub refs. This does not certify deleted refs or
  arbitrary unreachable objects in the local object database.
- Ignored local files were only `.DS_Store`, Python `__pycache__`, and `.pyc`
  products. They are disposable metadata/caches, not unpublished project work.
- There were no tracked-but-deleted files, Git submodules, tracked symlinks, or
  Git LFS pointers. The inspected artifacts are ordinary Git blobs rather than
  external pointer files.
- The checked-in research skill had one obsolete absolute checkout path. It now
  links to the archive interface relative to the skill, so a new clone can use it.

## What is already saved

At the baseline above, **3,235 tracked files** were present. This report is an
additional file; counts below are a dated baseline, not live counters.

| Area | Files | What is persisted |
| --- | ---: | --- |
| Root | 53 | Landing/project HTML, contracts, operating and recovery docs, portfolio overview, theses, CV, publication sources and outputs |
| `tools/` | 21 | Renderers, observers, provenance helpers, summary validators, bootstrap helper, and six test files |
| `.github/` | 1 | Daily/push/manual refresh, validation, bot publication, explicit Pages rebuild workflow |
| `assets/` | 4 | Shared stylesheet, homepage refresh/chart code, project freshness widget, profile image |
| `data/` | 29 | Project exports, public observations/activity, approved working aggregates, editorial data, shared processes and portfolio judgments |
| `skills/` | 3 | Person-research skill, source hierarchy, Wikipedia-draft guidance |
| `Spectra/` | 2,904 | Preserved legacy research/site tree, source/examples, publication and teaching artifacts |
| `steven-woods-research/` | 47 | Person-centric research, manifests, review/continuity material, and local captures |
| `quack/` | 41 | Company archive, source/campaign/review data, cached evidence, research pipeline and launcher |
| `kinitos-neoedge/` | 49 | Company archive, source ledger, preservation evidence, cached documents/pages and continuity material |
| `google-canada-research/` | 25 | Era archive, sources, captures and work/recovery notes |
| `inovia-research/` | 20 | Era archive, sources, captures and work/recovery notes |
| `sei-pittsburgh-research/` | 28 | Era archive, source papers/pages, manifests and work/recovery notes |
| `canberra-research/` | 10 | Scaffold, manifests, seed leads and supporting notes |

Examples across the entire tracked tree include 45 PDFs, five ZIPs, 192 GIFs,
170 PostScript files, and three BibTeX files. Legacy files are preserved artifacts,
not a statement that old programs are safe to execute or every source is complete.

## Process and interface map

| Concern | Authoritative files / inputs |
| --- | --- |
| Repository ownership and clone model | [PUBLIC-OPERATING-MODEL.md](PUBLIC-OPERATING-MODEL.md), [PROJECT-STATE-AND-RECOVERY.md](PROJECT-STATE-AND-RECOVERY.md) |
| Released status and freshness | [PROJECT-STATUS-CONTRACT.md](PROJECT-STATUS-CONTRACT.md), [PUBLIC_STATUS_INTERFACE.md](PUBLIC_STATUS_INTERFACE.md), `data/projects/*.json` |
| Shared archive schema | [ARCHIVE_PROJECT_INTERFACE.md](ARCHIVE_PROJECT_INTERFACE.md), each archive's `project-manifest.json`, `source-manifest.json`, `public-handoff.json` |
| Portfolio judgment / reprioritization | [PROJECT-SUITE-OVERVIEW.md](PROJECT-SUITE-OVERVIEW.md), `data/shared/project-suite-overview.json` |
| Public commit metrics | [PORTFOLIO-METRICS.md](PORTFOLIO-METRICS.md), `data/shared/repository-activity.json`, `data/shared/repository-observations.json` |
| Approved private summaries | [PRIVATE-PROJECT-STATUS.md](PRIVATE-PROJECT-STATUS.md) |
| Actual working-history aggregates | [WORKING-ACTIVITY-INTERFACE.md](WORKING-ACTIVITY-INTERFACE.md), `data/activity/*.json` |
| Cross-machine source work | [REPOSITORY-HANDOFFS.md](REPOSITORY-HANDOFFS.md), [AI-BRIEFING-EXPORT.md](AI-BRIEFING-EXPORT.md) |
| Research process / incoming artifacts | `data/shared/company-research-workflow.md`, `data/shared/incoming-artifact-analysis-playbook.md`, `data/shared/incoming-artifact-analysis-template.md` |
| Person-centric research skill | [skills/research-person/SKILL.md](skills/research-person/SKILL.md) and its two linked references |
| Machine setup / closeout | [START-HERE-NEW-MAC.md](START-HERE-NEW-MAC.md), [OLD-MACHINE-CLOSEOUT-2026-05-16.md](OLD-MACHINE-CLOSEOUT-2026-05-16.md) |

Rental operations (`confidential-project`), personal financial planning
(`financial-planner`), and the personal portfolio dashboard
(`woods-financial-dashboard`) remain distinct. Star Swarm and Aurora have separate
code, histories, work reports, and releases; Firstmate is Star Swarm's development
platform, not another project to measure.

## Tool map

All of these are checked into this repository, not dependent on recovering chat.

| Tool / group | Interface and role |
| --- | --- |
| `tools/refresh_public_coordination.py` | Render shared pages; `--check` is no-write drift validation; `--observe` collects public source evidence before rendering |
| `tools/render_index.py`, `tools/render_project_suite_overview.py`, `tools/render_external_project.py` | Homepage, Markdown/HTML portfolio map, and opted-in deployed-build pages |
| `tools/check_repository_freshness.py`, `tools/observe_activity.py` | Public GitHub observations and paginated default-branch history; no private-source access |
| `tools/sync_external_status.py` | Verify and import opted-in clean deployed `build.json` identities |
| `tools/archive_provenance.py`, `tools/snapshot_archive_provenance.py` | Content fingerprints; `--check` verifies without recording a new baseline |
| `tools/private_status.py`, `tools/working_activity.py` | Approved metadata validation/rendering; working reports support `--check-file` |
| `tools/render_publications.py` | BibTeX-driven publication page |
| `tools/render_steven_sources.py`, `tools/render_steven_cv.py` | Source index/category pages and text/PostScript/PDF CV outputs |
| `tools/start_codex_on_new_mac.sh` | `install`, `setup`, `validate`, and deliberate recovery-lane equivalents |
| `tools/capture_archive_source.py`, `tools/check_archive_coverage.py` | Reviewed content-only captures with provenance sidecars; current source coverage and tracked-artifact/hash validation |
| `tools/content_inventory.py` | Versioned-file catalog, semantic text/recording/transcript inventory, checksum validation, safe text extraction and proposed update requests; see [consumer contract](CONTENT-INVENTORY-INTERFACE.md) |
| `tools/render_person_content.py`, `tools/test_person_content.py` | Committed person-registry metadata and summary freshness; semantic dates ignore metadata/formatting-only commits; daily no-write drift checks |
| `tools/test_mac_bootstrap.py`, `tools/test_archive_capture.py` | Offline installation/selection decisions, safe captures, provenance hashes and regeneration tests |
| `quack/tools/quack_research_pipeline.py` | `discover`, `fetch`, `analyze`, `classify`, `summarize`, `run`, `validate`; fetching requires deliberate network opt-in |
| `quack/tools/start-quack-codex.sh` | Project launcher and continuity entry point |
| `tools/test_repository_freshness.py`, `tools/test_activity.py`, `tools/test_private_status.py`, `tools/test_working_activity.py` | Python behavior/privacy/provenance tests |
| `tools/test_project_freshness.cjs`, `tools/test_public_index.cjs` | Browser-side freshness, card and chart logic tests through Node's test runner |

## Artifact coverage, not just Git cleanliness

October 27 discovery layer: [CONTENT-INVENTORY.md](CONTENT-INVENTORY.md) and
[`data/content/catalog.json`](data/content/catalog.json) index the whole versioned
tree, not just artifact paths declared by approved records. This is discovery and
provenance, not a claim that every file has complete text or belongs to Steven's
voice. Unreviewed transcripts and LinkedIn exports remain private and excluded.

October 26 follow-through: [the preservation register](ARCHIVE-PRESERVATION.md)
records six completed content captures from the seven-record backlog below.
Coverage is now **75/76 approved records** (Quack 6/6; Steven 21/22); LinkedIn
remains explicitly uncaptured because public access was blocked. The following
table is the original audit baseline, not the post-capture count. Use
`python3 tools/check_archive_coverage.py --check` for current checked-in coverage.

The seven archive source manifests contain 98 records, 76 approved. All **69
declared local artifact references on approved records** resolve to existing,
tracked files. A reference is not necessarily a unique file; some records can
share evidence. Archive fingerprints match their recorded provenance, and the
Quack pipeline's existing validation passes.

| Archive | Records | Approved | Approved records with a tracked local artifact |
| --- | ---: | ---: | ---: |
| Canberra | 0 | 0 | 0 |
| Google Canada | 9 | 9 | 9 |
| Inovia | 3 | 3 | 3 |
| Kinitos / NeoEdge | 32 | 24 | 24 |
| Quack | 20 | 6 | 3 |
| SEI Pittsburgh | 12 | 12 | 12 |
| Steven Woods | 22 | 22 | 18 |

Seven approved records have **no declared local-copy path**. Their metadata and
canonical URLs are saved in GitHub, but this audit cannot claim their external
content is preserved there. This is a capture/indexing backlog, not uncommitted
local work or evidence that a file has been lost:

- Quack: `src-quack-2004-en` (US6687734B1 patent).
- Quack: `src-quack-2006-us20060149633a1` (internet voice portal advertising patent).
- Quack: `src-quack-2014-jeromy-carriere` (Waterloo profile).
- Steven: `src-steven-current-inovia-team-profile`.
- Steven: `src-steven-current-linkedin-profile`.
- Steven: `src-steven-current-bio-link`.
- Steven: `src-steven-current-wikipedia-page`.

Next preservation batch: first check for already-existing captures under another
record/archive, then review capture permission, privacy, and source reliability.
Add only approved public-safe artifacts and provenance. Do not bulk mirror gated
profiles, external videos/audio, copyrighted works, or private material merely
because a URL is listed. Canberra's empty source ledger is a research-seeding gap,
not a Git backup failure.

## What a clone does not recreate automatically

- GitHub/Pages settings, authentication, Actions secrets, local CLIs, installed
  agent/plugins, runtime processes, and browser sessions are not ordinary Git
  files. Keep setup instructions and credential names in Git, not secret values.
- The current full hub workflow uses Git, Python (CI: 3.12), Node (CI: 24), `gh`,
  and `curl`; setup/archive convenience tools also use `jq` and `rg`. CV PDF
  regeneration needs Ghostscript (`gs`). Checked-in PDFs do not require it to view.
- The Mac bootstrap now installs Git/Python/jq/rg/Ghostscript and `gh`, and selects
  Node 24+ (installing keg-only `node@24` if needed). It does not force-link Node,
  alter shell profiles or authenticate GitHub. See [new-Mac setup](START-HERE-NEW-MAC.md)
  for shell PATH and sign-in. Clean-Mac installation is not yet field-tested.
- Source-owned exporters for other projects remain in their owning repositories.
  Approved hub outputs do not back up those projects' complete working data/code.
  Private repositories must remain private.
- Conversation history and machine-level memories are not automatically in this
  repo. Maintain decisions in the overview, contracts, handoffs, and relevant
  work/recovery notes rather than copying raw conversations or private logs.
- A working-activity baseline is not an installed source exporter: at this audit
  one aggregate report is present and eight software reports await their owners.

## Repeatable persistence check

Run from the repository root. Inspect before any mutation; never blindly add
ignored files, apply an old stash, or merge every historical branch.

```sh
git fetch origin
git status --short --branch
git rev-list --left-right --count HEAD...origin/main
git ls-files --others --exclude-standard
git ls-files --others --ignored --exclude-standard --directory
git branch -vv
git stash list
git log --oneline --all --not --remotes
python3 tools/test_repository_freshness.py
python3 tools/test_activity.py
python3 tools/test_private_status.py
python3 tools/test_working_activity.py
python3 tools/test_mac_bootstrap.py
python3 tools/test_archive_capture.py
python3 tools/check_archive_coverage.py --check
node --test tools/test_project_freshness.cjs tools/test_public_index.cjs
python3 tools/refresh_public_coordination.py --check
python3 tools/snapshot_archive_provenance.py --check
python3 quack/tools/quack_research_pipeline.py validate
```

On October 26 all 44 tests and the three validation commands passed. Preserve
safe local-only work either as reviewed current changes or a clearly labelled
recovery ref, then verify the ref on GitHub. Applying the recovery stash is not
part of the normal update process. Leave it untouched unless a specific historical
change needs deliberate reconciliation.

The approved follow-through adds 17 tests (9 bootstrap, 8 archive capture), for
**61 passing tests** locally. The bootstrap was syntax-checked; capture hashes,
Quack validation and generated coordination were checked. These tests do not
claim a real clean-Mac install, a new source release, or LinkedIn preservation.

To inspect the saved historical patch in a new clone:

```sh
git fetch origin
git diff origin/codex/preserved-autostash-2026-10-26^1 origin/codex/preserved-autostash-2026-10-26
```

The initial audit added the inventory and portable skill link. The approved
follow-through adds the bootstrap fix, capture/coverage tools, tests, six content
captures and their provenance; it does not install software on this Mac, sign in,
change project releases or alter private/public ownership. The LinkedIn blocker
and bio.link owner-side link repairs remain explicit in the preservation register.
