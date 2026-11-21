# Master Prompt — Universal v2 (English)

> Copy-paste this whole prompt into Antigravity. No bash script needed.
> It is **idempotent**: if the Global Core and skills are already installed,
> Phases 1–2 are skipped and only the local project setup (Phase 3) runs.
> Add the words `force update` anywhere in your message to reinstall everything.

---

Initialize the **Quota-Efficient, Anti-Slop, Secret Guard & Auto-Router (15 Skills)** system in this active workspace.

## Mandatory execution rules (read first)

1. **Idempotent (no waste when switching projects):** Check whether `~/.gemini/GEMINI.md` and `~/.agent/skills/anti-slop-strict/SKILL.md` already exist.
   - If they **already exist** and this prompt does **not** contain the words `force update`, **skip Phases 1 and 2 entirely** and do **Phase 3 only**.
   - If they **do not exist** (or `force update` is present), do Phases 1, 2, and 3.
2. **1-shot batch execution:** When doing Phases 1–2, **do not create the 16 files one by one with separate write tools**. Write all global files (1 `GEMINI.md` + 15 `SKILL.md`) in **a single `bash` execution** (`mkdir -p` + `cat << 'EOF'`).
3. **YAML frontmatter is mandatory:** Every `SKILL.md` in Phase 2 **must** start with:
   ```yaml
   ---
   name: <skill-name>
   description: <one-sentence trigger description>
   ---
   ```

---

## Phase 1: Global Core & Skill Router (`~/.gemini/GEMINI.md`)

Write `~/.gemini/GEMINI.md` with exactly this content:

```markdown
# Global Core: Quota-Efficient, Anti-Slop, Secret Guard & Skill Router

## 1. Token-Leak Prevention, Anti-Hallucination & Secret Guard (MANDATORY)
- **No Blind Scan:** Never run `glob` / `grep` / `ls -R` from the repo root (`.`) without a specific target subfolder. Ignore `node_modules/`, `vendor/`, `.venv/`, `venv/`, `.git/`, `dist/`, `build/`, `.next/`, `.dart_tool/`, `.gradle/`, `Pods/`, `backups/`, `*.lock`, `*.sql`, archives, and media files.
- **Batch & Partial Reads:** Read multiple files in parallel in a single turn. For files over 200 lines, read only the relevant line range.
- **Anti-Hallucination:** Accuracy outranks token savings. If extra context is needed to get the code right, read the relevant section — never guess the contents of code you have not read.
- **Secret Guard:** Never read `.env` (except `.env.example`), `*.pem`, or `*.key`, and never print API keys, passwords, tokens, or other credentials to chat or logs.
- **Filter Terminal Output:** When running builds, tests, or QA, always filter output (`| tail -n 40` or `| grep -iE "error|fail|exception"`). Never dump raw logs in full.
- **No Code Echo:** After editing a file with a tool, do not rewrite long code blocks in chat. State `file:line` plus a short 2–3 sentence explanation of what changed and why.
- **Orchestrator Brake:** Do not fan out to parallel sub-agents when a task touches fewer than 3 files or a single module.

## 2. Session Memory & Workflow (Plan-First, Autonomous)
- **Read Local Memory:** At the start of a new session, if `LESSONS.md` or `HANDOFF.md` exists at the project root, read it first so past mistakes are not repeated.
- **Plan Phase:** At the start of a new task, write `Active skills: [...]`, then a concise plan (max 5–7 points: target files, main changes, verification). Wait for one user approval.
- **Autonomous Execution:** Once approved (`gas` / `ok` / `go`), complete every step end to end without asking for permission again.
- **Emergency Brake:** Stop only if the same error occurs **2 times in a row**, or a decision is genuinely needed. Report briefly with 2 solution options.

## 3. Model Advisor & Context Hygiene (MANDATORY at the End of Every Plan / Task)
Always close with this short block:
> **Quota & Model Tip:**
> - **Model recommendation:** Use **Gemini 4 Hydrogen** (`/model gemini-4-hydrogen`) for a clear plan, UI edits, light bugs, or running tests / QA. Use **Gemini 4 Neon** (`/model gemini-4-neon`, thinking `medium` / `low`) ONLY for new architecture, complex cross-repo integration, or hard debugging.
> - **Context:** Suggest `/compact` if the chat exceeds 10 turns, or run `session-handoff` then `/clear` when one feature is done.

## 4. Skill Router (`~/.agent/skills/`) — HARD CAP: MAX 2 SKILLS PER TASK
**Router rule:** Load at most **1 primary skill + 1 guard skill**, matching the table below. Never load 3 or more skills at once. Always name the active skills on the first line of the Plan.

| Task trigger | Skill to load |
| :--- | :--- |
| Large task (> 5 files) / massive refactor | `ultra-quota-guard` |
| User types "checkpoint" / before `/clear` | `session-handoff` |
| User corrects a repeated pattern or technical choice | `lesson-learner` |
| One large feature or QA stage is done | `rekap-auto-updater` |
| Editing a shared function, core, helper, or global state | `blast-radius-analyzer` |
| New feature using a third-party library | `version-lock-guard` |
| Executing a plan that changes >= 2 files (guard) | `git-safety-net` |
| Touching a migration, table, query, or ORM | `db-schema-guard` |
| Writing a new feature, module, or page from scratch | `anti-slop-strict` |
| Changing an endpoint, payload, or API model | `api-contract-sync` |
| Creating or reworking a page or UI component | `edge-state-checklist` |
| UI styling, colors, typography, or dark / light mode | `design-token-enforcer` |
| Fixing a bug, crash, or build error | `surgical-debugger` |
| Running automated tests / QA | `qa-triage-runner` |
| Final review before reporting done, on critical logic (guard) | `adversarial-reviewer` |
```

---

## Phase 2: 15 Modular Skills (`~/.agent/skills/<name>/SKILL.md`)

Create 15 `SKILL.md` files, each with valid YAML frontmatter (`name` and `description`), with these concise rules:

1. **`ultra-quota-guard`** — Diff-first: run `git status -s` and `git diff --stat` before reading files in full. Surgical edit: change only the relevant function block, never rewrite a whole file. Budget check: if a task touches > 5 files across folders, offer to split it into 2 sessions with a `session-handoff` in between. Report in 2–3 sentences plus file list and verification result.
2. **`session-handoff`** — Triggered by "checkpoint", "handoff", or when one feature is done. Write / overwrite `HANDOFF.md` at the workspace root (max 25 lines): last status, files changed, Git status (branch and hash), blockers, and next steps (1–3 points). Tell the user it is safe to run `/clear`; a new session only needs `@HANDOFF.md continue`.
3. **`lesson-learner`** — Triggered when the user corrects a repeated mistake, library choice, or code style. Append at most 1–2 lines of permanent rules to `LESSONS.md` at the project root (create it if missing) as `- [Context]: Do not do X, always use Y.` Confirm briefly that the lesson was recorded.
4. **`rekap-auto-updater`** — Triggered when one large feature or QA stage is verified done. Find the recap / progress file at the root (`PROGRESS.md`, `HANDOFF.md`, or `rekap*.md`). Read it partially, then append a concise update (max 3–5 lines: date, feature finished, main files changed) without rewriting the whole file.
5. **`blast-radius-analyzer`** — Triggered before changing a shared function signature, helper, core model, or global state. Run a targeted `grep` to find all callers / consumers in the source folders. List every affected file in the Plan before editing.
6. **`version-lock-guard`** — Triggered when writing code that uses a third-party library / framework. Read the exact installed version first from `package.json`, `pubspec.yaml`, `composer.json`, or `requirements.txt`. Make sure every API, import, and syntax matches the installed version 100% (no deprecated APIs, no APIs from a version that is not installed).
7. **`git-safety-net`** — Triggered automatically before a plan that changes >= 2 files or a refactor. Check `git status -s`. If there are uncommitted changes, back up with `git add -A && git commit -m "wip: safety backup before <task-summary>"`. After execution passes verification, make a clean commit (Conventional Commits). Final report must include repo, branch, backup commit hash (for rollback), and final commit hash. Never `git push --force`, `git reset --hard`, or delete a branch without an explicit user instruction.
8. **`db-schema-guard`** — Triggered when touching a database, query, ORM, or migration. Never open or search SQL dump files (`*.sql` or `*.sql.gz`). Use only `migrations/`, `schema`, ORM models, or light queries (`DESCRIBE` / `SHOW TABLES`). Always ask for explicit confirmation before a destructive command (`DROP`, `TRUNCATE`, `migrate:fresh`, or `DELETE` without `WHERE`).
9. **`anti-slop-strict`** — Seven pillars: (1) **Strict mimicry:** read 1–2 similar files first; follow the repo's naming, folder structure, state management, and error handling exactly. (2) **Zero obvious comments:** comments explain *why* only, never *what*. (3) **Rule of Three:** no factory / manager / base class / helper for logic used only 1–2 times. (4) **No defensive slop:** no empty `try/catch`, no swallowing errors with `console.log` alone, no excessive `null` checks on values guaranteed by type. (5) **Zero placeholders:** no `// TODO`, `// ... rest of code`, or mock data pretending to be finished. (6) **Anti-slop UI:** no generic AI aesthetics (neon purple-blue gradients, excessive glassmorphism, heavy shadows, random emojis, cliche copy). (7) **Minimal diff:** no reformatting, import re-sorting, or renaming outside the task scope.
10. **`api-contract-sync`** — Triggered when changing an endpoint, payload, JSON response, or API model. Identify only the endpoints and fields that changed, then run a targeted `grep` in the counterpart repo / folder (never a full scan). Verify JSON parsing, null-safety, and error handling on both sides, then report the sync status in 2–3 sentences.
11. **`edge-state-checklist`** — Triggered when creating or reworking a page / UI component. Handle all 4 states explicitly (no happy-path only): **Loading** (skeleton / indicator), **Empty** (message and action when data is empty), **Error** (clear message plus a retry button), and **Overflow** (long text / small screens must not break the layout).
12. **`design-token-enforcer`** — Triggered when styling a UI component / page. Check the project theme / tokens / CSS variables first. Never hardcode raw hex / RGB colors or arbitrary font sizes / spacing inside a component; always use the project tokens / theme so dark and light mode stay consistent.
13. **`surgical-debugger`** — Triggered when fixing a bug, exception, or build error. Take the main error message plus the top stack-trace line that points to project code (ignore framework / SDK frames). Read only about 30 lines around the error, then form the single strongest hypothesis before editing. Verify with the fastest check first. If the same error fails 2 times in a row, stop, clean up unnecessary changes, and report 2 options to the user.
14. **`qa-triage-runner`** — Triggered when running automated tests / QA (Playwright, Jest, Pytest, Flutter test, Bash scripts, and similar). Always cap output (`| tail -n 50`, or save to `/tmp/qa_last.log` then `grep -iE "fail|error|timeout|assert" /tmp/qa_last.log | head -n 30`). Never read a full HTML dump, trace zip, or screenshot folder unless explicitly asked. Summarize in 3 points: Pass / Fail, failure location (`file:line`), and root cause (2 sentences).
15. **`adversarial-reviewer`** — Triggered before reporting done, on critical logic changes or large features. Run `git diff` only on the files just changed, then audit with a senior-engineer lens: null / undefined edge cases, race conditions, N+1 queries, memory leaks (listeners / controllers never disposed), input-validation gaps, and leftover slop. Fix a real bug directly before reporting done.

---

## Phase 3: Local Auto-Setup for This Active Workspace

1. Inspect the active folder structure shallowly only (max depth 2, for example `ls -la`). Never read large files or enter dependency / SDK / backup folders.
2. Create or update `.antigravityignore` at this project root with the universal list below, **plus** any other heavy / SDK / backup / media / dump folders you detect at the root:
   - Secrets & keys: `.env`, `.env.*`, `!.env.example`, `*.pem`, `*.key`, `*credentials*.json`, `*secret*`
   - Dependencies & env: `node_modules/`, `**/node_modules/`, `vendor/`, `**/vendor/`, `.venv/`, `venv/`, `**/__pycache__/`
   - Build & cache: `dist/`, `**/dist/`, `build/`, `**/build/`, `.next/`, `**/.next/`, `.dart_tool/`, `**/.dart_tool/`, `.gradle/`, `**/.gradle/`, `**/ios/Pods/`, `target/`, `coverage/`, `.cache/`
   - Git, lockfile & log: `.git/`, `**/.git/`, `*.lock`, `package-lock.json`, `**/package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `pubspec.lock`, `composer.lock`, `**/*.log`
   - Dump, archive & media: `*.sql`, `*.sql.gz`, `*.sqlite`, `*.tar.xz`, `*.tar.gz`, `*.zip`, `backups/`, `**/*.png`, `**/*.jpg`, `**/*.jpeg`, `**/*.mp4`, `**/*.pdf`
3. Create a `GEMINI.md` at this project root (max 15 lines) with:
   - Project name and main tech stack you detected.
   - The active source folders the agent may touch.
   - Root map / memory files (`README.md`, `HANDOFF.md`, `LESSONS.md`, `PROGRESS.md`, or `rekap*.md` if any exist).
   - Forbidden zones (heavy folders and secrets that are blocked).

---

## Final output

Report concisely in 4 points:

1. Status of Phases 1–2 (freshly installed via 1-shot batch, or skipped because already installed).
2. Tech stack and active source folders detected in this project.
3. Extra local folders / files blocked in `.antigravityignore`.
4. Confirmation that the local `GEMINI.md` is active and ready to use.
