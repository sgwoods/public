# Old Machine Closeout 2026-05-16

## Purpose

This note records the final `public`-repo closeout from the deprecated old machine
at `/Users/stevenwoods/GitPages/public`.

The operational conclusion is:

- there were no unique archive commits left on the old machine
- active archive work must continue only from `/Users/steven/Projects-All/public`
- the old machine is deprecated for active `public` archive work

## Preserved evidence bundle

The old machine produced a non-archive closeout tarball that was copied to the
canonical machine and unpacked for read-only triage.

- tarball path at triage time:
  - `/Users/steven/Desktop/public-old-machine-closeout-2026-05-16.tgz`
- tarball size:
  - `1242230` bytes
- tarball SHA-256:
  - `6819b3d1b0d9c619225286ab75c8d86c95fc37d2df22e255ec4ffae85cecd65a`

## Triage conclusion

The tarball was compared against:

- current `origin/main`
- the canonical working repo at `/Users/steven/Projects-All/public`

Result:

- the tarball did preserve real old-machine-only non-archive variants
- but those variants were mostly older or transitional versions, not newer
  canonical truth
- no tarball files were imported directly into this closeout branch in this pass

## Already safe in canonical repo

These were confirmed already safe without further action:

- `phd-renovation-thesis.ps`
  - byte-identical between tarball and canonical repo
- `ARCHIVE_PROJECT_INTERFACE.md`
  - tarball copy matched `origin/main`

## Tarball-only evidence retained outside git

These remain worth keeping as evidence, but were not imported directly:

- `steven-woods-cv-20260503-124649.pdf`
  - exists only in the tarball
  - appears to be a timestamped generated CV artifact from
    `tools/render_steven_cv.py`
  - extracted text matched both the tarball `steven-woods-cv.pdf` and the
    current canonical `steven-woods-cv.pdf`, so there is no evidence yet of
    unique semantic content

## Files that had old-machine-only variants

These differed from `origin/main`, but the current old-machine copy was not
promoted automatically because the tarball variants looked older, transitional,
or otherwise ambiguous:

- `PROJECT-STATE-AND-RECOVERY.md`
- `PUBLIC_STATUS_INTERFACE.md`
- `README.md`
- `START-HERE-NEW-MAC.md`
- `PUBLIC-OPERATING-MODEL.md`
- `tools/start_codex_on_new_mac.sh`
- `ai-dystopia-quotes.html`
- `data/ai-dystopia-quotes.approved.json`
- `data/projects/ai-dystopia-quotes.json`
- `data/projects/mmath-renovation.json`
- `data/projects/phd-renovation.json`
- `index.html`
- `phd-renovation-dashboard.html`
- `phd-renovation-handbook.html`
- `phd-renovation.html`
- `steven-woods-cv.pdf`

## Special handling notes

### README and homepage

`README.md` and `index.html` need explicit later review because:

- the tarball had old-machine variants
- the canonical machine also currently has separate unpublished local changes

Those should be handled as a deliberate three-way review, not by automatically
taking either side.

### Archive-gap search outside git

The tarball docs referenced additional historical continuity locations on the
old machine, including:

- `~/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery`
- `~/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public`

Because several archive families still have preservation-depth gaps, a final
read-only search of those locations was judged worthwhile before old-machine
retirement.

## Recommended next steps

1. Keep the tarball outside the live repo until all desired imports are decided.
2. Review `README.md` and `index.html` explicitly against:
   - `origin/main`
   - current canonical local edits
   - the tarball variants
3. If any tarball-held non-archive variants still prove useful, import them in
   small grouped commits from a clean branch based on current `origin/main`.
4. Treat the old machine as retired for active archive work once external search
   and any final evidence transfer are done.
