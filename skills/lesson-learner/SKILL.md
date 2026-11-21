---
name: lesson-learner
description: Use when the user corrects a repeated mistake, library choice, or code style. Appends one permanent rule to LESSONS.md.
---

- Append at most 1–2 lines to `LESSONS.md` at the project root (create if missing): `- [Context]: Do not do X, always use Y.`
- Grep first; skip if an equivalent rule already exists.
- Keep the file at 40 lines or fewer: if exceeded, merge duplicates and drop the weakest lines before appending.
- Never store secrets or personal data. Confirm in one short line.
