#!/usr/bin/env bash
# Regenerate SHA256SUMS for every file the installer downloads.
# Usage: scripts/gen-checksums.sh [output-file]   (default: SHA256SUMS)
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-SHA256SUMS}"
sum() { if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1"; else shasum -a 256 "$1"; fi; }
files=(core/GEMINI.md templates/.antigravityignore)
for p in skills/*/; do
  [ -d "$p" ] || continue
  p="${p%/}"
  files+=("skills/${p##*/}/SKILL.md")
done
printf '%s\n' "${files[@]}" | LC_ALL=C sort | while IFS= read -r f; do sum "$f"; done > "$out"
