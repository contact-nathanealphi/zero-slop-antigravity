---
name: ultra-quota-guard
description: Save tokens on large tasks (>5 files) or massive refactors with diff-first, surgical edits.
---

- Diff-first: run `git status -s` and `git diff --stat` before reading any file in full.
- Surgical edit: change only the relevant function block; never rewrite a whole file.
- Budget check: if a task touches more than 5 files across folders, offer to split it into 2 sessions with a `session-handoff` in between.
- Report in 2–3 sentences plus the file list and verification result.
