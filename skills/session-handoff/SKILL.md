---
name: session-handoff
description: Use only when the user says checkpoint or handoff, or is about to run /clear. Writes a HANDOFF.md of at most 25 lines.
---

- Owns `HANDOFF.md` exclusively. Do not trigger just because a feature finished (that is `rekap-auto-updater`).
- Write / overwrite `HANDOFF.md` at the workspace root, max 25 lines: last status, files changed, git branch and hash, blockers, next steps (1–3).
- Never include secrets, tokens, or `.env` values.
- Tell the user it is safe to run `/clear`; resume with `@HANDOFF.md continue`.
