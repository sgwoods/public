# iMac Consumer Handoff

Published interface owner: `sgwoods/public`. Reviewed October 27, 2026.

## Ownership

This public-record maintainer is the only effort maintaining the public-information
projects. It owns gathering and verification, private transcript production and
review, safe exports, source manifests, indexes, inventory and publication.
The iMac is a **consumer and requestor**, not a second archive maintainer.
This replaces earlier instructions asking the iMac to produce transcripts or
assemble new source material for this archive.

Raw/unreviewed transcripts, LinkedIn exports, account data and credentials remain
outside every public checkout and public Git branch. A review branch is public.
Existing private consumer work remains private; do not upload it to demonstrate a gap.

## Prompt To Continue On The iMac

You consume Steven Woods' approved public record. Do not gather new sources,
produce transcripts for the public record, change public manifests/indexes or
publish anything. Send missing-content and freshness requests back to the
`sgwoods/public` maintainer for execution and review.

1. Find your existing public clone and inspect its branch and dirty state. Fetch
   `origin/main`; fast-forward only a clean matching checkout. Never reset,
   overwrite local work or silently switch an unrelated project. Use published
   `main`, not the former content-inventory review branch.
2. Read `CONTENT-INVENTORY-INTERFACE.md` and `data/content/catalog.json`.
   Pin the checkout or downloads to one commit. Verify `outputs_sha256` before
   combining catalog, sources and artifacts. In a clone run:
   `python3 tools/content_inventory.py check`.
3. Read `data/content/sources.json` for source identities, text roles, recording
   links, transcript availability, attribution limits and per-source external
   verification. Read `artifacts.jsonl` for every versioned path and checksum.
   Git content dates are not publication or external verification dates.
4. Consume already-approved public content as data in your existing private
   application. The inventory's `text --path <root-relative-file>` command can
   extract existing HTML/text to stdout after hash validation. Keep derived
   private consumer data outside this public checkout. Do not execute archived
   source code or unpack unknown archives. Audio is not a transcript; metadata
   approval is not speaker verification or approval for voice/style use.
5. Evaluate proposed gaps with
   `python3 tools/content_inventory.py requests --as-of YYYY-MM-DD`.
   This prints JSON and sends nothing. Deduplicate stable request IDs in your
   own private request tracker. Do not run inventory `build`, curate manifests
   or maintain a parallel catalog as part of consumer work.
6. Return a public-safe request packet to Steven for this maintainer. Include the
   catalog digest, pinned public commit, content/request IDs, desired deliverable,
   reason, priority and public evidence. Ask this maintainer to recover prior
   private work before repeating transcript production. Never attach private
   transcripts, LinkedIn exports, personal paths, secrets or account screenshots.
7. Reconsume the published result only after the maintainer supplies the new
   commit/catalog digest and identifies reviewed artifacts. A merged commit is
   not by itself proof that Pages has finished deploying.

Request packet example (not sent automatically):

```json
{
  "schema_version": "1.0",
  "target": "sgwoods/public_maintainer",
  "catalog_source_tree_sha256": "<catalog source_tree_sha256>",
  "public_commit": "<pinned sgwoods/public commit>",
  "request_id": "<existing stable ID, if present>",
  "content_id": "steven-woods-research/src-steven-2023-riddick-show",
  "requested_deliverable": "Reviewed transcript availability and a safe derivative if approved",
  "reason": "The consumer needs source-faithful interview text; only recording metadata is indexed",
  "priority": "normal",
  "public_evidence": ["steven-woods-research/source-manifest.json"],
  "state": "requested",
  "privacy": "No unreviewed transcript or private export attached"
}
```

The generated queue retains `proposed_not_sent`; the packet above is a consumer
handoff, not a change to that queue's state/schema. Deliver it through Steven's
approved channel, not by automatically opening an issue or messaging a chat.

## Known Boundaries

- Riddick private ASR production is tracked in the catalog's production reports.
  No reviewed public transcript is claimed. Do not retranscribe on the consumer
  machine; request a reviewed derivative from this maintainer instead.
- The Springboard Q&A has public text, not a verified style corpus.
- Papers can have co-authors and alternate editions; preserve attribution.
- SlideShare needs subject-identity verification before quotation or style use.
- LinkedIn public access is blocked. Never use cookies/account UI or place a raw
  LinkedIn export in this repo.
- If a consumer refers to a missing candidate batch, return sanitized IDs/URLs
  and the desired review; do not claim the maintainer already received it.
- Historical papers/talks do not expire just because they are old. Current-profile
  review windows use successful external check dates, not daily render dates.

## Maintainer Response

This workspace triages the request and records accepted/in-progress/blocked/
resolved work with evidence in its work plan or reviewed ledger. Content
production that needs private staging stays in a maintainer-controlled private
location. Only explicitly reviewed public-safe derivatives can be committed.
The maintainer updates curation, registry provenance, indexes and inventory,
publishes, and returns the resulting commit and catalog digest to the consumer.
