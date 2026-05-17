# Old Machine Closeout 2026-05-16

## Purpose

This note records the final `public`-repo closeout from the deprecated old
machine workspace at `/Users/stevenwoods/GitPages/public`.

The operational conclusion is:

- there were no unique archive commits left on the old machine
- active archive work must continue only from `/Users/steven/Projects-All/public`
- the old machine is deprecated for active `public` archive work

## Preserved evidence bundles

The old machine produced two tarballs that were copied to the canonical
machine:

- non-archive closeout bundle:
  - `/Users/steven/Desktop/public-old-machine-closeout-2026-05-16.tgz`
  - SHA-256:
    `6819b3d1b0d9c619225286ab75c8d86c95fc37d2df22e255ec4ffae85cecd65a`
- archive-gap candidate bundle:
  - `/Users/steven/Desktop/archive-gap-candidates-2026-05-16.tgz`
  - SHA-256:
    `e3f87183bccd1a7d7fd3701476f6a530e18ac19dca1e41b322f113b5fa477d5a`

The archive-gap bundle was verified as a real Kinitos-era first-party evidence
set. The raw XML remains quarantined outside git, and only sanitized repo-safe
derivatives should enter the public repo.

## Triage conclusion

The non-archive tarball was compared against:

- current `origin/main`
- the canonical working repo at `/Users/steven/Projects-All/public`

Result:

- the tarball did preserve real old-machine-only non-archive variants
- those variants were mostly older or transitional versions, not newer
  canonical truth
- no tarball files were imported directly as raw closeout payload in this pass

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
promoted automatically because the tarball variants looked older,
transitional, or otherwise ambiguous:

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

`README.md` and `index.html` required explicit review because:

- the tarball had old-machine variants
- the canonical machine also had separate unpublished local changes

Those were handled as deliberate canonical-machine edits rather than by taking
the tarball versions wholesale.

### Archive-gap search outside git

The final old-machine search did find one high-value off-repo recovery set:

- Kinitos-era MSN XML logs from `Documents`

Those logs were accessioned and verified on the canonical machine, but they
remain outside git as private raw evidence. Repo-safe derivative notes now
drive the public corroboration workflow instead.

## Current rule

Use this note as the durable record that:

- `/Users/steven/Projects-All/public` is the canonical active shared-public
  clone
- `/Users/stevenwoods/GitPages/public` is retired for active work
- old-machine tarballs are evidence bundles, not alternate sources of truth
