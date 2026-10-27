# Steven Woods Media Sources Review

Working source file for a future public page covering interviews, podcasts, talks, presentations, profiles, and third-party media mentions involving Steven Gregory Woods.

Last updated: 2026-10-27

## Source-of-truth rule

Use this file together with the manifest triad intentionally:

- `source-manifest.json` is the machine-readable approved-source baseline used by the collected-content pages
- this review ledger is the broader working file for supporting captures, blocked preservation targets, and source candidates not yet promoted into the manifest

That means a checked-in local capture may legitimately appear here before it becomes a formal source-manifest entry. Company-overlap items may also remain here as person-centric context even when deeper company treatment belongs in Quack or Kinitos / NeoEdge.

## Content discovery checkpoint

The approved baseline remains 22 sources; 21 have local artifacts. LinkedIn alone
is uncaptured. Inovia, bio.link and Wikipedia were captured on October 26; their
original review/source dates were not replaced by capture dates. See
[the preservation register](../../ARCHIVE-PRESERVATION.md) for capture scope.

Use [the generated repository inventory](../../CONTENT-INVENTORY.md) and
[`data/content/sources.json`](../../data/content/sources.json) for explicit text,
recording, transcript, attribution and freshness states. Inventory paths are
repository-root-relative; the abbreviated `archive-html/` paths
in the historical tables below mean `historic/artifacts/archive-html/` here.
The search-only corrections below are limited to this ledger and the source
manifest. Root curation/triage, metadata, generated inventory and pages remain
for the parent to reconcile; regeneration alone will not fix stale overrides.

- Riddick's saved RSS feed contains episode metadata and an audio enclosure; the
  Apple capture also contains embedded feed/episode metadata. Neither is a
  transcript or a locally saved audio recording.
- The Springboard 2013 Q&A already contains publisher-attributed answers by
  Dr. Woods. It is readable first-person interview text, not audio verification.
- The previously associated Entrepreneurship and Impact video belongs to Natalie
  Gordon, not Steven Woods. Steven's April 2023 recording remains unlocated.
- The Research Discovery Days video is a 2:56 promo published April 4, 2023,
  not a verified full-keynote recording. The actual Woods keynote was April 18;
  November 2 came from a separate section of the historical context page.
- The Woods/Friesen symposium pairing is verified: September 28, 2017 event,
  distinct from the November 1 video publication. It is co-presented material.
- The 2012 SlideShare deck has an unresolved identity concern: marketing/revenue
  material and possible confusion with a namesake. Do not use it for Steven's
  voice, views or quotations until primary identity evidence is reviewed.
- Local SEI copies include Software Architectural Transformation and a related
  CORUM II report. Match editions before treating them as exact proceedings copies.
- No full transcript is catalogued in this public baseline. Private work may
  exist on another machine; recover it before rerunning transcription.

Unreviewed transcripts, LinkedIn exports, cookies, private contact data and
account archives must stay outside this public checkout in private staging.
An `incoming/` or `historic/` folder is not a privacy boundary. Source approval
is not speaker attribution, style-corpus approval or republication permission.

## Inclusion buckets

- `appearance`: first-person talk, keynote, interview, podcast, panel, or presentation by Steven Woods
- `profile`: profile page or feature article centered on Steven Woods
- `media-mention`: third-party article, press release, or news item where Steven Woods is quoted or prominently featured in connection with a company or event

## Public appearances

| Type | Title | Approx. date | URL | Evidence / notes | Local archive |
| --- | --- | --- | --- | --- | --- |
| appearance | The Riddick Show: Steven Woods - Partner and Chief Technology Officer, Inovia Capital | 2023-05-01 | https://podcasts.apple.com/br/podcast/steven-woods-partner-and-chief-technology-officer/id1681596688?i=1000611307947 | Exact episode date and duration confirmed from the RSS feed; direct MP3 URL is public. | `archive-html/apple-riddick-show.html`, `archive-html/riddick-show-feed.xml` |
| appearance | Models of University/Industry Collaboration - What Works and What Doesn't | circa 2023 (exact date unverified) | https://cscan-infocan.ca/models-of-university-industry-collaboration-what-works-and-what-doesnt/ | Official speaker listing, biography and discussion abstract; no recording, slides or transcript located in bounded public search. | `archive-html/cscan-university-industry-collaboration.html` |
| appearance | The entrepreneurial computer scientist | 2021-01-20 | https://uwaterloo.ca/math/events/entrepreneurial-computer-scientist | Official title/date/speaker confirmed; closed Zoom registration is not a recording. No recording, slides or transcript located. | `archive-html/uwaterloo-entrepreneurial-computer-scientist.html` (historical listing capture retained) |
| appearance | Entrepreneurship and Impact Series - April 2023, Steven Woods | 2023-04 | https://uwaterloo.ca/math-innovation/events-entrepreneurship-and-impact-series | Steven's listing is confirmed; his recording remains unlocated. The previously associated video belongs to the separate March Natalie Gordon entry. | `archive-html/uwaterloo-entrepreneurship-impact-series.html` |
| appearance | Research Discovery Days 2023: Steven Woods (promotional video) | 2023-04-04 (video publication) | https://www.youtube.com/watch?v=C_HIi0IKK90 | Exact YouTube title without the parenthetical: Research Discovery Days 2023: Steven Woods. Faculty of Mathematics, University of Waterloo (@waterloomath); 2:56; registration invitation. Short promo, not the full keynote. | `archive-html/uwaterloo-research-discovery-days.html` (historical context, not video/transcript) |
| appearance | Founding Innovation Keynote: Steven Woods | 2023-04-18 (event) | https://uwaterloo.ca/math-innovation/events/math-and-computing-research-discovery-days | Official event dates April 17-18; the [April 24 official report](https://uwaterloo.ca/math/news/inaugural-research-discovery-days-highlights-cutting-edge) places Woods' fireside keynote on day two. Do not present the short promo above as its full recording or assign the separate November event date. | `archive-html/uwaterloo-research-discovery-days.html` (April section; later November section is separate) |
| appearance | Steve Woods and Verna Friesen, Google Waterloo 28 Years of UW Community | 2017-09-28 (event); 2017-11-01 (video publication) | https://www.youtube.com/watch?v=3cDnlKwbtTY | Channel uwaterloo (@uwaterloo); 54:03. The [official symposium page](https://uwaterloo.ca/computer-science/events/2017-cheriton-research-symposium) schedules the joint talk at 4 p.m. September 28 and embeds this exact video. Not diarized. | `archive-html/uwaterloo-cheriton-symposium-2017.html` |
| appearance | P.G. Sorenson Lecture: Dr. Steven Woods, CEO of Kinitos, Inc. | 2003 | https://www.cs.usask.ca/research/lectures/p.g.-sorenson-lectures.php | Official entry confirms role, biography and talk title about timing and starting a software company. No recording, slides or transcript located in bounded public search. | `archive-html/usask-pg-sorenson-lectures.html` |
| appearance | A Conversation With Steven Woods, Engineering Director At Google Canada | 2013-01-30 | https://springboardatlantic.ca/a-conversation-with-steven-woods-engineering-director-at-google-canada/ | Interview/Q&A article republishing the University Affairs interview. | `archive-html/springboard-google-canada-interview.html` |

## Public search-only verification, October 27, 2026

Primary evidence was the official event/series pages and report linked above,
plus cookie-free public YouTube oEmbed and watch-page metadata. No private
workspace search, login, cookies, media download, paid tools, outreach or new
transcription was used. Source IDs and approval labels are unchanged.

- Wrong-video evidence: [L64GbHRcsFQ](https://www.youtube.com/watch?v=L64GbHRcsFQ)
  is titled "Natalie Gordon | Ask-Me-Anything | Math Innovation Entrepreneurship
  and Impact Series", on Faculty of Mathematics, University of Waterloo
  (@waterloomath), 47:14, published May 2, 2023. Both the current series page
  and unchanged historical capture place the link under Natalie, not Steven.
- Public watch metadata advertised English auto-generated caption tracks for
  all three candidate IDs. Following the supplied public caption URLs for
  C_HIi0IKK90 and 3cDnlKwbtTY returned empty bodies. No usable caption text or
  transcript was obtained; advertised tracks are not verified speaker spans.
  Natalie's captions must not be used as Steven's speech.
- Exact-title, speaker/date, organizer-site, video and slide/PDF searches left
  the CS-CAN, Waterloo 2021 and USask 2003 recording/slides/transcript gaps
  unresolved. The [organizer-linked CS-CAN channel search for Woods](https://www.youtube.com/channel/UC3pMzc-XDxb32Xo-7zyi8PQ/search?query=woods)
  returned no matching content. These are bounded search outcomes, not proof
  that recordings never existed or are unavailable elsewhere.
- Safely readable text is limited to publisher event descriptions, biographies,
  the USask talk title and the official Waterloo event report. None is a talk
  transcript. Historical captures remain unchanged evidence of page context;
  the two obsolete Math Innovation context URLs returned 404s, not evidence
  that the events or recordings are absent.

Potential future organizer routes, recorded only; no message was sent:

- CS-CAN event organizer: [official contact page](https://cscan-infocan.ca/contact-us/).
- Waterloo 2021 Mathematics event staff: [Faculty contact page](https://uwaterloo.ca/math/about/contact-us).
- Math Innovation series/Research Discovery Days organizers: [official contact information](https://uwaterloo.ca/math-innovation/about/contact-information).
- USask lecture-series/Computer Science administration: [department contact page](https://www.cs.usask.ca/about/contact-us.php).

## Profiles and feature pages

| Type | Title | Approx. date | URL | Evidence / notes | Local archive |
| --- | --- | --- | --- | --- | --- |
| profile | Steven Woods | reviewed 2026-04-01 | https://www.linkedin.com/in/stevenwoods/ | Major self-approved baseline profile for current role, employer sequence, and public identity. Useful as a baseline, not as the sole independent source. | none |
| profile | Steve Woods | reviewed 2026-04-01; captured 2026-10-26 | https://www.inovia.vc/team/steve-woods/ | Redirects to the new team modal. Public-browser transcription of the biography, not a raw page capture. | `archive-html/inovia-team-steve-woods-2026-10-26.html` and capture sidecar |
| profile | Steven Woods - Alumni and Friends | 2021 | https://alumni.usask.ca/get-involved/achieve/2021/woods.php | USask distinguished alumni feature/profile. | `archive-html/usask-alumni-profile-2021.html` |
| profile | Steven Woods \| Mathematics \| University of Waterloo | 2010-era profile page | https://uwaterloo.ca/math/profiles/steven-woods | J.W. Graham Medal profile page. | `archive-html/uwaterloo-jw-graham-profile.html` |
| profile | Inovia welcomes two world-class partners ... Steven Woods as Chief Technology Officer | 2021-07-23 | https://www.inovia.vc/inovia-conversations/inovia-welcomes-two-world-class-partners-krista-skalde-joins-as-chief-talent-officer-and-steven-woods-as-chief-technology-officer/ | Strong first-party profile/announcement. | `archive-html/inovia-welcomes-steven-woods.html` |
| profile | Steven Woods Keynote presentation | 2012-10-03 | https://www.slideshare.net/slideshow/steven-woods-keynote-presentation/14571346 | Identity unresolved; marketing/revenue-generation deck may belong to a namesake. Existing manifest approval is not approval for voice use. Verify subject and event before extraction or attribution. | `archive-html/slideshare-steven-woods-keynote.html` |
| profile | about.me/sgw | current self-profile | https://about.me/sgw | Useful bio hub, but likely belongs in a supporting links section rather than the main public page. | `archive-html/about-me-sgw.html` |
| profile | bio.link / sgwoods | reviewed 2026-04-01; captured 2026-10-26 | https://bio.link/sgwoods | Public-browser transcription of heading, Short Bio and link map. Malformed outbound links preserved as observed; owner-side repairs remain pending. | `archive-html/bio-link-sgwoods-2026-10-26.html` and capture sidecar |
| profile | Steven Woods | reviewed 2026-04-01; captured 2026-10-26 | https://en.wikipedia.org/wiki/Steven_Woods | Secondary synthesis, not Steven's own voice. Revision 1368795449; attribution and CC BY-SA license retained. | `archive-html/wikipedia-steven-woods-2026-10-26.html` and capture sidecar |

## Google-era media mentions

| Type | Title | Approx. date | URL | Evidence / notes | Local archive |
| --- | --- | --- | --- | --- | --- |
| media-mention | Innovation Nation - Canada's Cutting Edge Campus | 2013-02-25 | https://canada.googleblog.com/2013/02/innovation-nation-canadas-cutting-edge.html | Google Canada blog post quoting Woods on university collaboration and recruiting. | `archive-html/google-canada-innovation-nation.html` |
| media-mention | Google - Lang Tannery | 2010-08-11 | https://kitchener.citynews.ca/2010/08/11/google-lang-tannery/ | Local news item quoting Woods on Google Waterloo HQ plans. | `archive-html/citynews-google-lang-tannery.html` |
| media-mention | It's our biggest unboxing ever! Introducing Google Canada's new engineering HQ | 2016-01-14 | https://blog.google/intl/en-ca/company-news/inside-google/its-our-biggest-unboxing-ever/ | Official Google blog feature around the new Waterloo engineering HQ. | `archive-html/google-canada-unboxing-2016.html` |
| media-mention | Google's Steven Woods joins Inovia as partner and CTO | 2021-07-13 | https://betakit.com/googles-steven-woods-joins-inovia-as-partner-and-cto/ | BetaKit transition/profile article bridging Google and Inovia. | `archive-html/betakit-joins-inovia-2021.html` |
| media-mention | Top tech leaders appointed head coaches for Communitech's Hyperdrive program | 2012-06-27 | https://www.newswire.ca/news-releases/top-tech-leaders-appointed-head-coaches-for-communitechs-hyperdrive-program-510312771.html | Newswire release naming Steven Woods as Hyperdrive head coach. | `archive-html/newswire-hyperdrive-2012.html` |
| media-mention | Google opens applications for third cohort of Startups Accelerator Canada | 2022 | https://betakit.com/google-opens-applications-for-third-cohort-of-startups-accelerator-canada/ | BetaKit piece mentioning Woods in the Google Canada / startup ecosystem context. | `archive-html/betakit-google-accelerator-2022.html` |

## Quack.com / AOL era media mentions

| Type | Title | Approx. date | URL | Evidence / notes | Local archive |
| --- | --- | --- | --- | --- | --- |
| media-mention | AOL Buys a Voice Portal, Boosting Bid.com's Fortunes | 2000-08-31 | https://www.thestreet.com/technology/aol-buys-a-voice-portal-boosting-bidcoms-fortunes-1062982 | Third-party acquisition coverage for Quack.com; strong exit milestone source. | archive not yet saved |
| media-mention | Another Feather In AOL's Cap | 2000 | https://www.internetnews.com/it-management/another-feather-in-aols-cap/ | InternetNews coverage of the Quack/AOL acquisition. | `archive-html/internetnews-another-feather-in-aols-cap-2000.html` |
| media-mention | AOL Gets Vocal, Buys Quack.com | 2000 | https://www.ecommercetimes.com/story/aol-gets-vocal-buys-quack-com-4185.html | Third-party coverage of the Quack acquisition. | archive fetch blocked |
| media-mention | EARFUL OF INTERNET / Voice portals read news and other information via phone to users on the go | 2000 | https://www.sfgate.com/business/article/EARFUL-OF-INTERNET-Voice-portals-read-news-and-2758206.php | Broader voice-portal coverage naming Quack.com as a key company in the space. | `archive-html/sfgate-earful-of-internet-2000.html` |
| media-mention | The Net Finds Its Voice | 2001 | https://www.computerworld.com/article/1575186/the-net-finds-its-voice.html | Voice portal feature coverage from the post-exit period, useful as broader Quack market context. | `archive-html/computerworld-net-finds-voice-2001.html` |
| media-mention | SEI Architecture Practices Propel Successful Startup | 2002-era retrospective | https://www.sei.cmu.edu/asset_files/newsletter/2002_102_001_413759.pdf | Historical retrospective connecting SEI work to the Quack/Kinitos startup path. Canonical PDF URL is taken from the owning SEI source manifest; old feature11q02 URL is historical. | [SEI-owned PDF](../../sei-pittsburgh-research/historic/artifacts/archive-pdf/sei-architecture-practices-propel-successful-startup-2002.pdf) |
| media-mention | Risking it all for dot-com gold in California | archived 2007 capture of older article | https://web.archive.org/web/20070806021124/http://www.digitalmooselounge.com/press/press_5.htm | Cited in secondary biographies as a Steve/Quack profile article; needs direct archive verification. | none |

## Kinitos / NeoEdge era media mentions

| Type | Title | Approx. date | URL | Evidence / notes | Local archive |
| --- | --- | --- | --- | --- | --- |
| media-mention | VSLive Wrap: Microsoft shines a spotlight on PC clients | 2004-02-09 | https://www.infoworld.com/article/2223377/vslive-wrap-microsoft-shines-a-spotlight-on-pc-clients.html | InfoWorld article mentioning Kinitos application management for .NET smart clients. | none |
| media-mention | Bushnell joins NeoEdge board | 2007-05 | https://www.gamespot.com/articles/bushnell-joins-neoedge-board/1100-6171273/ | Third-party NeoEdge coverage around Nolan Bushnell joining the board. Reader capture exists in the owning company archive; not a raw full-site mirror. | [Kinitos/NeoEdge reader capture](../../kinitos-neoedge/historic/artifacts/archive-html/bushnell-joins-neoedge-board-2007-05-22-gamespot-reader.html) |
| media-mention | NeoEdge raises $4M for in-game video ads from game-focused VC firm | 2009 | https://gamesbeat.com/neoedge-raises-4m-for-in-game-video-ads-from-game-focused-vc-firm/ | Venture/media coverage of NeoEdge financing and ad-tech direction. Reader capture exists in the owning company archive. | [Kinitos/NeoEdge reader capture](../../kinitos-neoedge/historic/artifacts/archive-html/neoedge-raises-4m-2009-09-29-gamesbeat-reader.html) |
| media-mention | NeoEdge merges with Offspring, expands into game creation | 2009 | https://www.gamedeveloper.com/game-platforms/neoedge-merges-with-offspring-expands-into-game-creation | Industry coverage of NeoEdge strategy shift. | `archive-html/gamedeveloper-neoedge-merges-offspring-2009.html` |

## Still to verify / pursue

The October 27 request cycle is triaged in
[the decision register](../../CONTENT-REQUEST-TRIAGE.md), with machine-readable
per-request dispositions in `../../data/content/request-triage.json`.
Three unknown profile checks were completed with evidence in
`../../data/content/checks/2026-10-27.json`; three existing cross-archive copies
were associated without promoting deferred source labels. Private transcript
locations and any raw exports must not be entered in this public ledger.

- Locate Steven's April 2023 Entrepreneurship and Impact recording and the April 18 Research Discovery Days full keynote, if public; the Natalie video and short promo do not close those gaps
- Usable public captions and speaker attribution for the Woods videos remain unresolved; no diarized transcript is claimed
- Better archival copy for the original University Affairs article if accessible
- TheStreet and eCommerceTimes remain uncaptured here. GameSpot/GamesBeat reader captures already exist in Kinitos/NeoEdge; a GameDeveloper support capture already exists here. Review completeness, source identity and edition rather than requesting the same capture again
- Additional Quack.com-era profile/interview coverage beyond acquisition articles
- Exclude Eloqua / Nudge.ai namesake leads from the person/voice corpus unless primary identity evidence establishes relevance; never merge biographies on name alone
- Recover existing private transcripts, obtain the complete sanitized 32-candidate list, and follow the [corrected iMac handoff](../../IMAC-CONTENT-HANDOFF.md)
