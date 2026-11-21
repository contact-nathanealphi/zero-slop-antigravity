---
name: session-handoff
description: Save a session summary to HANDOFF.md before /clear or at a feature checkpoint.
---

- Triggered when the user types "checkpoint" or "handoff", or when one feature is done.
- Write / overwrite `HANDOFF.md` at the workspace root (max 25 lines): last status, files changed, Git status (branch and hash), blockers, and next steps (1–3 points).
- Tell the user it is safe to run `/clear`; a new session only needs to type `@HANDOFF.md continue`.
