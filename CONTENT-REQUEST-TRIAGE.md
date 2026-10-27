# Content Request Triage

Current cycle: [Text-first recovery and review gates](CONTENT-TEXT-RECOVERY.md).

Generated from `data/content/request-triage.json`; change that reviewed decision register, not this report.

Reviewed: **2026-10-27**. Baseline: **57 signals**, pinned to `68b94d9b7178a5e2a9a248a2ac7d804d2ef74f8d`.

**26 deferred**; **1 in progress**; **1 quarantined**; **22 ready**; **7 resolved**.

Text-first recovery and parallel work approved by Steven. No existing private transcript is known; local Riddick ASR production is tracked separately and is not a reviewed/public transcript. Three private paper-reading copies were produced. A wrong-speaker video association was removed, a short promo/date misclassification corrected, and the 2017 joint presentation verified. Search-only outreach policy and LinkedIn deferral are explicit. Source approval/release labels remain unchanged; no raw transcript or reading text is published.

This is a dated triage, not a daily re-review or a claim that all gaps are closed. New signals and reopened resolutions are reported by `python3 tools/triage_content_requests.py status`. The generated signal queue remains separate.

## Decisions For Steven

Recommendations below are not submitted answers. Return private locations privately, not in a GitHub issue or this register.

### Q1: Recover existing private interview work

Is any transcript or diarized text already available for Riddick 2023, Waterloo Entrepreneurship and Impact 2023, Research Discovery Days 2023, or the 2017 Woods/Friesen presentation? Tell this maintainer where existing private work can be found, privately; otherwise say none known.

Recommendation: **Recover prior private work first; if none exists, begin with Riddick after agreeing a private staging location.**

Options: Existing private work exists; provide its location privately; None known; plan new private Riddick transcription; Defer transcript work.

Blocks: Private recovery/transcription work for four talks; not public indexing of their known metadata. Answer state: `answered`.

Recorded direction: **No prior private transcript is known. Steven authorizes regenerating Riddick locally from the publisher's public audio; no unreviewed transcript publication is authorized.**

### Q2: Choose the next bounded work cycle

Which outcome is worth the next maintenance cycle: usable interview/research text, or broader patent and company-press preservation?

Recommendation: **Readable text first: a 90-minute discovery/edition-review pass, then the private Riddick lane once Q1 is answered. No paid access or model spending is authorized by this estimate.**

Options: Interview/research text first; Patent and company-history preservation first; Pause new gathering; maintain current evidence only.

Blocks: Reprioritization and starting a new production batch, not this completed triage. Answer state: `answered`.

Recorded direction: **Proceed text-first with bounded paper/edition work and maximize independent parallel tasks. Commit safe code, evidence, documentation and index updates at each major cycle.**

### Q3: Confirm or exclude the 2012 deck

Is the September 25, 2012 Road to Revenue / Buying and Selling presentation uploaded by Increase A/S actually yours? It may be a namesake; the evidence does not establish attribution.

Recommendation: **Keep it quarantined and excluded from quotes, biography claims and style use. If it is not yours, explicitly reject it in the next reviewed source update.**

Options: Not mine; remove it from approved personal sources; Mine; supply event/identity confirmation; Unsure; keep quarantined.

Blocks: Any attribution or use of the deck as Steven Gregory Woods' work. Answer state: `awaiting_user`.

### Q4: Organizer outreach

If bounded public searching cannot find a recording, should we contact CS-CAN, Waterloo Mathematics or USask about the three missing-recording talks?

Recommendation: **No messages yet. Use public research first; Steven can approve individual unsent drafts and choose the sender/channel later.**

Options: Public research only; no outreach; Approve one draft at a time after reviewing sender/channel; I will contact organizers myself.

Blocks: Sending the organizer drafts, not continuing ordinary public searching. Answer state: `answered`.

Recorded direction: **Public searching only. Preserve official future outreach routes and draft questions, but do not contact organizers.**

### Q5: LinkedIn access boundary

Should the LinkedIn record stay explicitly blocked, or will you provide a sanitized public-profile-only subset for private review? Do not place raw exports or private account data in a public branch.

Recommendation: **Leave blocked unless the public-profile content adds unique value. Employer/institutional sources already provide alternatives.**

Options: Leave blocked and use alternative public sources; Provide a sanitized public-only subset privately; Revisit later.

Blocks: LinkedIn capture/review only; no other archive work. Answer state: `answered`.

Recorded direction: **Leave LinkedIn explicitly blocked for now. Manual public-only content or other permitted strategies can be considered later; no raw export intake or authenticated scraping is authorized.**

## Ranked Work Batches

Effort ranges are rough maintainer planning estimates, not measured duration, spending approval or a promise. Stop at the stated gate rather than expanding a blocked search.

### 0. Completed verification and copy-discovery fixes

7 baseline signals. Six initial evidence/copy fixes plus a false transcript association resolved; not seven newly produced transcripts.

Effort: Completed in this triage cycle; no measured duration claimed. Next: Retain evidence and source-owned approval states; distinguish corrected association from transcript availability.

Stop gate: Do not treat a text-only patent copy as drawings or a daily inventory render as an external check.

### 1. Identity guard before attribution

1 baseline signal. Prevents namesake material entering the personal record.

Effort: User confirmation, then approximately 10-20 minutes to reconcile reviewed source metadata. Next: Await Q3; retain the quarantine and identity warning.

Stop gate: No quotation, style extraction or biography attribution without primary identity evidence.

### 2. Private interview production and verified media

3 baseline signals. Highest likely value for source-faithful first-person content; Riddick is the first candidate.

Effort: Recovery triage approximately 15-30 minutes once a private location is supplied; fresh processing and speaker review require a separate estimate after inspecting the roughly 85-minute Riddick recording. Next: Riddick local ASR is underway; review before any usable export. Keep other media identities/durations distinct; do not transcribe an unrelated speaker.

Stop gate: No raw ASR text, private paths or speaker/style approval enters the public repository.

### 3. Local author-form editions checked

2 baseline signals. Existing SEI-hosted papers may avoid redundant downloads while preserving publication-version accuracy.

Effort: Approximately 20-45 minutes total for metadata/page/edition comparison; not a full scholarly review. Next: Use the private reading copies with edition caveats; keep exact proceedings availability unresolved without repeating this completed comparison.

Stop gate: A matching title/authors is not proof of the exact proceedings edition.

### 4. Three core research-paper recovery leads

3 baseline signals. More useful text than indiscriminate profile or patent coverage if the consumer's priority is research.

Effort: Approximately 45-90 minutes for a bounded public/author-repository search. Next: Review the recovered private discipline manuscript. Keep tradeoff's author discrepancy and matching's full-text gap explicit; no paywall bypass or outreach.

Stop gate: Stop on paywall/access controls or uncertain edition; metadata-only is preferable to a false full-text claim.

### 5. Three recording or slides searches

4 baseline signals. Clarifies whether historical talk listings can yield usable content.

Effort: At most 15-20 minutes per talk before reviewing whether outreach is worthwhile. Next: Public searches completed without verified recordings; preserve official future contact routes and drafts, no messages.

Stop gate: No messages sent, and failure to find a recording is not proof it never existed.

### 6. Fifteen missing patent-text captures

15 baseline signals. Good for completeness and inventor/company history; lower immediate value for personal speaking/writing material.

Effort: Approximately 2-4 hours for all fifteen with reviewed identity, content-only capture and provenance; begin with two, not all fifteen. Next: After Q2, capture two exact-number public patent pages, preserving co-inventors, application/grant versions and limitations.

Stop gate: No paywall bypass or bulk promotion; text-only captures do not contain all diagrams or establish legal status.

### 7. Four selective company-history leads

4 baseline signals. Potentially useful acquisition, startup-profile and Kinitos product context; original source statuses stay deferred/ledger-only.

Effort: Approximately 45-90 minutes for initial access/identity review, not guaranteed capture completion. Next: Prioritize TheStreet/eCommerceTimes acquisition coverage, the older startup profile and InfoWorld Kinitos article; review before promotion.

Stop gate: Do not pay, bypass access controls, contact publishers or duplicate an equivalent approved source without a deliberate next step.

### 8. Fifteen lower-priority deferred sources

15 baseline signals. Often redundant news, secondary profiles/funding databases or restricted case material; not an approved-source emergency.

Effort: No work scheduled; 15-minute usefulness/access check per candidate only when a concrete claim needs it. Next: Keep metadata and source-owned deferred labels. Revisit only for a specific coverage gap.

Stop gate: No blanket fetching, subscriptions, purchases or treating all deferred records as preservation failures.

### 9. Book and editorial-preface references

2 baseline signals. Retain citations; full-book republication and a short editorial are not automatically worth acquisition effort.

Effort: No full-text acquisition scheduled. Next: Keep bibliographic links; seek a permitted author edition only if a specific consumer need justifies it.

Stop gate: No book purchase, copyrighted full-text republication or model-training/style approval inferred.

### 10. LinkedIn remains blocked

1 baseline signal. Optional completeness, not a blocker for the public record as a whole.

Effort: No work unless Q5 changes the direction. Next: User explicitly chose continued blocked/deferred status; consider a manual public-only subset later if useful.

Stop gate: No authenticated scraping, cookies, account UI capture or public raw export.

### 11. Legacy welcome WAV

1 baseline signal. Low incremental value until speaker identity and intended use are established.

Effort: Defer; approximately 10-20 minutes for private identity/duration review if later justified. Next: Retain the public file as bytes, not a verified Steven transcript or voice sample.

Stop gate: Do not spend transcription/review effort or infer speaker identity from its filename.

## Unsent Organizer Questions

Drafts only. No recipient has been contacted, no private artifact attached and no contact detail inferred. Steven must approve outreach and its sender/channel first.

### D1: CS-CAN / INFOCAN event organizer

We are maintaining Steven Woods' public record. Is a public recording, slide deck or published summary available for Models of University/Industry Collaboration - What Works and What Doesn't? We have the event listing, but no exact recording URL. A public link or confirmation of availability would help us label the archive accurately.

Future official routes (unsent): [Contact page](https://cscan-infocan.ca/contact-us/)

### D2: University of Waterloo Mathematics event organizer

We are maintaining Steven Woods' public record. Is a public recording or slide deck available for The entrepreneurial computer scientist, held January 20, 2021? We have located the specific official event page, but no recording. Please share a public link or clarify whether only the event listing remains available.

Future official routes (unsent): [Contact page](https://uwaterloo.ca/math/about/contact-us); [Contact page](https://uwaterloo.ca/math-innovation/about/contact-information)

### D3: University of Saskatchewan Computer Science lecture archivist

We are maintaining Steven Woods' public record. Does the department hold a shareable recording, slide deck or published text from his 2003 P.G. Sorenson lecture while CEO of Kinitos? We have the official lecture listing. We seek only a permitted public reference, not private archives or personal contact information.

Future official routes (unsent): [Contact page](https://www.cs.usask.ca/about/contact-us.php)

## Every Baseline Request

Source approval/status is unchanged. A reused capture resolves a copy-discovery signal, not authorship, republication permission, exact-edition review or voice approval.

| Request / Source | Original Signal | Disposition | Evidence / Next Action |
| --- | --- | --- | --- |
| `fbe3c4d81193d47f74c5` / System and method for determining if one web site has the same information as another web site (`publication:sellink2004sameinformation`) | local_content_gap | resolved / completed | Associate the existing capture of exact patent US6687734B1 as local content. This resolves discovery of text, not missing drawings/PDF or publication rights. Evidence: [us6687734b1-2026-10-26.html](quack/historic/artifacts/archive-html/us6687734b1-2026-10-26.html); [us6687734b1-2026-10-26.html.capture.json](quack/historic/artifacts/archive-html/us6687734b1-2026-10-26.html.capture.json) |
| `39d710fa8a89fcf66f5a` / SEI Architecture Practices Propel Successful Startup (`quack/src-quack-2002-feature11q02-cfm`) | local_content_gap | resolved / completed | Reuse the preserved SEI newsletter article (PDF page 26, printed page 22), reviewed by title/byline. Do not promote the deferred Quack source status. Evidence: [sei-architecture-practices-propel-successful-startup-2002.pdf](sei-pittsburgh-research/historic/artifacts/archive-pdf/sei-architecture-practices-propel-successful-startup-2002.pdf) |
| `a2e82985207409ef3ba9` / Steven Woods (`quack/src-quack-2026-steven-woods`) | local_content_gap | resolved / completed | Reuse the person archive's capture of the exact Wikipedia canonical URL, revision 1368795449. Keep attribution/license and deferred source status. Evidence: [wikipedia-steven-woods-2026-10-26.html](steven-woods-research/historic/artifacts/archive-html/wikipedia-steven-woods-2026-10-26.html) |
| `6bbd8bfbae86755e6713` / Jeromy Carriere (`sei-pittsburgh-research/src-sei-current-jeromy-carriere-author-profile`) | external_check_unknown | resolved / completed | Public SEI alumni profile and identity reviewed October 27; retain the existing capture. Evidence: [2026-10-27.json](data/content/checks/2026-10-27.json) |
| `f5d1564b491f3d8eff9f` / Steve Woods (`sei-pittsburgh-research/src-sei-current-steve-woods-author-profile`) | external_check_unknown | resolved / completed | Public SEI alumni profile and historical publication listing reviewed October 27; retain the existing capture. Evidence: [2026-10-27.json](data/content/checks/2026-10-27.json) |
| `9f829d3f98508bf0ce3c` / Entrepreneurship and Impact Series - April 2023, Steven Woods (`steven-woods-research/src-steven-2023-uwaterloo-entrepreneurship-impact`) | transcript_gap | resolved / completed | The original transcript signal depended on a Natalie Gordon video incorrectly assigned to Steven. Remove that association, not treat it as a completed Steven transcript. The newly identified missing-recording signal is explicitly tracked as a follow-up. Evidence: [uwaterloo-entrepreneurship-impact-series.html](steven-woods-research/historic/artifacts/archive-html/uwaterloo-entrepreneurship-impact-series.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `95bda0ae5d4e9ac7e793` / Steven Woods on about.me (`steven-woods-research/src-steven-current-about-me-profile`) | external_check_unknown | resolved / completed | Public profile fetched successfully and identity markers reviewed October 27; record evidence-backed check, not a new full capture. Evidence: [2026-10-27.json](data/content/checks/2026-10-27.json) |
| `e24ce92cd1eb1c6f875f` / Blue Noodle 6/30/2006 Capital Raise (`kinitos-neoedge/src-blue-noodle-2006-gaebler-funding-round`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `f6f399b04a913c02611d` / Blue Noodle 9/29/2009 Capital Raise (`kinitos-neoedge/src-blue-noodle-2009-gaebler-funding-round`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `a9fd71207461ae59332f` / Yahoo! Bolsters Ad-Supported Games (`kinitos-neoedge/src-neoedge-2008-adweek-yahoo-bolsters-ad-supported-games`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `a9c242d6d109f66da039` / Yahoo to offer free ad-supported games (`kinitos-neoedge/src-neoedge-2008-betanews-yahoo-free-ad-supported-games`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `064bb25b31a4123681c7` / Yahoo, Sony extend ad-funded games offerings (`kinitos-neoedge/src-neoedge-2008-campaign-yahoo-sony-ad-funded-games`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `b0c3559527c227a4e171` / Yahoo to offer ad-supported online games (`kinitos-neoedge/src-neoedge-2008-cnet-yahoo-ad-supported-games`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `97922660fe5422b93621` / Yahoo Games shifts to free games in alliance with two game ad start-ups (`kinitos-neoedge/src-neoedge-2008-techmeme-yahoo-games-free-games-startups`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `446624ea064f054bf368` / NeoEdge Networks - Crunchbase Company Profile & Funding (`kinitos-neoedge/src-neoedge-2026-crunchbase-funding-profile`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `4b95ab7fa7b79c7390a9` / VC Buzz - $246.55+ Million in Today's Deals (`quack/src-quack-1999-vc-buzz-246-55-million-in-todays-deals`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `9a3a2bdc274b1227e8f3` / AOL Formalizes 'Anywhere' Strategy (`quack/src-quack-2000-aol-formalizes-anywhere-strategy`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `17fa4f1c8caf491d28ca` / If It Walks Like a Duck, Quack.com (`quack/src-quack-2000-if-it-walks-like-a-duck-quack-com`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `fd6810d5fd1b01d00e0e` / Lycos, Quack.com Launch New Portal (`quack/src-quack-2000-lycos-quack-com-launch-new-portal`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `0f82a74350afec305ab0` / SpeechWorks: Calling on Investors (`quack/src-quack-2000-speechworks-calling-on-investors`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `af176e133adfe1845175` / Strategic Direction at Quack.com (A) (`quack/src-quack-2002-view`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `aa87e909effa70441a72` / Quack.com (`quack/src-quack-2026-quack-com`) | local_content_gap | deferred / deferred-leads | Retain source-owned deferral. Secondary profiles, funding records or overlapping press are lower-value until tied to a specific unsupported claim. |
| `4d5c5c0bcc3163e337e6` / Steven Woods Keynote presentation (`steven-woods-research/src-steven-2012-slideshare-keynote-deck`) | identity_unresolved | quarantined / identity | Do not attribute this revenue/marketing deck to the subject without identity confirmation. Source-owned legacy approval is not changed by this triage. Evidence: [slideshare-steven-woods-keynote.html](steven-woods-research/historic/artifacts/archive-html/slideshare-steven-woods-keynote.html) |
| `93d48f646061e0c56cc1` / Legacy Spectra welcome recording (`recording:steve-welcome`) | transcript_gap | deferred / legacy-audio | Filename is not identity evidence. Defer private speaker/duration inspection until there is a concrete need. Evidence: [steve-welcome.wav](Spectra/Html/steve-welcome.wav) |
| `3f2c9c134d9ebc92e83b` / Steven Woods (`steven-woods-research/src-steven-current-linkedin-profile`) | public_access_blocked | deferred / linkedin | Steven chose to leave public access blocked for now. Manual public-profile-only content may be considered later; do not use account UI, cookies or raw exports. |
| `daade19a49598a9f10cc` / Experience with performing architecture tradeoff analysis (`publication:kazman1999tradeoff`) | local_content_gap | ready / paper-recovery | Publisher DOI record lists Woods, but two public candidate drafts omit him from the first-page authors. Do not adopt them as exact editions or personal-authorship proof; retain the discrepancy for a later version review. Evidence: [2026-10-27-text-research.json](data/content/checks/2026-10-27-text-research.json) |
| `e361973b44f35fa12ef2` / Toward a discipline of scenario-based architectural engineering (`publication:kazman2000discipline`) | local_content_gap | ready / paper-recovery | A 26-page institutional manuscript candidate was privately obtained and text-extracted, with an author-attributed public lead also recorded. Not the verified 29-page journal edition; reading/edition/rights review remains before any public derivative. Evidence: [2026-10-27-text-research.json](data/content/checks/2026-10-27-text-research.json); [text-recovery-2026-10-27.json](data/content/production/text-recovery-2026-10-27.json) |
| `6545209622aa0749d9cd` / Program plan matching: experiments with a constraint-based approach (`publication:quilici2000matching`) | local_content_gap | deferred / paper-recovery | Bounded public search did not verify a qualifying full text. Keep publisher metadata and defer further acquisition until an author-held copy or stronger permitted lead is available; no 1997 substitution. Evidence: [2026-10-27-text-research.json](data/content/checks/2026-10-27-text-research.json) |
| `22fb1fd951376c3f3e78` / System and method for the transformation and canonicalization of semantically structured data (`publication:kominek2007canonicalization`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `ff511cc84127a6be3a4c` / Region classification based on regional distribution information (`publication:nanavati2015region`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `8543ca549b4674f1caab` / Identification of areas of interest on a web page (`publication:phillips2013areas`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `7ab8adba86a49550e1ec` / System and method for using voice over a telephone to access, process, and carry out transactions over the internet (`publication:quilici2011voiceover`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `f2e1ba67841d24028d44` / Associating advertisements and game data in a flash-based gaming environment (`publication:simons2010associating`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `ad39c3db16df62553a32` / Apparatus and method for service-enabling computer programs (`publication:simons2010serviceenabling`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `a55cf0f6d1c9c4162599` / Interstitial advertising in a gaming environment (`publication:slough2008interstitial`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `c91575392aa3eb42a49e` / Overlay content in a gaming environment (`publication:slough2010overlay`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `9f456134020261121cbc` / System and method for advertising with an internet voice portal (`publication:voisin2006advertising`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `de8fc4174637203d2ae8` / System and method for voice access to internet-based information (`publication:woods2003voiceaccess`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `c567fb9912d5e6415a1a` / System and method for advertisement identification, selection, and distribution involving a peer-to-peer network (`publication:woods2007peer`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `2b5a8a4e55fbd36ea2d8` / System and method for providing content, applications, services and digital media to users in a peer-to-peer network (`publication:woods2007providecontent`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `7c331910fc93a4235f27` / Service and messaging infrastructure to support creation of distributed, peer to peer applications with a service oriented architecture (`publication:woods2007servicemessaging`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `7604ee0a326565e9a62c` / Transformation and canonicalization of semantically structured data (`publication:woods2010transformation`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `611a6835fc9da07a21a8` / System and method for funneling user responses in an internet voice portal system to determine a desired item or service (`publication:woods2012funneling`) | local_content_gap | ready / patents | Exact-number public patent text is a bounded preservation task, not a voice source. Start with two only after priority selection; preserve inventors and grant/application distinctions. |
| `17a176ca6e1425a2c394` / VSLive Wrap: Microsoft shines a spotlight on PC clients (`ledger:16620bd0017af7ee04ac`) | local_content_gap | ready / priority-press | Useful company-history lead, but still deferred or ledger-only. Do a bounded access/identity/redundancy review before any preservation or promotion. |
| `67161d7863b7b126bd89` / AOL Buys a Voice Portal, Boosting Bid.com's Fortunes (`quack/src-quack-2000-aol-buys-a-voice-portal-boosting-bidcoms-fortunes-1062982`) | local_content_gap | ready / priority-press | Useful company-history lead, but still deferred or ledger-only. Do a bounded access/identity/redundancy review before any preservation or promotion. |
| `d0c7f4ce94f44af10e76` / AOL Gets Vocal, Buys Quack.com (`quack/src-quack-2000-aol-gets-vocal-buys-quack-com-4185-html`) | local_content_gap | ready / priority-press | Useful company-history lead, but still deferred or ledger-only. Do a bounded access/identity/redundancy review before any preservation or promotion. |
| `e3d2ad20a4aee0b1b9b3` / Risking it all for dot-com gold in California (`quack/src-quack-2007-press-5-htm`) | local_content_gap | ready / priority-press | Useful company-history lead, but still deferred or ledger-only. Do a bounded access/identity/redundancy review before any preservation or promotion. |
| `26c5078e5eca40f45361` / Steve Woods and Verna Friesen, Google Waterloo 28 Years of UW Community (`steven-woods-research/src-steven-2017-google-waterloo-uw-community`) | transcript_gap | ready / private-talks | Verified official symposium embed and Sep28 event versus Nov1 upload. This is a 54:03 joint presentation with Verna Friesen, not Woods-only speech. Public caption responses were empty. Await a permitted usable audio/text acquisition path; no alternate-client bypass. Evidence: [uwaterloo-cheriton-symposium-2017.html](steven-woods-research/historic/artifacts/archive-html/uwaterloo-cheriton-symposium-2017.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `9575a633c80b3836940d` / Research Discovery Days 2023: Steven Woods (`steven-woods-research/src-steven-2023-research-discovery-days-keynote`) | transcript_gap | deferred / private-talks | Verified 2:56 promotional clip, not a full-keynote recording. Video published April 4; keynote event April 18. No usable public captions obtained. Defer clip transcription behind the long interview; do not claim full-keynote text. Evidence: [uwaterloo-research-discovery-days.html](steven-woods-research/historic/artifacts/archive-html/uwaterloo-research-discovery-days.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `ebd184ac955ddd22b390` / Steven Woods - Partner and Chief Technology Officer, Inovia Capital (`steven-woods-research/src-steven-2023-riddick-show`) | transcript_gap | in_progress / private-talks | Publisher's current feed supplied a new enclosure for the same episode GUID. Audio downloaded privately and local, resumable ASR is underway. No prior transcript is known; no public transcript or speaker approval is claimed. Evidence: [apple-riddick-show.html](steven-woods-research/historic/artifacts/archive-html/apple-riddick-show.html); [riddick-show-feed.xml](steven-woods-research/historic/artifacts/archive-html/riddick-show-feed.xml); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `4a493327ce6b8ab60a7b` / P.G. Sorenson Lecture: Dr. Steven Woods, CEO of Kinitos, Inc. (`steven-woods-research/src-steven-2003-usask-sorenson-lecture`) | recording_link_gap | deferred / recording-discovery | Bounded public search completed; official listing/biography exists but no exact recording, slides or transcript was located. Not proof of absence. Future official contact routes retained, with no outreach authorized. Evidence: [usask-pg-sorenson-lectures.html](steven-woods-research/historic/artifacts/archive-html/usask-pg-sorenson-lectures.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `e042943278bfa0b73b9c` / The entrepreneurial computer scientist (`steven-woods-research/src-steven-2021-entrepreneurial-computer-scientist`) | recording_link_gap | deferred / recording-discovery | Bounded public search completed; official listing/biography exists but no exact recording, slides or transcript was located. Not proof of absence. Future official contact routes retained, with no outreach authorized. Evidence: [uwaterloo-entrepreneurial-computer-scientist.html](steven-woods-research/historic/artifacts/archive-html/uwaterloo-entrepreneurial-computer-scientist.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `43ea55834c5c177d885d` / Models of University/Industry Collaboration - What Works and What Doesn't (`steven-woods-research/src-steven-2023-cscan-collaboration-talk`) | recording_link_gap | deferred / recording-discovery | Bounded public search completed; official listing/biography exists but no exact recording, slides or transcript was located. Not proof of absence. Future official contact routes retained, with no outreach authorized. Evidence: [cscan-university-industry-collaboration.html](steven-woods-research/historic/artifacts/archive-html/cscan-university-industry-collaboration.html); [2026-10-27-media-research.json](data/content/checks/2026-10-27-media-research.json) |
| `b12cbb1a5670721b8572` / Preface (`publication:smith2001preface`) | local_content_gap | deferred / reference-only | Keep a metadata citation. No purchase or full-text republication requested; revisit only for a concrete reading need. |
| `abcc49e0f1e3f0054bc8` / Constraint-Based Design Recovery for Software Reengineering: Theory and Experiments (`publication:woods1997constraint`) | local_content_gap | deferred / reference-only | Keep a metadata citation. No purchase or full-text republication requested; revisit only for a concrete reading need. |
| `074884f24990766ff07b` / Software architectural transformation (`publication:carriere1999transformation`) | local_content_gap | deferred / related-editions | Local PDF equals official SEI bytes with correct three authors. Eleven-page length alone does not establish final proceedings edition; SEI landing metadata omits first author. Private reading text made; retain supporting-only status. Evidence: [software-architectural-transformation-1999-sei.pdf](sei-pittsburgh-research/historic/artifacts/archive-pdf/software-architectural-transformation-1999-sei.pdf); [2026-10-27-text-research.json](data/content/checks/2026-10-27-text-research.json); [text-recovery-2026-10-27.json](data/content/production/text-recovery-2026-10-27.json) |
| `dd2dac0251f27037d5ea` / Requirements for integrating software architecture and reengineering models: CORUM II (`publication:kazman1998corum`) | local_content_gap | deferred / related-editions | Local PDF equals official SEI bytes, but its 11-page author layout differs from proceedings pages 154-163 (ten pages). Private reading text made; retain supporting-only association and stop redundant exact-copy search unless specifically needed. Evidence: [requirements-for-integrating-software-architecture-1998-sei.pdf](sei-pittsburgh-research/historic/artifacts/archive-pdf/requirements-for-integrating-software-architecture-1998-sei.pdf); [2026-10-27-text-research.json](data/content/checks/2026-10-27-text-research.json); [text-recovery-2026-10-27.json](data/content/production/text-recovery-2026-10-27.json) |

## Explicitly Reviewed Follow-up Signals

These are additional signals introduced after the pinned baseline, not silent rewrites of its original request identities.

- `61c003acde1ccfede5f8` / `steven-woods-research/src-steven-2023-uwaterloo-entrepreneurship-impact`: **deferred** (recording_link_gap). Steven's official event listing has no verified recording after removing Natalie Gordon's video. Public searching only; keep the future Math Innovation contact route, do not contact anyone.

## Maintenance

Update a decision only with evidence or Steven's explicit direction. Preserve request IDs and the historical baseline. After each catalog refresh, run `python3 tools/triage_content_requests.py status`; unmatched requests need a new dated cycle, not silent suppression. A due review is not evidence that a historical source is wrong.

No unreviewed transcript, LinkedIn export, private location, credential or user answer containing private information belongs in these public files. The public-information maintainer does the work; other machines consume approved results and request changes.
