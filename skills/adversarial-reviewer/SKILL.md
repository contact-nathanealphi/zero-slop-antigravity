---
name: adversarial-reviewer
description: Run a strict git-diff audit before reporting done, to catch hidden bugs, memory leaks, and validation gaps.
---

- Triggered before reporting done, on critical logic changes or large features.
- Run `git diff` only on the files just changed, then audit with a senior-engineer lens: null / undefined edge cases, race conditions, N+1 queries, memory leaks (listeners / controllers never disposed), input-validation gaps, and leftover slop.
- Fix a real bug directly before reporting done to the user.
