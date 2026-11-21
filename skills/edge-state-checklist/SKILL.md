---
name: edge-state-checklist
description: Use when creating or reworking a page or UI component. Ensures Loading, Empty, Error, and Overflow are handled explicitly.
---

Handle all four states (no happy-path only):
- **Loading:** skeleton or indicator.
- **Empty:** message plus a next action.
- **Error:** clear message plus a retry action.
- **Overflow:** long text and small screens must not break the layout.

Also block double-submit while a request is in flight.
