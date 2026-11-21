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
