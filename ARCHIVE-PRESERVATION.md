# Archive Preservation Register

Checked October 26, 2026. This is a preservation checkpoint, not a new biography,
release, source-approval decision, or verification of every claim in the sources.

## Seven-record batch

The persistence audit found seven approved records without declared local copies.
Six now have attributed, inert text-and-link captures. All original source IDs,
approval labels, ownership, canonical URLs, and historical/review dates are kept.
Capture dates are separate. The seventh remains explicitly uncaptured.

| Owning archive / source | Result and retained artifact | Limits / next action |
| --- | --- | --- |
| Quack / `src-quack-2004-en` | [US6687734B1 capture](quack/historic/artifacts/archive-html/us6687734b1-2026-10-26.html), [provenance](quack/historic/artifacts/archive-html/us6687734b1-2026-10-26.html.capture.json); public HTTP response | Text, claims, bibliographic data and reference URLs from the [canonical patent page](https://patents.google.com/patent/US6687734B1/en); drawings/PDF not copied. Legal-status labels remain the source's unverified labels. |
| Quack / `src-quack-2006-us20060149633a1` | [US20060149633A1 capture](quack/historic/artifacts/archive-html/us20060149633a1-2026-10-26.html), [provenance](quack/historic/artifacts/archive-html/us20060149633a1-2026-10-26.html.capture.json); public HTTP response | Text, claims, bibliographic data and reference URLs from the [canonical patent page](https://patents.google.com/patent/US20060149633A1); drawings/PDF not copied. No new legal or inventorship conclusions. |
| Quack / `src-quack-2014-jeromy-carriere` | [Waterloo profile capture](quack/historic/artifacts/archive-html/uwaterloo-jeromy-carriere-2026-10-26.html), [provenance](quack/historic/artifacts/archive-html/uwaterloo-jeromy-carriere-2026-10-26.html.capture.json); public HTTP response | [Institutional source](https://uwaterloo.ca/math/profiles/jeromy-carriere) text, not an assertion that the older job description is still current. Original 2014 source-date precision retained. |
| Steven / `src-steven-current-inovia-team-profile` | [Inovia biography capture](steven-woods-research/historic/artifacts/archive-html/inovia-team-steve-woods-2026-10-26.html), [provenance](steven-woods-research/historic/artifacts/archive-html/inovia-team-steve-woods-2026-10-26.html.capture.json); public-browser transcription | The [old profile URL](https://www.inovia.vc/team/steve-woods/) now redirects to a [team modal](https://www.inovia.vc/team?person=Steve%20Woods). HTTP client returned 429; normal public browser exposed the biography. Biography only, not the team grid, investment list, images or site code. |
| Steven / `src-steven-current-linkedin-profile` | **Blocked, no local content capture**; [canonical URL](https://www.linkedin.com/in/stevenwoods/) retained in the manifest | Public read returned HTTP 999. The available browser opened an authenticated owner view, not a verified public view, so it was closed without capture. Do not save account UI, a login/challenge page, or infer content from another source. Next: user-approved public-only profile export, or an ordinary public-access retry. Exclude messages, connections, private contacts, credentials and account exports. |
| Steven / `src-steven-current-bio-link` | [bio.link capture](steven-woods-research/historic/artifacts/archive-html/bio-link-sgwoods-2026-10-26.html), [provenance](steven-woods-research/historic/artifacts/archive-html/bio-link-sgwoods-2026-10-26.html.capture.json); public-browser transcription | [Source](https://bio.link/sgwoods): displayed headings, expanded Short Bio and link map; not a raw DOM/HTML export. HTTP client returned 403; ordinary browser access worked. Instagram and AngelList destinations contain malformed concatenations; Bluesky points at a CDN hostname. Owner should repair these on bio.link, not silently rewrite archival evidence here. |
| Steven / `src-steven-current-wikipedia-page` | [Wikipedia capture](steven-woods-research/historic/artifacts/archive-html/wikipedia-steven-woods-2026-10-26.html), [provenance](steven-woods-research/historic/artifacts/archive-html/wikipedia-steven-woods-2026-10-26.html.capture.json); public HTTP response | [Revision 1368795449](https://en.wikipedia.org/w/index.php?title=Steven_Woods&oldid=1368795449) identified by the retrieved page. Contributor attribution, history and CC BY-SA 4.0 retained. Secondary synthesis, not primary authority; images omitted. |

## Coverage

Across the seven source manifests: **98 records, 76 approved, 75 approved records
with declared local artifacts**, up from 69. Quack is now 6/6 approved records
with copies (8 local paths across all 20 records); Steven is 21/22. Other archives
are unchanged. These are record/reference counts, not unique files or a guarantee
of complete multimedia preservation. Some older artifacts are themselves excerpts
or metadata captures. Fingerprint agreement alone does not prove completeness.

The Quack lead registry and generated source manifest both carry the three new
paths, so regenerating from existing reviewed analysis does not erase them. The
Quack page's approved-copy metric is now calculated rather than hard-coded.
The Steven profile index links its three new captures and exposes the LinkedIn
blocker in the source notes. No other project's repository was edited.

## Repeatable Process

1. Run `python3 tools/check_archive_coverage.py` to list counts, uncaptured IDs and
   any declared-copy errors. Review existing files and canonical ownership before
   downloading or creating duplicates.
2. Use normal public access only. On a login, rate-limit or challenge response,
   stop that route. A browser-visible public profile can be explicitly
   transcribed; never call a transcription an original page capture.
3. Fetch reviewed HTML with `curl --fail --location --silent --show-error
   --max-time 45 URL -o /tmp/reviewed-source.html`. Inspect its content before
   promotion. Keep raw session-bearing HTML out of Git.
4. Use `tools/capture_archive_source.py` with an explicit source, retrieval URL,
   checked date, selector, expected evidence and rights/attribution note. The tool
   produces escaped text-and-URL HTML plus a hash/provenance sidecar. It does not
   fetch, approve sources, bypass access controls, or silently overwrite captures.
5. Review the output. Add only real content copies to `urls.archive_local`; leave
   blocked records null and document a safe next action. Update Quack's owning
   lead `fetch.archive_local` and `analysis.archive_local` together. Preserve
   source dates and IDs; do not run automatic reclassification for this purpose.
6. Rerender affected pages, test and stage reviewed files. Run
   `python3 tools/check_archive_coverage.py --check` after staging; untracked or
   missing declared artifacts and mismatched capture hashes fail, but an honestly
   uncaptured source remains a reported backlog rather than a broken build.
7. Commit archive content before `python3 tools/snapshot_archive_provenance.py`.
   That records actual committed content, never today's date as an invented source
   revision. Refresh hub coordination, commit resulting metadata, push and request
   a Pages build explicitly. Keep credentials and private data out of all steps.

Example after independently fetching and reviewing an allowed source:

```sh
python3 tools/capture_archive_source.py \
  --input /tmp/reviewed-source.html \
  --output owning-archive/historic/artifacts/archive-html/source-YYYY-MM-DD.html \
  --title 'Exact reviewed source title' \
  --source-url https://example.org/original \
  --retrieved-url https://example.org/final \
  --checked-on YYYY-MM-DD --tag article \
  --expect 'Known identifying source text' \
  --license-note 'Attribution, rights and scope reviewed for this source.'
```

Use `--attribute class --value content-class` (or `id`) if the region is not a
unique tag. For a visible public-browser transcription, use
`--method public-browser-transcription` and describe precisely what was included.
Input hashes identify the reviewed input supplied to the tool, not necessarily
the original server response. Raw temporary inputs are not required for browsing
the checked-in captures and are not claimed as preserved byte-for-byte evidence.

## Verification Scope

Offline regression tests cover bootstrap selection/installation decisions,
capture sanitization, selectors, required evidence, dates, hashes and Quack
regeneration/counting. No clean-Mac installation or GitHub sign-in is simulated as
proven. Local checks and remote workflow outcomes belong in the commit handoff.
