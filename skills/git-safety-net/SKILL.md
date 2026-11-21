---
name: git-safety-net
description: Automatic Git safety net with a backup commit before any plan that changes 2+ files, and a clean commit after verification.
---

- Triggered automatically before executing a plan that changes 2 or more files, or a refactor.
- Check `git status -s` in the relevant repo. If there are uncommitted changes, create a backup: `git add -A && git commit -m "wip: safety backup before <task-summary>"`.
- After execution finishes and passes verification, make a clean commit (Conventional Commits).
- Final report must include: repo, branch, backup commit hash (for rollback), and final commit hash.
- Never run `git push --force`, `git reset --hard`, or delete a branch without an explicit user instruction.
