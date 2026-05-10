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
need_file "$PROJECT_ROOT/README.md"
need_file "$PROJECT_ROOT/WORK-PLAN.md"
need_file "$PROJECT_ROOT/WORKSPACE-STATUS.md"
need_file "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-10.md"
need_file "$PROJECT_ROOT/project-manifest.json"
need_file "$PROJECT_ROOT/source-manifest.json"
need_file "$PROJECT_ROOT/public-handoff.json"
need_file "$PROJECT_ROOT/index.html"
need_file "$PROJECT_ROOT/research/baseline-identity.json"
need_file "$PROJECT_ROOT/research/timeline.md"
need_file "$PROJECT_ROOT/research/wikipedia-draft.md"
need_file "$PROJECT_ROOT/research/media-sources-review.md"
need_file "$REPO_ROOT/steven-woods-research.html"
need_file "$REPO_ROOT/steven-woods-cv.pdf"
need_file "$REPO_ROOT/tools/render_steven_sources.py"
need_file "$REPO_ROOT/tools/render_steven_cv.py"
need_file "$SCRIPT_DIR/start-steven-woods-codex.sh"

BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)"
COMMIT="$(git -C "$REPO_ROOT" rev-parse HEAD)"
REMOTE_URL="$(git -C "$REPO_ROOT" remote get-url origin)"
UPSTREAM_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
STEVEN_STATUS="$(git -C "$REPO_ROOT" status --short -- steven-woods-research steven-woods-research.html steven-woods-cv.pdf || true)"

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

archive_dir = project_root / "historic" / "artifacts" / "archive-html"
archive_files = sorted(
    str(path.relative_to(project_root))
    for path in archive_dir.iterdir()
    if path.is_file()
)
extra_files = [path for path in archive_files if path not in set(local_paths)]

print(f"total_sources={len(sources)}")
print(f"approved_sources={counts['approved']}")
print(f"deferred_sources={counts['deferred']}")
print(f"rejected_sources={counts['rejected']}")
print(f"sources_with_local_archives={len(local_paths)}")
print(f"archive_files_on_disk={len(archive_files)}")
print(f"extra_archive_files_not_in_manifest={len(extra_files)}")
print(f"broken_archive_paths={len(broken)}")

if broken:
    for source_id, local_path in broken:
        print(f"broken:{source_id}:{local_path}")
    raise SystemExit(2)
PY
)"

printf '\nSteven Woods Research Codex Startup Check\n'
printf '=======================================\n'
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

if [[ -n "$STEVEN_STATUS" ]]; then
  warn "Steven archive subtree is not clean:"
  printf '%s\n' "$STEVEN_STATUS"
else
  printf 'Steven archive subtree status: clean\n'
fi

printf '\nSource-of-truth rule:\n'
printf -- '- source-manifest.json = machine-readable approved-source baseline\n'
printf -- '- research/media-sources-review.md = broader working review ledger and reconciliation queue\n'

printf '\nShared-layer rule:\n'
printf -- '- steven-woods-research owns person-centric interpretation\n'
printf -- '- Quack and Kinitos own company-centric depth\n'
printf -- '- Quack may intentionally reference Steven archive context, but company-critical preservation should still exist in Quack\n'

printf '\nRead these next in Codex:\n'
printf '1. %s\n' "$REPO_ROOT/ARCHIVE_PROJECT_INTERFACE.md"
printf '2. %s\n' "$PROJECT_ROOT/WORKSPACE-STATUS.md"
printf '3. %s\n' "$PROJECT_ROOT/WORK-PLAN.md"
printf '4. %s\n' "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-10.md"
printf '5. %s\n' "$PROJECT_ROOT/project-manifest.json"
printf '6. %s\n' "$PROJECT_ROOT/source-manifest.json"
printf '7. %s\n' "$PROJECT_ROOT/public-handoff.json"
printf '8. %s\n' "$PROJECT_ROOT/research/media-sources-review.md"

printf '\nNext intended phase:\n'
printf -- '- Preservation completeness for the remaining URL-backed approved profile sources\n'
printf -- '- Deliberate reconciliation of review-ledger-only archive captures\n'
printf -- '- Keep person-layer and company-layer boundaries explicit as overlap sources grow\n'

if [[ "$REPO_ROOT" != "$CANONICAL_WORKSPACE" ]]; then
  warn "This run used a non-canonical location. Treat it as comparison-only validation, not the canonical active workspace."
fi
