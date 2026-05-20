# Start Here On A New Mac

Updated: `2026-05-09`

This file is the portability handoff for bringing the shared `public` workspace onto a different Mac without relying on memory from the retiring MacBook.

The normal target is the preferred active clone at `~/Projects-All/public` on `main`. The older recovery lane remains available for deliberate continuity and reconciliation work, but it is not the default path.

## Preferred active clone model

For ongoing day-to-day work on the newer machine, the preferred active clone is:

- `~/Projects-All/public`

Use that clone as the default home for:

- top-level shared public navigation/reporting work
- shared-public subprojects such as `quack`, `kinitos-neoedge`, and `steven-woods-research`
- integration of published exports from standalone repos

Important distinction:

- `tools/start_codex_on_new_mac.sh setup` now bootstraps the preferred active clone
- `tools/start_codex_on_new_mac.sh setup-recovery` bootstraps the older continuity/recovery lane
- the recovery lane remains useful for continuity and reconciliation, but it is no longer the default path

If you are setting up the normal active clone, the default shape is:

```bash
mkdir -p ~/Projects-All
git clone https://github.com/sgwoods/public.git ~/Projects-All/public
```

Then open:

- `PUBLIC-OPERATING-MODEL.md`
- `PROJECT-STATE-AND-RECOVERY.md`
- `ARCHIVE_PROJECT_INTERFACE.md`
- `PUBLIC_STATUS_INTERFACE.md`

## What is safe right now

For normal day-to-day work, use `~/Projects-All/public` on `main`.

The notes below describe the optional continuity/recovery lane:

- remote branch: `codex/public-recovery-stabilization`
- canonical active local continuity workspace:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

That iCloud-backed checkout has already been validated to:

- exist on the recovery branch
- contain the current checked-in continuity and migration docs
- pass `python3 quack/tools/quack_research_pipeline.py validate`
- remain clean after validation

The older checkout on this MacBook:

- `/Users/stevenwoods/GitPages/public`

is **deprecated for active local archive work** and still contains unrelated local modifications outside the continuity lane.

## Current branch reality

At the `2026-05-07` audit point:

- `codex/public-recovery-stabilization` is `18` commits ahead of `origin/main`
- `origin/main` is `223` commits ahead of `codex/public-recovery-stabilization`

Interpretation:

- the recovery branch is the safest continuity lane
- it is not yet the same thing as “everything current on main”
- new-machine continuity should start from the recovery branch on purpose

## Verified local toolchain on the retiring MacBook

These tools were present and working during the portability audit:

- `git 2.50.1`
- `python3 3.14.2`
- `jq 1.7.1`
- `rg 15.1.0`
- `gs` / Ghostscript `10.06.0`

Those are the expected baseline tools for the bootstrap and validation path.

## Archive payload sizes from the retiring MacBook

These give a rough expectation for cloned content already tracked in git:

- `Spectra/`: about `84M`
- `steven-woods-research/`: about `4.8M`
- `quack/`: about `1.5M`
- `kinitos-neoedge/`: about `304K`

## Active-clone bootstrap path

### 1. Run the full setup script

From any checkout that already contains this script, run:

```bash
bash tools/start_codex_on_new_mac.sh setup
```

What `setup` does now:

- installs Homebrew if needed
- installs required command-line tools if missing:
  - `git`
  - `python3`
  - `jq`
  - `rg`
  - `gs`
- clones or refreshes the preferred active checkout at `~/Projects-All/public` by default
- validates the checkout until it is usable

If you want a different target location:

```bash
bash tools/start_codex_on_new_mac.sh setup "/custom/target/path"
```

### 2. Run validation again if desired

After setup completes, you can rerun validation directly from the active checkout:

```bash
bash "$HOME/Projects-All/public/tools/start_codex_on_new_mac.sh" validate
```

### 3. Open the shared-public operating notes first

Open these before doing any substantial work:

- `PUBLIC-OPERATING-MODEL.md`
- `README.md`
- `PROJECT-STATE-AND-RECOVERY.md`
- `ARCHIVE_PROJECT_INTERFACE.md`
- `PUBLIC_STATUS_INTERFACE.md`
- `quack/README.md`
- `kinitos-neoedge/README.md`

## Recovery-lane bootstrap path

Use this only when you intentionally want the continuity/reconciliation lane:

```bash
bash tools/start_codex_on_new_mac.sh setup-recovery
```

If you want to revalidate an existing recovery checkout:

```bash
bash "$HOME/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery/tools/start_codex_on_new_mac.sh" validate-recovery
```

## Sibling repos for full dashboard fidelity

The repo itself is usable without sibling repositories, but the top-level coding activity charts are more complete when these local repos are also present:

- Aurora:
  - default path: `~/Projects-All/Codex-Test1`
  - preferred override: `PUBLIC_AURORA_REPO_PATH`
  - legacy override still accepted by the start script: `PUBLIC_AURORA_REPO`
- PhD renovation:
  - default path: `~/Projects-All/phd-renovation-working`
  - preferred override: `PUBLIC_PHD_REPO_PATH`
  - legacy override still accepted by the start script: `PUBLIC_PHD_REPO`
- MMath renovation:
  - default path: `~/Projects-All/mmath-renovation-working`
  - preferred override: `PUBLIC_MMATH_REPO_PATH`
  - legacy override still accepted by the start script: `PUBLIC_MMATH_REPO`

If these paths do not exist on the new Mac, the repo remains workable. Activity charts will simply show partial or zero counts for the missing coding projects until the overrides or sibling clones are provided.

## What the start script validates

The checked-in script at `tools/start_codex_on_new_mac.sh` verifies:

- required commands exist or are installed during setup: `git`, `python3`, `jq`, `rg`, `gs`
- the checkout is on the expected branch for the selected mode:
  - `main` for `validate`
  - `codex/public-recovery-stabilization` for `validate-recovery`
- the checkout is clean
- key files for the selected mode exist
- Python entry points compile:
  - `tools/refresh_public_coordination.py`
  - `quack/tools/quack_research_pipeline.py`
  - `tools/render_index.py`
  - `tools/render_project_suite_overview.py`
  - `tools/render_publications.py`
  - `tools/render_steven_sources.py`
  - `tools/render_steven_cv.py`
- Quack archive validation passes:
  - `python3 quack/tools/quack_research_pipeline.py validate`
- sibling repo locations are reported for dashboard/chart fidelity
- the relevant branch can be compared against `origin/main` even from a single-branch clone

It was rerun successfully during this portability pass.

It also passed from a fresh remote clone on `2026-05-03`, proving that the checked-in recovery lane can recreate itself without depending on hidden state in the retiring MacBook checkout.

The current `setup` + `validate` path is intended to be the one-command bootstrap for the preferred active shared-public clone on a replacement Mac.

The `setup-recovery` + `validate-recovery` path remains the continuity-lane bootstrap when that older reconciliation workspace is still needed.

The full `setup` path was rerun successfully during the migration pass, confirming that dependency install/repair, checkout refresh, and validation can complete in one flow for the preferred active clone.

For routine shared-public coordination refreshes after manifest or portfolio-note
changes, the default one-command path is:

- `python3 tools/refresh_public_coordination.py`

Use `python3 tools/refresh_public_coordination.py --check` when you want a
no-write drift check for the generated coordination surfaces.

## What is still not fully settled

Even after portability hardening, these things are still true:

- the recovery branch has not yet been reconciled with `origin/main`
- the deprecated non-iCloud MacBook checkout still contains unrelated local edits
- not every Quack source has a local mirrored copy
- broader whole-repo continuity beyond the active recovery branch still deserves deliberate review

## Practical retirement rule for this MacBook

Before treating this MacBook as fully retired:

1. run `tools/start_codex_on_new_mac.sh setup` on the new Mac
2. run `tools/start_codex_on_new_mac.sh validate` once more if you want a second confirmation
3. open the shared-public operating notes successfully
4. confirm the new Mac's `~/Projects-All/public` checkout is clean
5. optionally run `tools/start_codex_on_new_mac.sh setup-recovery` if you still want the older continuity lane available
6. do at least one small intentional continuation step there

After that, treat this MacBook’s non-iCloud checkout as historical reference only, not the live source of truth.
