---
name: api-contract-sync
description: Use when changing an endpoint, payload, JSON response, or API model. Keeps backend and frontend contracts in sync.
---

- List only the endpoints and fields that changed.
- Run a targeted `rg` in the counterpart repo / folder (never a full scan) for each changed endpoint or field.
- Verify JSON parsing, null-safety, and error handling on both sides.
- If the change is breaking, list consumers and propose a backward-compatible path.
- Report sync status in 2–3 sentences.
