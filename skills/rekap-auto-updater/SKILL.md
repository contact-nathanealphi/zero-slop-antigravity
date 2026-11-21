---
name: rekap-auto-updater
description: Use after one large feature or QA stage is verified done. Appends 3–5 lines to PROGRESS.md and never touches HANDOFF.md.
---

- Target `PROGRESS.md` at the root (or an existing `rekap*.md`); create `PROGRESS.md` if none exists.
- Read only the last ~20 lines, then append 3–5 lines: date, feature finished, main files changed. Never rewrite the file.
- Never edit `HANDOFF.md` (owned by `session-handoff`).
