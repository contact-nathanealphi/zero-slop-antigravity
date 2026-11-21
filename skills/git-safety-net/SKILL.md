---
name: git-safety-net
description: Use before executing a plan that changes 2+ files or a refactor. Creates a local rollback point and reports hashes. Never pushes.
---

- Not a git repo: say so and skip.
- Record branch and `git rev-parse --short HEAD` as the base hash.
- If tracked files have uncommitted changes (`git status -s`), save a rollback point without touching history: `h=$(git stash create)` then `git stash store -m "zs-backup: <task>" "$h"`. Restore with `git stash apply <hash>`.
- Never `git add -A`; never stage untracked files or anything matching the Secret Guard list.
- After verification, commit (Conventional Commits, only files changed by this task) **only if** the approved plan said "commit" or the user asked.
- Final report: repo, branch, base hash, backup hash (if any), final commit hash (if any).
- Never `git push`, `push --force`, `reset --hard`, `clean`, or delete a branch without an explicit instruction.
