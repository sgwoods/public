#!/usr/bin/env bash
set -euo pipefail

ALLOW_NONCANONICAL=0
if [[ "${1:-}" == "--allow-noncanonical" ]]; then
  ALLOW_NONCANONICAL=1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
REPO_ROOT="$(cd "$PROJECT_ROOT/.." && pwd -P)"

CANONICAL_WORKSPACE="/Users/steven/Projects-All/public"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

warn() {
  printf 'WARN: %s\n' "$1" >&2
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

need_file() {
  [[ -f "$1" ]] || fail "required file missing: $1"
}

need_cmd git
need_cmd python3

if [[ "$REPO_ROOT" != "$CANONICAL_WORKSPACE" ]] && [[ "$ALLOW_NONCANONICAL" -ne 1 ]]; then
  fail "repo root is not the canonical workspace. Re-run from $CANONICAL_WORKSPACE or pass --allow-noncanonical for comparison-only validation."
fi

need_file "$REPO_ROOT/ARCHIVE_PROJECT_INTERFACE.md"
need_file "$REPO_ROOT/data/shared/incoming-artifact-analysis-playbook.md"
need_file "$REPO_ROOT/data/shared/incoming-artifact-analysis-template.md"
need_file "$PROJECT_ROOT/README.md"
need_file "$PROJECT_ROOT/WORK-PLAN.md"
need_file "$PROJECT_ROOT/WORKSPACE-STATUS.md"
need_file "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-11.md"
need_file "$PROJECT_ROOT/project-manifest.json"
need_file "$PROJECT_ROOT/source-manifest.json"
need_file "$PROJECT_ROOT/public-handoff.json"
need_file "$PROJECT_ROOT/index.html"
need_file "$PROJECT_ROOT/research/README.md"
need_file "$PROJECT_ROOT/research/seed-leads.md"
need_file "$PROJECT_ROOT/incoming/README.md"
need_file "$PROJECT_ROOT/incoming/document-ingestion-log.md"
need_file "$PROJECT_ROOT/historic/README.md"
need_file "$PROJECT_ROOT/historic/artifacts/README.md"
need_file "$PROJECT_ROOT/historic/artifacts/archive-html/README.md"
need_file "$PROJECT_ROOT/historic/artifacts/archive-pdf/README.md"
need_file "$REPO_ROOT/sei-pittsburgh-research.html"
need_file "$SCRIPT_DIR/start-sei-codex.sh"

BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)"
COMMIT="$(git -C "$REPO_ROOT" rev-parse HEAD)"
REMOTE_URL="$(git -C "$REPO_ROOT" remote get-url origin)"
UPSTREAM_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
SEI_STATUS="$(git -C "$REPO_ROOT" status --short -- sei-pittsburgh-research sei-pittsburgh-research.html || true)"

python3 - "$PROJECT_ROOT" <<'PY'
import json
import sys
from pathlib import Path

project_root = Path(sys.argv[1])

for name in ("project-manifest.json", "source-manifest.json", "public-handoff.json"):
    json.loads((project_root / name).read_text())
PY

MANIFEST_SUMMARY="$(python3 - "$PROJECT_ROOT" <<'PY'
import json
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
manifest = json.loads((project_root / "source-manifest.json").read_text())
sources = manifest["sources"]

counts = {"approved": 0, "deferred": 0, "rejected": 0}
local_paths = []
broken = []
for source in sources:
    status = source.get("status")
    if status in counts:
        counts[status] += 1
    local_path = source.get("urls", {}).get("archive_local")
    if local_path:
        local_paths.append(local_path)
        full = project_root / local_path
        if not full.exists():
            broken.append((source["source_id"], local_path))

html_dir = project_root / "historic" / "artifacts" / "archive-html"
pdf_dir = project_root / "historic" / "artifacts" / "archive-pdf"

html_files = sorted(
    str(path.relative_to(project_root))
    for path in html_dir.iterdir()
    if path.is_file() and path.name != "README.md"
)
pdf_files = sorted(
    str(path.relative_to(project_root))
    for path in pdf_dir.iterdir()
    if path.is_file() and path.name != "README.md"
)

print(f"total_sources={len(sources)}")
print(f"approved_sources={counts['approved']}")
print(f"deferred_sources={counts['deferred']}")
print(f"rejected_sources={counts['rejected']}")
print(f"sources_with_local_archives={len(local_paths)}")
print(f"archive_html_files_on_disk={len(html_files)}")
print(f"archive_pdf_files_on_disk={len(pdf_files)}")
print(f"broken_archive_paths={len(broken)}")

if broken:
    for source_id, local_path in broken:
        print(f"broken:{source_id}:{local_path}")
    raise SystemExit(2)
PY
)"

printf '\nSEI Pittsburgh Codex Startup Check\n'
printf '=================================\n'
printf 'Repo root: %s\n' "$REPO_ROOT"
printf 'Project root: %s\n' "$PROJECT_ROOT"
printf 'Branch: %s\n' "$BRANCH"
printf 'Commit: %s\n' "$COMMIT"
printf 'Origin: %s\n' "$REMOTE_URL"
if [[ -n "$UPSTREAM_BRANCH" ]]; then
  printf 'Upstream: %s\n' "$UPSTREAM_BRANCH"
fi
printf 'Canonical workspace target: %s\n' "$CANONICAL_WORKSPACE"
printf '%s\n' "$MANIFEST_SUMMARY"

if [[ -n "$SEI_STATUS" ]]; then
  warn "SEI Pittsburgh subtree is not clean:"
  printf '%s\n' "$SEI_STATUS"
else
  printf 'SEI Pittsburgh subtree status: clean\n'
fi

printf '\nEra boundary rule:\n'
printf -- '- steven-woods-research owns the person-centric layer\n'
printf -- '- sei-pittsburgh-research owns the era-specific deep archive for the SEI Pittsburgh period\n'
printf -- '- overlap is allowed, but SEI Pittsburgh should keep its own deep interpretation and local preservation baseline\n'

printf '\nRead these next in Codex:\n'
printf '1. %s\n' "$REPO_ROOT/ARCHIVE_PROJECT_INTERFACE.md"
printf '2. %s\n' "$PROJECT_ROOT/WORKSPACE-STATUS.md"
printf '3. %s\n' "$PROJECT_ROOT/WORK-PLAN.md"
printf '4. %s\n' "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-11.md"
printf '5. %s\n' "$PROJECT_ROOT/project-manifest.json"
printf '6. %s\n' "$PROJECT_ROOT/source-manifest.json"
printf '7. %s\n' "$PROJECT_ROOT/public-handoff.json"
printf '8. %s\n' "$PROJECT_ROOT/research/seed-leads.md"

printf '\nNext intended phase:\n'
printf -- '- Add one stronger institute-context source beyond the current Woods and Carriere profile floor\n'
printf -- '- Extend the SEI publication floor beyond the current twelve-source baseline with one more period publication or issue entry\n'
printf -- '- Deepen the bridge beyond the localized AOL acquisition coverage with one more strong transition source\n'

if [[ "$REPO_ROOT" != "$CANONICAL_WORKSPACE" ]]; then
  warn "This run used a non-canonical location. Treat it as comparison-only validation, not the canonical active workspace."
fi
