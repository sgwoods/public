#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/sgwoods/public.git"
BRANCH="codex/public-recovery-stabilization"
DEFAULT_TARGET="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") setup [target_dir]
  $(basename "$0") validate [target_dir]

Defaults:
  branch: ${BRANCH}
  target_dir: ${DEFAULT_TARGET}

Commands:
  setup     Clone or refresh the recovery branch into the target directory, then validate it.
  validate  Validate an existing checkout without changing tracked files.
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

print_header() {
  printf "\n== %s ==\n" "$1"
}

validate_checkout() {
  local target="$1"

  print_header "Validating checkout"

  if [[ ! -d "$target/.git" ]]; then
    echo "Not a git checkout: $target" >&2
    exit 1
  fi

  local current_branch
  current_branch="$(git -C "$target" rev-parse --abbrev-ref HEAD)"
  if [[ "$current_branch" != "$BRANCH" ]]; then
    echo "Expected branch $BRANCH but found $current_branch" >&2
    exit 1
  fi

  git -C "$target" fetch origin \
    "main:refs/remotes/origin/main" \
    "$BRANCH:refs/remotes/origin/$BRANCH" >/dev/null

  local dirty
  dirty="$(git -C "$target" status --porcelain)"
  if [[ -n "$dirty" ]]; then
    echo "Checkout is not clean:" >&2
    printf "%s\n" "$dirty" >&2
    exit 1
  fi

  local required_files=(
    "ARCHIVE_PROJECT_INTERFACE.md"
    "PROJECT-STATE-AND-RECOVERY.md"
    "quack/PROJECT-STATE-AND-RECOVERY.md"
    "quack/WORKSPACE-STATUS.md"
    "quack/tools/quack_research_pipeline.py"
    "data/shared/company-research-workflow.md"
    "kinitos-neoedge/WORKSPACE-STATUS.md"
  )

  for relpath in "${required_files[@]}"; do
    if [[ ! -f "$target/$relpath" ]]; then
      echo "Missing required file: $relpath" >&2
      exit 1
    fi
  done

  print_header "Checking toolchain"
  git --version
  python3 --version
  jq --version
  rg --version | head -n 1

  print_header "Compiling Python entry points"
  python3 -m py_compile \
    "$target/quack/tools/quack_research_pipeline.py" \
    "$target/tools/render_index.py"

  print_header "Running Quack validation"
  python3 "$target/quack/tools/quack_research_pipeline.py" validate

  print_header "Checking recovery-branch divergence"
  git -C "$target" rev-list --left-right --count "origin/main...origin/$BRANCH"

  print_header "Checkout status"
  git -C "$target" status --short --branch

  print_header "Validation complete"
  cat <<EOF
Validated checkout:
  $target

Suggested next files to open:
  $target/PROJECT-STATE-AND-RECOVERY.md
  $target/quack/PROJECT-STATE-AND-RECOVERY.md
  $target/quack/WORKSPACE-STATUS.md
EOF
}

setup_checkout() {
  local target="$1"

  print_header "Checking prerequisites"
  require_cmd git
  require_cmd python3
  require_cmd jq
  require_cmd rg

  local parent
  parent="$(dirname "$target")"
  mkdir -p "$parent"

  if [[ -d "$target/.git" ]]; then
    print_header "Refreshing existing checkout"
    git -C "$target" fetch origin \
      "main:refs/remotes/origin/main" \
      "$BRANCH:refs/remotes/origin/$BRANCH"
    git -C "$target" checkout "$BRANCH"
    git -C "$target" pull --ff-only origin "$BRANCH"
  else
    print_header "Cloning recovery checkout"
    git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$target"
  fi

  validate_checkout "$target"
}

main() {
  local command="${1:-}"
  local target="${2:-$DEFAULT_TARGET}"

  case "$command" in
    setup)
      setup_checkout "$target"
      ;;
    validate)
      validate_checkout "$target"
      ;;
    ""|-h|--help|help)
      usage
      ;;
    *)
      echo "Unknown command: $command" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
