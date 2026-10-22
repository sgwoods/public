# Repository handoffs, one at a time

This is the durable coordination queue, not an instruction to run all projects
at once. Keep one handoff active; record its reply and verification here before
opening the next. Project-owned releases and confidential boundaries take priority
over making the dashboard appear newly updated.

| Order | Project | State / bounded outcome |
| --- | --- | --- |
| 1 | AI Dystopia Quotes | Ready to send: review the one source/export difference, deliberately publish only if approved, add shared freshness support. Prompt below. |
| 2 | Windigo Portfolio Portal | Awaiting handoff: establish sanitized export for existing `confidential-project` identity, verify active branch/runtime/release privately. |
| 3 | Financial Planner | Awaiting handoff: owner-reviewed sanitized export; confirm active runtime and release policy without exporting planning data. |
| 4 | Woods Financial Dashboard | Awaiting handoff: sanitized export and private discrepancy/runtime review; keep separate from the other two applications. |

AI Briefing's first export and Star Swarm's deployment notification were verified
in the October 22 audit. They do not currently need another setup prompt. Aurora
is managed on another machine and is not part of this handoff queue. MMath and PhD
freshness-template improvements can be considered after the active queue; their
source identities matched during the audit. Archive research gaps are already in
the portfolio overview and are not another cross-repository setup campaign.

## 1. AI Dystopia Quotes: prompt to send

```text
Please review and, only if approved, reconcile your public export with the portfolio hub.
Read your repository instructions, publication/review rules, working-tree state,
and release authority first. Preserve unrelated work and the private/public boundary.

The October 22 hub audit found the approved export still represents
3cbaf56f1f4aa31d01b536e747f25bbdd8c83b5c, while public main has
a0e7cc899512bdb0c3973903851387f993387b99 (cached artwork, work links,
and editorial changes). Recheck these identities; they may have advanced.
Decide whether the newer batch is actually approved for publication.
If not, retain the existing release facts and explain the remaining gate.

Read these hub interfaces before changing the exporter:
https://github.com/sgwoods/public/blob/main/PUBLIC_STATUS_INTERFACE.md
https://github.com/sgwoods/public/blob/main/PROJECT-STATUS-CONTRACT.md
https://github.com/sgwoods/public/blob/main/assets/project-freshness.js

If approved, run supported validation and export the complete approved outputs:
manifest, HTML, approved corpus, and required local artwork assets. Do not merely
advance dates or a SHA while leaving the corresponding page/data/assets behind.
Do not publish pending review material or private working records.
Record the real released clean public source commit, its committer time/ref,
and the actual export time; fail clearly if the source identity cannot be resolved.

Add the hub's shared freshness widget to the exporter-owned page template,
using the contract's exact integration and project id ai-dystopia-quotes.
Keep CSS at assets/public-site.css and the established shell/hero/panel structure.
Update your exporter, not only its generated copy, so the integration survives.

Publish only your approved allowlisted files to sgwoods/public. Do not modify
the hub index, portfolio judgments, observations, or other projects. An authenticated
export push triggers the hub workflow; if necessary use the supported post-export
notification only after publication. Verify the hub workflow and explicit Pages
build, approved corpus/artwork links, source comparison, and rendered check time.
Report source and hub commits, tests, publication result, remaining gates, and
anything requiring a hub-owned change. Do not call unapproved work released.
```

## Completion record

No source-repository handoff has been completed as part of this queue yet.
Next action: send prompt 1 to the Quotes project's owning machine, then bring its
reply back for verification. Do not mark the queue complete on a prompt alone.
