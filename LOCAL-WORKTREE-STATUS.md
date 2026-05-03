# Local Worktree Status

Updated: 2026-05-03

This file exists so a future machine or operator does not have to infer which checkout is current.

## Deprecated local checkout

This checkout:

- `/Users/stevenwoods/GitPages/public`

should be treated as deprecated and transitional.

Use it only to:

- inspect older local state
- compare against the iCloud-backed workspaces
- bridge continuity work until retirement of this MacBook is complete

Do not use it as the default place for new local-only work.

At the time of this note, it also still contains active parallel-project modifications that are intentionally outside the continuity lane, including work in:

- `ai-dystopia-quotes`
- `phd-renovation`
- `mmath-renovation`
- some derived top-level files such as `index.html` and `steven-woods-cv.pdf`

Treat those as active project surfaces, not portability truth.

## Current iCloud-backed workspaces on the old machine

General public workspace:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`
- branch: `main`
- currently clean at the time of this note

Recovery/archive workspace:

- `/Users/stevenwoods/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- branch: `codex/public-recovery-stabilization`
- used for continuity and archive-hardening work
- validated as the canonical continuity workspace for bootstrapping a replacement Mac

## Practical rule

On a new Mac, the intended direction is:

- use only iCloud-backed checkouts for active work
- re-create the needed workspaces there
- retire this deprecated non-iCloud checkout after validation succeeds

Recommended bootstrap surfaces:

- `START-HERE-NEW-MAC.md`
- `tools/start_codex_on_new_mac.sh`
