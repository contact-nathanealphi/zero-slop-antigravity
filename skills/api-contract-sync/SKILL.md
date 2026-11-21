---
name: api-contract-sync
description: Keep endpoint, payload, and JSON response contracts in sync between backend and frontend.
---

- Triggered when changing an endpoint, payload, JSON response, or API model.
- Identify only the endpoints and fields that changed, then run a targeted `grep` in the counterpart repo / folder (never a full scan).
- Verify JSON parsing, null-safety, and error handling on both sides, then report the sync status in 2–3 sentences.
