---
name: adversarial-reviewer
description: Use before reporting done on critical logic or large features. Audits only this task's diff and reports findings.
---

- Run before any final commit. Diff basis: `git diff <base-hash>` (base from the plan / `git-safety-net`), or `git diff HEAD` when nothing is committed. Only files changed by this task.
- Audit as a senior engineer: null / undefined edges, race conditions, N+1 queries, leaks (listeners / controllers not disposed), input validation, injection / authz on user input, error handling, leftover slop.
- Fix a real bug only if it is inside the approved plan's scope; otherwise report it with `file:line` and do not edit.
- Report in 10 lines or fewer.
