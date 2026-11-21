---
name: ultra-quota-guard
description: Use for large tasks touching more than 5 files or massive refactors. Enforces diff-first, surgical edits and a session-split check.
---

- **Diff-first:** run `git status -s` and `git diff --stat` before reading any file in full.
- **Surgical edit:** change only the relevant block; never rewrite a whole file.
- **Budget check:** if the task touches more than 5 files across folders, propose a 2-session split (with a `checkpoint` between) before starting.
- **Report:** 2–3 sentences, the file list, and the verification result.
