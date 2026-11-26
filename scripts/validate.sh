#!/usr/bin/env bash
# Repo consistency checks (also run in CI). Exit 1 on any failure.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*"; fail=1; }
dirs_glob() {
  local p
  for p in skills/*/; do
    [ -d "$p" ] || continue
    p="${p%/}"
    printf '%s\n' "${p##*/}"
  done | LC_ALL=C sort
}
dirs="$(dirs_glob)"

while IFS= read -r d; do
  [ -n "$d" ] || continue
  f="skills/$d/SKILL.md"
  [ -f "$f" ] || { err "$f missing"; continue; }
  [ "$(sed -n 1p "$f")" = "---" ] || err "$f: frontmatter must start on line 1"
  n="$(sed -n '2s/^name: //p' "$f")"; [ "$n" = "$d" ] || err "$f: name '$n' != folder '$d'"
  desc="$(sed -n '3s/^description: //p' "$f")"
  [ -n "$desc" ] || err "$f: description must be on line 3"
  [ "${#desc}" -le 300 ] || err "$f: description > 300 chars"
  case "$desc" in *": "*) err "$f: description contains ': ' (breaks YAML)";; esac
  [ "$(sed -n 4p "$f")" = "---" ] || err "$f: frontmatter must close on line 4"
  [ "$(wc -c < "$f")" -le 1500 ] || err "$f: larger than 1500 bytes"
done <<EOF
$dirs
EOF

# shellcheck disable=SC2016
core="$(grep -oE '^\| (Work|Guard|Memory) \| `[a-z-]+`' core/GEMINI.md | grep -oE '`[a-z-]+`' | tr -d '`' | LC_ALL=C sort)"
[ "$core" = "$dirs" ] || err "Core router table does not match skills/ folders"

inst="$(awk '/^SKILLS=\(/{f=1;next} f&&/^\)/{f=0} f{gsub(/[ \t]/,""); if(length($0)) print}' install.sh | LC_ALL=C sort)"
[ "$inst" = "$dirs" ] || err "install.sh SKILLS array does not match skills/ folders"

while IFS= read -r d; do
  [ -n "$d" ] || continue
  grep -q "\`$d\`" README.md || err "README.md does not mention $d"
done <<EOF
$dirs
EOF

v="$(cat VERSION)"
grep -q "^VERSION=\"$v\"" install.sh || err "install.sh VERSION != VERSION file ($v)"
grep -q "^## \[$v\]" CHANGELOG.md || err "CHANGELOG.md has no entry for $v"

t="$(mktemp)"; bash scripts/build-master-prompt.sh "$t"
cmp -s "$t" MASTER_PROMPT.md || err "MASTER_PROMPT.md is stale -> run scripts/build-master-prompt.sh"
bash scripts/gen-checksums.sh "$t"
cmp -s "$t" SHA256SUMS || err "SHA256SUMS is stale -> run scripts/gen-checksums.sh"
rm -f "$t"

bash -n install.sh scripts/*.sh || err "shell syntax error"
if command -v shellcheck >/dev/null 2>&1; then shellcheck install.sh scripts/*.sh || err "shellcheck"; fi

if [ "$fail" -eq 0 ]; then echo "OK: all checks passed (v$v, $(echo "$dirs" | wc -l | tr -d ' ') skills)"; fi
exit "$fail"
