---
name: blast-radius-analyzer
description: Use before changing the signature or behavior of a shared function, helper, core model, or global state. Maps every caller first.
---

- Run a targeted `rg` for the symbol in source folders only (never the whole repo root).
- Also check indirect use: tests, string references, config, reflection, re-exports.
- List every affected file in the Plan before editing.
- If there are more than ~15 callers, propose a staged change (add new API, migrate callers, remove old).
