#!/bin/bash

set -euo pipefail

REPO_URL="https://github.com/sgwoods/public.git"
ACTIVE_BRANCH="main"
ACTIVE_TARGET="${HOME}/Projects-All/public"
RECOVERY_BRANCH="codex/public-recovery-stabilization"
RECOVERY_TARGET="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/StevenWoods/public-quack-recovery"
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") install
  $(basename "$0") setup [target_dir]
  $(basename "$0") validate [target_dir]
  $(basename "$0") setup-recovery [target_dir]
  $(basename "$0") validate-recovery [target_dir]

Defaults:
  active branch: ${ACTIVE_BRANCH}
  active target_dir: ${ACTIVE_TARGET}
  recovery branch: ${RECOVERY_BRANCH}
  recovery target_dir: ${RECOVERY_TARGET}

Commands:
  install            Install or repair the required local toolchain for a new Mac.
  setup              Install prerequisites, clone or refresh the preferred active checkout on ${ACTIVE_BRANCH}, then validate it.
  validate           Validate an existing preferred active checkout without changing tracked files.
  setup-recovery     Install prerequisites, clone or refresh the recovery checkout, then validate it.
  validate-recovery  Validate an existing recovery checkout without changing tracked files.
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

brew_bin() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo /opt/homebrew/bin/brew
    return 0
  fi
  if [[ -x /usr/local/bin/brew ]]; then
    echo /usr/local/bin/brew
    return 0
  fi
  return 1
}

refresh_shell_path_from_brew() {
  local brew_path
  brew_path="$(brew_bin 2>/dev/null || true)"
  if [[ -n "$brew_path" ]]; then
    eval "$("$brew_path" shellenv)"
    hash -r
  fi
}

ensure_homebrew() {
  if brew_bin >/dev/null 2>&1; then
    refresh_shell_path_from_brew
    return 0
  fi

  print_header "Installing Homebrew"
  require_cmd curl
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")"
  refresh_shell_path_from_brew

  if ! brew_bin >/dev/null 2>&1; then
    echo "Homebrew installation did not complete successfully." >&2
    exit 1
  fi
}

ensure_brew_package() {
  local package="$1"
  local command_name="$2"
  local brew_path
  brew_path="$(brew_bin)"

  if command -v "$command_name" >/dev/null 2>&1; then
    return 0
  fi

  print_header "Installing ${package}"
  "$brew_path" install "$package"
  refresh_shell_path_from_brew

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Expected command '$command_name' after installing package '$package', but it is still unavailable." >&2
    exit 1
  fi
}

install_required_toolchain() {
  print_header "Installing required toolchain"

  ensure_homebrew
  ensure_brew_package git git
  ensure_brew_package python python3
  ensure_brew_package jq jq
  ensure_brew_package ripgrep rg
  ensure_brew_package ghostscript gs
}

check_optional_tools() {
  print_header "Optional tool visibility"
  if command -v gs >/dev/null 2>&1; then
    gs --version | head -n 1
  else
    echo "Ghostscript (gs) not found; steven-woods-cv.pdf can remain checked in, but local regeneration will be unavailable until gs is installed."
  fi
}

report_dashboard_repo_paths() {
  print_header "Dashboard sibling repos"
  local aurora="${PUBLIC_AURORA_REPO_PATH:-${PUBLIC_AURORA_REPO:-$HOME/Projects-All/Codex-Test1}}"
  local phd="${PUBLIC_PHD_REPO_PATH:-${PUBLIC_PHD_REPO:-$HOME/Projects-All/phd-renovation-working}}"
  local mmath="${PUBLIC_MMATH_REPO_PATH:-${PUBLIC_MMATH_REPO:-$HOME/Projects-All/mmath-renovation-working}}"

  for label_and_path in \
    "Aurora:$aurora" \
    "PhD renovation:$phd" \
    "MMath renovation:$mmath"; do
    local label="${label_and_path%%:*}"
    local path="${label_and_path#*:}"
    if [[ -d "$path/.git" ]]; then
      echo "$label repo found: $path"
    else
      echo "$label repo not found: $path"
    fi
  done
}

fetch_public_refs() {
  local target="$1"

  git -C "$target" fetch origin \
    "main:refs/remotes/origin/main" \
    "$RECOVERY_BRANCH:refs/remotes/origin/$RECOVERY_BRANCH" >/dev/null
}

ensure_clean_checkout() {
  local target="$1"
  local dirty

  dirty="$(git -C "$target" status --porcelain)"
  if [[ -n "$dirty" ]]; then
    echo "Checkout is not clean:" >&2
    printf "%s\n" "$dirty" >&2
    exit 1
  fi
}

validate_checkout() {
  local mode="$1"
  local target="$2"
  local expected_branch
  local mode_label
  local divergence_label
  local divergence_range
  local relpath
  local -a required_files
  local -a suggested_files

  case "$mode" in
    active)
      expected_branch="$ACTIVE_BRANCH"
      mode_label="active"
      divergence_label="active-branch divergence"
      divergence_range="origin/main...HEAD"
      required_files=(
        "ARCHIVE_PROJECT_INTERFACE.md"
        "PROJECT-SUITE-OVERVIEW.md"
        "PUBLIC_STATUS_INTERFACE.md"
        "README.md"
        "data/shared/project-suite-overview.json"
        "index.html"
        "project-suite-overview.html"
        "tools/refresh_public_coordination.py"
        "tools/render_index.py"
        "tools/render_project_suite_overview.py"
        "tools/render_publications.py"
        "tools/render_steven_sources.py"
        "tools/render_steven_cv.py"
        "quack/tools/quack_research_pipeline.py"
      )
      suggested_files=(
        "PUBLIC-OPERATING-MODEL.md"
        "README.md"
        "ARCHIVE_PROJECT_INTERFACE.md"
        "PUBLIC_STATUS_INTERFACE.md"
      )
      ;;
    recovery)
      expected_branch="$RECOVERY_BRANCH"
      mode_label="recovery"
      divergence_label="recovery-branch divergence"
      divergence_range="origin/main...origin/$RECOVERY_BRANCH"
      required_files=(
        "ARCHIVE_PROJECT_INTERFACE.md"
        "README.md"
        "PROJECT-STATE-AND-RECOVERY.md"
        "START-HERE-NEW-MAC.md"
        "PUBLIC-OPERATING-MODEL.md"
        "quack/README.md"
        "quack/tools/quack_research_pipeline.py"
        "kinitos-neoedge/README.md"
        "data/shared/incoming-artifact-analysis-playbook.md"
        "data/shared/incoming-artifact-analysis-template.md"
      )
      suggested_files=(
        "README.md"
        "PUBLIC-OPERATING-MODEL.md"
        "PROJECT-STATE-AND-RECOVERY.md"
        "START-HERE-NEW-MAC.md"
        "quack/README.md"
        "kinitos-neoedge/README.md"
      )
      ;;
    *)
      echo "Unknown validation mode: $mode" >&2
      exit 1
      ;;
  esac

  require_cmd git
  require_cmd python3
  require_cmd jq
  require_cmd rg

  print_header "Validating ${mode_label} checkout"

  if [[ ! -d "$target/.git" ]]; then
    echo "Not a git checkout: $target" >&2
    exit 1
  fi

  local current_branch
  current_branch="$(git -C "$target" rev-parse --abbrev-ref HEAD)"
  if [[ "$current_branch" != "$expected_branch" ]]; then
    echo "Expected branch $expected_branch but found $current_branch" >&2
    exit 1
  fi

  fetch_public_refs "$target"
  ensure_clean_checkout "$target"

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
  check_optional_tools

  print_header "Compiling Python entry points"
  python3 -m py_compile \
    "$target/quack/tools/quack_research_pipeline.py" \
    "$target/tools/refresh_public_coordination.py" \
    "$target/tools/render_index.py" \
    "$target/tools/render_project_suite_overview.py" \
    "$target/tools/render_publications.py" \
    "$target/tools/render_steven_sources.py" \
    "$target/tools/render_steven_cv.py"

  print_header "Running Quack validation"
  python3 "$target/quack/tools/quack_research_pipeline.py" validate

  report_dashboard_repo_paths

  print_header "Checking ${divergence_label}"
  git -C "$target" rev-list --left-right --count "$divergence_range"

  print_header "Checkout status"
  git -C "$target" status --short --branch

  print_header "Validation complete"
  cat <<EOF
Validated checkout:
  $target

Suggested next files to open:
EOF

  for relpath in "${suggested_files[@]}"; do
    if [[ -f "$target/$relpath" ]]; then
      printf "  %s/%s\n" "$target" "$relpath"
    fi
  done
}

setup_checkout() {
  local mode="$1"
  local target="$2"
  local branch
  local mode_label

  case "$mode" in
    active)
      branch="$ACTIVE_BRANCH"
      mode_label="active"
      ;;
    recovery)
      branch="$RECOVERY_BRANCH"
      mode_label="recovery"
      ;;
    *)
      echo "Unknown setup mode: $mode" >&2
      exit 1
      ;;
  esac

  install_required_toolchain

  local parent
  parent="$(dirname "$target")"
  mkdir -p "$parent"

  if [[ -d "$target/.git" ]]; then
    print_header "Refreshing existing ${mode_label} checkout"
    ensure_clean_checkout "$target"
    fetch_public_refs "$target"
    git -C "$target" checkout "$branch"
    git -C "$target" pull --ff-only origin "$branch"
  else
    print_header "Cloning ${mode_label} checkout"
    git clone --branch "$branch" --single-branch "$REPO_URL" "$target"
  fi

  validate_checkout "$mode" "$target"
}

main() {
  local command="${1:-}"
  local target

  case "$command" in
    install)
      install_required_toolchain
      ;;
    setup)
      target="${2:-$ACTIVE_TARGET}"
      setup_checkout active "$target"
      ;;
    validate)
      target="${2:-$ACTIVE_TARGET}"
      validate_checkout active "$target"
      ;;
    setup-recovery)
      target="${2:-$RECOVERY_TARGET}"
      setup_checkout recovery "$target"
      ;;
    validate-recovery)
      target="${2:-$RECOVERY_TARGET}"
      validate_checkout recovery "$target"
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
