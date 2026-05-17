#!/usr/bin/env bash
set -euo pipefail

ALLOW_NONCANONICAL=0
if [[ "${1:-}" == "--allow-noncanonical" ]] || [[ "${1:-}" == "--allow-non-icloud" ]]; then
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

python3 - <<'PY'
import sys
try:
    from zoneinfo import ZoneInfo  # noqa: F401
except Exception as exc:
    raise SystemExit(f"ERROR: python3 is missing zoneinfo support: {exc}")
if sys.version_info < (3, 9):
    raise SystemExit(f"ERROR: python3 3.9+ required, found {sys.version}")
PY

if ! command -v rg >/dev/null 2>&1; then
  warn "ripgrep (rg) not found; project remains workable, but some Codex workflows will be less convenient"
fi

if [[ "$REPO_ROOT" != "$CANONICAL_WORKSPACE" ]] && [[ "$ALLOW_NONCANONICAL" -ne 1 ]]; then
  fail "repo root is not the canonical workspace. Re-run from $CANONICAL_WORKSPACE or pass --allow-noncanonical for comparison-only validation."
fi

need_file "$REPO_ROOT/ARCHIVE_PROJECT_INTERFACE.md"
need_file "$REPO_ROOT/data/shared/company-research-workflow.md"
need_file "$PROJECT_ROOT/WORKSPACE-STATUS.md"
need_file "$PROJECT_ROOT/WORK-PLAN.md"
need_file "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-03.md"
need_file "$PROJECT_ROOT/project-manifest.json"
need_file "$PROJECT_ROOT/source-manifest.json"
need_file "$PROJECT_ROOT/public-handoff.json"
need_file "$PROJECT_ROOT/index.html"
need_file "$REPO_ROOT/kinitos-neoedge.html"
need_file "$REPO_ROOT/data/projects/kinitos-neoedge.json"
need_file "$SCRIPT_DIR/start-kinitos-codex.sh"

BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD)"
COMMIT="$(git -C "$REPO_ROOT" rev-parse HEAD)"
REMOTE_URL="$(git -C "$REPO_ROOT" remote get-url origin)"
UPSTREAM_BRANCH="$(git -C "$REPO_ROOT" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
KINITOS_STATUS="$(git -C "$REPO_ROOT" status --short -- kinitos-neoedge data/kinitos-neoedge kinitos-neoedge.html data/projects/kinitos-neoedge.json data/shared/company-research-workflow.md || true)"

MANIFEST_SUMMARY="$(python3 - "$PROJECT_ROOT/source-manifest.json" <<'PY'
import json
import sys
from pathlib import Path

manifest = Path(sys.argv[1])
project_root = manifest.parent
data = json.loads(manifest.read_text())
sources = data["sources"]
approved = [s for s in sources if s.get("status") == "approved"]
deferred = [s for s in sources if s.get("status") == "deferred"]
rejected = [s for s in sources if s.get("status") == "rejected"]
local = [s for s in approved if s.get("urls", {}).get("archive_local")]
broken = []
for source in approved:
    local_path = source.get("urls", {}).get("archive_local")
    if local_path and not project_root.joinpath(local_path).exists():
        broken.append((source["source_id"], local_path))

print(f"total_sources={len(sources)}")
print(f"approved_sources={len(approved)}")
print(f"deferred_sources={len(deferred)}")
print(f"rejected_sources={len(rejected)}")
print(f"approved_local_archives={len(local)}")
print(f"broken_archive_paths={len(broken)}")

if broken:
    for source_id, local_path in broken:
        print(f"broken:{source_id}:{local_path}")
    raise SystemExit(2)
PY
)"

printf '\nKinitos / NeoEdge Codex Startup Check\n'
printf '===================================\n'
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

if [[ -n "$KINITOS_STATUS" ]]; then
  warn "Kinitos subtree is not clean:"
  printf '%s\n' "$KINITOS_STATUS"
else
  printf 'Kinitos subtree status: clean\n'
fi

printf '\nRead these next in Codex:\n'
printf '1. %s\n' "$REPO_ROOT/ARCHIVE_PROJECT_INTERFACE.md"
printf '2. %s\n' "$PROJECT_ROOT/WORKSPACE-STATUS.md"
printf '3. %s\n' "$PROJECT_ROOT/WORK-PLAN.md"
printf '4. %s\n' "$PROJECT_ROOT/PROJECT-STATE-AND-RECOVERY-2026-05-03.md"
printf '5. %s\n' "$PROJECT_ROOT/project-manifest.json"
printf '6. %s\n' "$PROJECT_ROOT/source-manifest.json"

printf '\nNext intended phase:\n'
printf -- '- Deferred-source follow-up and public corroboration campaigns\n'
printf -- '- Keep coordination manifests and public surfaces in sync\n'
printf -- '- Broader research or restoration only after deliberate campaign selection\n'

if [[ "$REPO_ROOT" != "$CANONICAL_WORKSPACE" ]]; then
  warn "This run used a non-canonical location. Treat it as comparison-only validation, not the canonical active workspace."
fi
