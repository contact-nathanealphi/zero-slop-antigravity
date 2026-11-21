---
name: blast-radius-analyzer
description: Map every caller of a shared function, helper, or global state before changing it.
---

- Triggered before changing the signature of a shared function, helper, core model, or global state.
- Run a targeted `grep` to find all callers / consumers in the source folders.
- List every affected file in the Plan before editing, so no other feature breaks silently.
