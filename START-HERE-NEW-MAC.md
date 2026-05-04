# Start Here On A New Mac

Updated: `2026-05-03`

This file is the portability handoff for bringing the `public` continuity workspace onto a different Mac without relying on memory from the retiring MacBook.

## What is safe right now

The safest current continuity state is:

- remote branch: `codex/public-recovery-stabilization`
- canonical active local continuity workspace:
  - `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`

That iCloud-backed checkout has already been validated to:

- exist on the recovery branch
- contain the current Quack continuity and workspace-status docs
- pass `python3 quack/tools/quack_research_pipeline.py validate`
- remain clean after validation

The older checkout on this MacBook:

- `/Users/stevenwoods/GitPages/public`

is **deprecated for active local archive work** and still contains unrelated local modifications outside the continuity lane.

## Current branch reality

At this audit point:

- `codex/public-recovery-stabilization` is `17` commits ahead of `origin/main`
- `origin/main` is `216` commits ahead of `codex/public-recovery-stabilization`

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

## New-Mac bootstrap path

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
- clones or refreshes the continuity checkout in the canonical iCloud-backed path
- validates the checkout until it is usable

If you want a different target location:

```bash
bash tools/start_codex_on_new_mac.sh setup "/custom/target/path"
```

### 2. Run validation again if desired

After setup completes, you can rerun validation directly from the canonical checkout:

```bash
bash "$HOME/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery/tools/start_codex_on_new_mac.sh" validate
```

### 3. Open the continuity notes first

Open these before doing any substantial work:

- `PROJECT-STATE-AND-RECOVERY.md`
- `LOCAL-WORKTREE-STATUS.md`
- `quack/PROJECT-STATE-AND-RECOVERY.md`
- `quack/WORKSPACE-STATUS.md`
- `kinitos-neoedge/WORKSPACE-STATUS.md`

## Sibling repos for full dashboard fidelity

The repo itself is usable without sibling repositories, but the top-level coding activity charts are more complete when these local repos are also present:

- Aurora:
  - default path: `/Users/stevenwoods/Documents/Codex-Test1`
  - override: `PUBLIC_AURORA_REPO`
- PhD renovation:
  - default path: `/Users/stevenwoods/phd-renovation`
  - override: `PUBLIC_PHD_REPO`
- MMath renovation:
  - default path: `/Users/stevenwoods/mmath-renovation`
  - override: `PUBLIC_MMATH_REPO`

If these paths do not exist on the new Mac, the repo remains workable. Activity charts will simply show partial or zero counts for the missing coding projects until the overrides or sibling clones are provided.

## What the start script validates

The checked-in script at `tools/start_codex_on_new_mac.sh` verifies:

- required commands exist or are installed during setup: `git`, `python3`, `jq`, `rg`, `gs`
- the checkout is on `codex/public-recovery-stabilization`
- the checkout is clean
- key continuity files exist
- Python entry points compile:
  - `quack/tools/quack_research_pipeline.py`
  - `tools/render_index.py`
  - `tools/render_publications.py`
  - `tools/render_steven_sources.py`
  - `tools/render_steven_cv.py`
- Quack archive validation passes:
  - `python3 quack/tools/quack_research_pipeline.py validate`
- sibling repo locations are reported for dashboard/chart fidelity
- the recovery branch can be compared against `origin/main` even from a single-branch clone

It was rerun successfully against the canonical iCloud-backed checkout during this portability pass.

It also passed from a fresh remote clone on `2026-05-03`, proving that the checked-in recovery lane can recreate itself without depending on hidden state in the retiring MacBook checkout.

The current `setup` + `validate` path is intended to be the one-command bootstrap for a replacement Mac.

The full `setup` path was rerun successfully against the canonical iCloud-backed checkout on `2026-05-04`, confirming that dependency install/repair, checkout refresh, and validation can complete in one flow.

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
3. open the continuity notes successfully
4. confirm the new Mac’s iCloud-backed checkout is clean
5. do at least one small intentional continuation step there

After that, treat this MacBook’s non-iCloud checkout as historical reference only, not the live source of truth.
