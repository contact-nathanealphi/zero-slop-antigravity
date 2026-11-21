#!/usr/bin/env bash
# Build MASTER_PROMPT.md from core/ + skills/ + templates/ so it can never drift.
# Usage: scripts/build-master-prompt.sh [output-file]   (default: MASTER_PROMPT.md)
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-MASTER_PROMPT.md}"
ver="$(cat VERSION)"
fence() { printf '````%s\n' "$1"; cat "$2"; printf '````\n\n'; }
{
cat <<HEAD
# Master Prompt — Zero Slop Antigravity v${ver}

> Copy this whole prompt into Antigravity. No script needed.
> Generated from the repo files by \`scripts/build-master-prompt.sh\`. Do not edit by hand.
> Idempotent: files already identical are skipped. Add the words \`force update\` to update modified files.

---

Install the **Zero Slop** system (Global Core + 15 skills) and set up this workspace.

## Rules (read first)

1. **Write files verbatim.** Do not paraphrase, shorten, or "improve" any file content below.
2. **One batch.** Write every global file in a **single \`bash\` execution** (\`mkdir -p\` + \`cat << 'ZS_EOF'\`).
3. **Skills directory:** use \`~/.agent/skills/<name>/SKILL.md\`. If your Antigravity version reads global skills from a different directory, use that one and say so in the final report.
4. **Core goes in a managed block.** Never overwrite \`~/.gemini/GEMINI.md\`. Back it up to \`~/.gemini/GEMINI.md.bak.<timestamp>\`, then:
   - no file: create it containing the block;
   - file without markers: append the block (keep the user's content);
   - file with markers: replace only the text between the markers, and only if it differs and the message contains \`force update\`.
   The block is: the line \`<!-- zero-slop:begin -->\`, the Core file content, a blank line, the line \`<!-- zero-slop:end -->\`.
5. **Skills:** if a \`SKILL.md\` already exists and is byte-identical, skip it. If it differs, keep it unless \`force update\` is present (then back it up as \`SKILL.md.bak.<timestamp>\` first).
6. Never read \`.env*\`, keys, or credentials while doing this.

---

## Phase 1 — Global Core → managed block in \`~/.gemini/GEMINI.md\`

HEAD
fence markdown core/GEMINI.md
printf '## Phase 2 — 15 skills → `~/.agent/skills/<name>/SKILL.md`\n\n'
for d in $(ls -1 skills | sort); do
  printf '### %s\n\n' "$d"
  fence markdown "skills/$d/SKILL.md"
done
cat <<'MID'
---

## Phase 3 — Local setup for this workspace

1. Inspect the root shallowly (depth 2, e.g. `ls -la`). Never open large files or dependency / SDK / backup folders.
2. Create `.antigravityignore` and an identical `.geminiignore` at the project root with the content below, **plus** any other heavy folders you detect at the root (SDKs, backups, media, dumps). If a file already exists, merge: keep the user's lines, add missing ones, remove nothing.

MID
fence gitignore templates/.antigravityignore
cat <<'TAIL'
3. Create a project `GEMINI.md` at the root (max 15 lines) **only if none exists**: project name and detected stack, active source folders, root memory files (`README.md`, `HANDOFF.md`, `LESSONS.md`, `PROGRESS.md`) if present, and forbidden zones. If one exists, do not touch it.
4. Check that `.env` and `.env.*` are in the project's `.gitignore`; if not, tell the user (do not edit it unasked).

---

## Final report (4 points)

1. Core and skills: installed / updated / skipped / kept (modified), and the skills directory used.
2. Detected stack and active source folders.
3. Extra folders added to the ignore files.
4. Whether a project `GEMINI.md` was created or left untouched.
TAIL
} > "$out"
