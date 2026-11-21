---
name: edge-state-checklist
description: Make sure UI components handle Loading, Empty, Error, and Overflow explicitly.
---

- Triggered when creating or reworking a page or UI component.
- Handle all 4 states explicitly (no happy-path only): **Loading** (skeleton / indicator), **Empty** (message and action when data is empty), **Error** (clear message plus a retry button), and **Overflow** (long text / small screens must not break the layout).
