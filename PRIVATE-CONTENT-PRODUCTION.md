# Private Content Production

Owner: this `sgwoods/public` maintainer. Other machines consume approved results.

## Boundaries

- Keep audio, unreviewed transcripts, reading extractions, model weights and raw
  LinkedIn exports outside every public checkout, including ignored directories.
- The public repo stores tools, tests, safe provenance, counts, review states and
  indexes. It does not store the private text or private locations.
- Local ASR is a draft, not verified speaker attribution, quotation approval,
  complete transcription or permission to republish. Speaker labels stay unknown.
- Publicly accessible papers may be read privately without being copied into the
  public archive as a new full-text derivative. Keep edition/author caveats.
- Do not upload private content to an ASR API or create a cloud backup destination
  without explicit direction. No paid API or organizer outreach is authorized.

## Local ASR Tool

`tools/transcribe_private_audio.py` requires existing private audio and a local
model directory. It does not fetch audio or models itself. The local environment
uses the pinned `tools/requirements-private-asr.txt`; CI runs only mocked/offline
tests and never installs the ASR stack.
The tested Mac/Python environment is recorded separately in
`tools/requirements-private-asr-macos-arm64.lock.txt`; it is not a cross-platform
dependency lock or a request to install these packages in CI.

```sh
python3 -m venv /path/to/private-workspace/.venv
/path/to/private-workspace/.venv/bin/python -m pip install \
  -r tools/requirements-private-asr.txt
/path/to/private-workspace/.venv/bin/python tools/transcribe_private_audio.py run \
  --input /path/to/private-workspace/audio/episode.mp3 \
  --run-dir /path/to/private-workspace/runs/source-id \
  --model-dir /path/to/private-workspace/models/pinned-model \
  --model-id mlx-community/whisper-large-v3-turbo \
  --model-revision a4aaeec0636e6fef84abdcbe3544cb2bf7e9f6fb \
  --content-id steven-woods-research/src-steven-2023-riddick-show \
  --source-url https://publisher.example/episode.mp3
```

Model source/configuration: [MLX Whisper](https://github.com/ml-explore/mlx-examples/tree/main/whisper),
[pinned model repository](https://huggingface.co/mlx-community/whisper-large-v3-turbo/tree/a4aaeec0636e6fef84abdcbe3544cb2bf7e9f6fb).
Install/download only through the official project/package/model sources. Verify
the model revision and file hashes; do not execute downloaded custom model code.
`ffmpeg` and `ffprobe` are required. Inference uses the local model with Hugging
Face offline mode and telemetry disabled; no cloud transcription API is called.

The tool hashes the audio, model files, options and runner. It saves atomic,
owner-only checkpoints for ten-minute cores with five-second overlap. Repeat the
same command to reuse matching checkpoints. Changed input/model/options/runner
or edited checkpoint bytes fail rather than silently reusing incompatible work.
Audio boundaries and possible repeated/missed speech still need listening review.

Outputs are private `job.json`, chunk JSON, and final JSON/TXT/SRT drafts. These
contain unreviewed words. Do not attach them to the public repo, public issues,
public CI artifacts, Pages or a public review branch.

```sh
python3 tools/transcribe_private_audio.py summary \
  --run-dir /path/to/private-workspace/runs/source-id
```

`summary` prints an allowlisted, text-free availability record. Review it before
placing it in `data/content/production/`. It intentionally omits private paths,
raw text, output filenames/hashes and speaker claims. Public metadata should say
when production was observed and what review remains, not imply access to a
reviewed transcript.

## Cycle Closeout

Parallelize independent work: the maintainer owns Git, curation, private
production and index integration; research/verification workers get explicit
disjoint write scopes or return evidence only. Do not let multiple workers edit
the same manifest. Run public searches and offline tests alongside local ASR,
but avoid competing GPU jobs or rebuilding the catalog while its inputs are
being changed. Review worker evidence before integrating a coherent checkpoint.

1. Check source identity, official audio/video pairing and event versus upload
   dates before processing. Do not repeat the wrong-speaker error found this cycle.
2. Produce privately; keep machine-stamped checksums, model revision, checkpoint
   completeness and low-confidence flags. Never infer accuracy from word count.
3. Persist safe code/evidence checkpoints in GitHub. Keep private derivatives
   local unless an explicitly approved private backup repository is selected.
4. Update the source ledger, curation, triage directions and production report.
   No source/release label changes merely because ASR completed.
5. Refresh person metadata, scoped archive provenance, shared pages and the full
   content catalog after committing their inputs. Run schema/privacy/regression
   checks, commit and push, then verify the explicit Pages build and live bundle.
6. Review audio, speakers, names/dates, rights and intended output before any
   future public-safe excerpt or consumer-facing derivative is approved.
