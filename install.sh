#!/usr/bin/env bash
# Zero Slop Antigravity — installer
#
#   curl -fsSL https://raw.githubusercontent.com/contact-nathanealphi/zero-slop-antigravity/main/install.sh | bash
#   curl -fsSL .../install.sh | ZS_REF=v3.0.0 bash -s -- --force      # pinned version
#   ./install.sh [flags]
#
# Flags:
#   --force        Update skills / Core that differ from this version (old copies are backed up).
#   --init-local   Write .antigravityignore and .geminiignore into the current directory.
#   --dry-run      Show what would change; write nothing.
#   --uninstall    Remove the Core block and the 15 skills (backups are kept).
#   --no-verify    Skip SHA256SUMS integrity check.
#   -h, --help     Show this help.
#
# Env: ZS_REF (branch/tag, default main) · ZS_SKILLS_DIR (default ~/.agent/skills)
#      ZS_GEMINI_DIR (default ~/.gemini) · ZS_BASE_URL (override download base)
#
# Safe by design: everything is downloaded + verified into a temp dir first; your own
# GEMINI.md content is preserved (Core lives between zero-slop markers); any file that is
# modified is backed up to <file>.bak.<timestamp>; nothing outside the 15 skills is deleted.
set -euo pipefail

VERSION="3.0.0"
REPO="contact-nathanealphi/zero-slop-antigravity"
REF="${ZS_REF:-main}"
BASE_URL="${ZS_BASE_URL:-https://raw.githubusercontent.com/${REPO}/${REF}}"
SKILLS_DIR="${ZS_SKILLS_DIR:-$HOME/.agent/skills}"
GEMINI_DIR="${ZS_GEMINI_DIR:-$HOME/.gemini}"
CORE_FILE="${GEMINI_DIR}/GEMINI.md"
MARK_BEGIN="<!-- zero-slop:begin -->"
MARK_END="<!-- zero-slop:end -->"
LEGACY_HEAD="# Global Core: Quota-Efficient, Anti-Slop, Secret Guard & Skill Router"

FORCE=false
INIT_LOCAL=false
DRY=false
UNINSTALL=false
VERIFY=true

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


for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    --init-local) INIT_LOCAL=true ;;
    --dry-run) DRY=true ;;
    --uninstall) UNINSTALL=true ;;
    --no-verify) VERIFY=false ;;
    -h|--help)
      echo "Zero Slop Antigravity installer v${VERSION}"
      echo "Flags: --force --init-local --dry-run --uninstall --no-verify --help"
      echo "Env:   ZS_REF ZS_SKILLS_DIR ZS_GEMINI_DIR ZS_BASE_URL"
      echo "Docs:  https://github.com/${REPO}#readme"
      exit 0 ;;
    *) echo "Unknown flag: $arg (try --help)" >&2; exit 1 ;;
  esac
done

say()  { printf '%s\n' "$*"; }
warn() { printf 'Warning: %s\n' "$*" >&2; }
die()  { printf 'Error: %s\n' "$*" >&2; exit 1; }
act()  { if [ "$DRY" = true ]; then say "[dry-run] $*"; else "$@"; fi; }
stamp() { date +%Y%m%d-%H%M%S; }
backup() { local b; b="${1}.bak.$(stamp)"; act cp -p "$1" "$b"; say "  backup: $b"; }

N_INSTALLED=0; N_UPDATED=0; N_UNCHANGED=0; N_KEPT=0

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
STAGE="$TMP/stage"

# --- uninstall (no download needed) ------------------------------------------
strip_block() { awk -v b="$MARK_BEGIN" -v e="$MARK_END" '$0==b{s=1;next} s&&$0==e{s=0;next} !s' "$1"; }

if [ "$UNINSTALL" = true ]; then
  if [ -f "$CORE_FILE" ] && grep -qxF "$MARK_BEGIN" "$CORE_FILE"; then
    backup "$CORE_FILE"
    strip_block "$CORE_FILE" > "$TMP/stripped"
    if [ "$DRY" = true ]; then
      say "[dry-run] remove Zero Slop block from $CORE_FILE"
    elif [ -z "$(tr -d '[:space:]' < "$TMP/stripped")" ]; then
      rm -f "$CORE_FILE"; say "Removed $CORE_FILE (it only contained the Zero Slop block)."
    else
      cat "$TMP/stripped" > "$CORE_FILE"; say "Removed Zero Slop block from $CORE_FILE (your content kept)."
    fi
  else
    say "No Zero Slop block in $CORE_FILE (v2 installs: restore your .bak file manually)."
  fi
  for s in "${SKILLS[@]}"; do
    if [ -f "$SKILLS_DIR/$s/SKILL.md" ]; then
      act rm -f "$SKILLS_DIR/$s/SKILL.md"
      if [ "$DRY" != true ]; then rmdir "$SKILLS_DIR/$s" 2>/dev/null || true; fi
    fi
  done
  say "Skills removed from $SKILLS_DIR. Backups (*.bak.*) were left in place."
  exit 0
fi

# --- source: local clone or download -----------------------------------------
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
LOCAL=false
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/core/GEMINI.md" ]; then LOCAL=true; VERIFY=false; fi

DL=""
if command -v curl >/dev/null 2>&1; then DL=curl
elif command -v wget >/dev/null 2>&1; then DL=wget; fi

fetch() { # fetch <relative-path> <dest>
  local rel="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ "$LOCAL" = true ]; then
    [ -f "$SCRIPT_DIR/$rel" ] || return 1
    cp "$SCRIPT_DIR/$rel" "$dest"
  elif [ "$DL" = curl ]; then
    curl -fsSL --retry 3 --connect-timeout 10 --max-time 60 "$BASE_URL/$rel" -o "$dest" || return 1
  elif [ "$DL" = wget ]; then
    wget -q -O "$dest" "$BASE_URL/$rel" || return 1
  else
    die "curl or wget is required."
  fi
  [ -s "$dest" ]
}

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else echo ""; fi
}

stage_all() {
  local rels=("core/GEMINI.md" "templates/.antigravityignore") s rel exp
  for s in "${SKILLS[@]}"; do rels+=("skills/$s/SKILL.md"); done
  local sums="$TMP/SHA256SUMS" have_sums=false
  if [ "$VERIFY" = true ]; then
    if fetch "SHA256SUMS" "$sums" 2>/dev/null; then
      if [ -n "$(sha256 "$sums")" ]; then have_sums=true; else warn "no sha256 tool found; skipping integrity check."; fi
    else
      warn "SHA256SUMS not available for ref '$REF'; skipping integrity check."
    fi
  fi
  for rel in "${rels[@]}"; do
    fetch "$rel" "$STAGE/$rel" || die "could not fetch $rel (network? ZS_REF=$REF?). Nothing was changed."
    if [ "$have_sums" = true ]; then
      exp="$(awk -v f="$rel" '$2==f{print $1}' "$sums")"
      [ -n "$exp" ] || die "no checksum entry for $rel. Nothing was changed."
      [ "$(sha256 "$STAGE/$rel")" = "$exp" ] || die "checksum mismatch for $rel. Nothing was changed."
    fi
  done
  if [ "$have_sums" = true ]; then say "Integrity check passed (SHA256SUMS @ $REF)."; fi
}

# --- Core (managed block inside GEMINI.md) -----------------------------------
extract_block() { awk -v b="$MARK_BEGIN" -v e="$MARK_END" '$0==b{p=1} p{print} $0==e{p=0}' "$1"; }

install_core() {
  local new="$TMP/new_block" cur="$TMP/cur_block" out="$TMP/core_out"
  { printf '%s\n' "$MARK_BEGIN"; cat "$STAGE/core/GEMINI.md"; printf '\n%s\n' "$MARK_END"; } > "$new"

  if [ ! -f "$CORE_FILE" ]; then
    act mkdir -p "$GEMINI_DIR"
    if [ "$DRY" != true ]; then cp "$new" "$CORE_FILE"; fi
    say "Core: installed -> $CORE_FILE"; N_INSTALLED=$((N_INSTALLED+1)); return
  fi

  if grep -qxF "$MARK_BEGIN" "$CORE_FILE"; then
    extract_block "$CORE_FILE" > "$cur"
    if cmp -s "$new" "$cur"; then say "Core: up to date."; N_UNCHANGED=$((N_UNCHANGED+1)); return; fi
    if [ "$FORCE" != true ]; then
      say "Core: installed block differs from v${VERSION} — kept (use --force to update)."
      N_KEPT=$((N_KEPT+1)); return
    fi
    backup "$CORE_FILE"
    awk -v b="$MARK_BEGIN" -v e="$MARK_END" -v nf="$new" \
      '$0==b{while((getline l < nf)>0) print l; s=1; next} s&&$0==e{s=0; next} !s' "$CORE_FILE" > "$out"
    if [ "$DRY" != true ]; then cat "$out" > "$CORE_FILE"; fi
    say "Core: updated block in $CORE_FILE"; N_UPDATED=$((N_UPDATED+1)); return
  fi

  if [ "$(head -n1 "$CORE_FILE")" = "$LEGACY_HEAD" ]; then
    backup "$CORE_FILE"
    if [ "$DRY" != true ]; then cp "$new" "$CORE_FILE"; fi
    say "Core: migrated v2 install to a managed block."; N_UPDATED=$((N_UPDATED+1)); return
  fi

  backup "$CORE_FILE"
  if [ "$DRY" != true ]; then { printf '\n'; cat "$new"; } >> "$CORE_FILE"; fi
  say "Core: appended as a managed block (your existing content is preserved)."
  N_INSTALLED=$((N_INSTALLED+1))
}

# --- Skills -------------------------------------------------------------------
install_skills() {
  local s src dst
  for s in "${SKILLS[@]}"; do
    src="$STAGE/skills/$s/SKILL.md"; dst="$SKILLS_DIR/$s/SKILL.md"
    if [ -f "$dst" ]; then
      if cmp -s "$src" "$dst"; then N_UNCHANGED=$((N_UNCHANGED+1)); continue; fi
      if [ "$FORCE" != true ]; then
        say "Skill $s differs from v${VERSION} — kept (use --force to update)."
        N_KEPT=$((N_KEPT+1)); continue
      fi
      backup "$dst"
      act cp "$src" "$dst"; N_UPDATED=$((N_UPDATED+1))
    else
      act mkdir -p "$SKILLS_DIR/$s"
      act cp "$src" "$dst"; N_INSTALLED=$((N_INSTALLED+1))
    fi
  done
}

init_local() {
  local n
  for n in .antigravityignore .geminiignore; do
    if [ -f "$PWD/$n" ]; then say "$n already exists in $PWD — skipped."
    else act cp "$STAGE/templates/.antigravityignore" "$PWD/$n"; say "Created $PWD/$n"; fi
  done
  if [ ! -f "$PWD/.gitignore" ] || ! grep -qE '^\.env' "$PWD/.gitignore"; then
    say "Tip: add '.env' and '.env.*' to this project's .gitignore."
  fi
}

# --- run -----------------------------------------------------------------------
say "Zero Slop Antigravity v${VERSION} (source: $([ "$LOCAL" = true ] && echo "local clone" || echo "$BASE_URL"))"
stage_all
install_core
install_skills
if [ "$INIT_LOCAL" = true ]; then init_local; fi

say ""
say "Done$([ "$DRY" = true ] && echo ' (dry run, nothing written)'). Installed: ${N_INSTALLED} · updated: ${N_UPDATED} · unchanged: ${N_UNCHANGED} · kept (modified): ${N_KEPT}"
say "Skills dir: $SKILLS_DIR   Core: $CORE_FILE"
say "Verify your Antigravity version reads these paths, then start a new session. Undo anytime: --uninstall."
