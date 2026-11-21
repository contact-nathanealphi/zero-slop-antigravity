#!/usr/bin/env bash
# Zero Slop Antigravity — installer
# Installs the Global Core (GEMINI.md) and 15 lazy-loaded skills.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/contact-nathanealphi/zero-slop-antigravity/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/contact-nathanealphi/zero-slop-antigravity/main/install.sh | bash -s -- --force
#   curl -fsSL https://raw.githubusercontent.com/contact-nathanealphi/zero-slop-antigravity/main/install.sh | bash -s -- --init-local
#   ./install.sh [--force] [--init-local]
#
# Flags:
#   --force       Overwrite existing global skills (default: skip if already installed).
#   --init-local  Copy templates/.antigravityignore into the current directory ($PWD).
#
# Idempotent and safe: an existing ~/.gemini/GEMINI.md is backed up to
# ~/.gemini/GEMINI.md.bak.<timestamp> before it is replaced. Nothing under
# ~/.gemini or ~/.agent is ever deleted.
set -euo pipefail

REPO="contact-nathanealphi/zero-slop-antigravity"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

FORCE=false
INIT_LOCAL=false

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    --init-local) INIT_LOCAL=true ;;
    *) echo "Unknown flag: $arg" >&2; echo "Usage: $0 [--force] [--init-local]" >&2; exit 1 ;;
  esac
done

SKILLS=(
  ultra-quota-guard
  session-handoff
  lesson-learner
  rekap-auto-updater
  blast-radius-analyzer
  version-lock-guard
  git-safety-net
  db-schema-guard
  anti-slop-strict
  api-contract-sync
  edge-state-checklist
  design-token-enforcer
  surgical-debugger
  qa-triage-runner
  adversarial-reviewer
)

# Resolve the directory this script lives in (works for a local clone;
# empty when piped through curl | bash, in which case we download).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || true)"

fetch_file() {
  # fetch_file <relative-path> <destination>
  local rel="$1" dest="$2"
  if [ -n "${SCRIPT_DIR:-}" ] && [ -f "${SCRIPT_DIR}/${rel}" ]; then
    cp "${SCRIPT_DIR}/${rel}" "$dest"
  else
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "${BASE_URL}/${rel}" -o "$dest"
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$dest" "${BASE_URL}/${rel}"
    else
      echo "Error: curl or wget is required to download ${rel}." >&2
      exit 1
    fi
  fi
}

# --- Global Core -----------------------------------------------------------
mkdir -p "$HOME/.gemini"

if [ -f "$HOME/.gemini/GEMINI.md" ] && [ "$FORCE" = false ]; then
  echo "Global Core already installed at ~/.gemini/GEMINI.md — skipping (use --force to overwrite)."
else
  if [ -f "$HOME/.gemini/GEMINI.md" ]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    cp "$HOME/.gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md.bak.${ts}"
    echo "Backed up existing GEMINI.md to ~/.gemini/GEMINI.md.bak.${ts}"
  fi
  fetch_file "core/GEMINI.md" "$HOME/.gemini/GEMINI.md"
  echo "Installed Global Core -> ~/.gemini/GEMINI.md"
fi

# --- Skills ----------------------------------------------------------------
for skill in "${SKILLS[@]}"; do
  target="$HOME/.agent/skills/${skill}/SKILL.md"
  if [ -f "$target" ] && [ "$FORCE" = false ]; then
    echo "Skill ${skill} already installed — skipping."
    continue
  fi
  mkdir -p "$HOME/.agent/skills/${skill}"
  fetch_file "skills/${skill}/SKILL.md" "$target"
  echo "Installed skill ${skill}"
done

# --- Local project setup (opt-in) ------------------------------------------
if [ "$INIT_LOCAL" = true ]; then
  if [ -f "$PWD/.antigravityignore" ]; then
    echo ".antigravityignore already exists in $PWD — skipping."
  else
    fetch_file "templates/.antigravityignore" "$PWD/.antigravityignore"
    echo "Installed .antigravityignore -> $PWD/.antigravityignore"
  fi
fi

echo ""
echo "Done. 15 skills installed, Global Core active."
echo "Next: paste MASTER_PROMPT.md into Antigravity once, or just start a task — the router loads at most 2 skills per task."
