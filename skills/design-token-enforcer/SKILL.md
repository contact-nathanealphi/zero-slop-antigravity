---
name: design-token-enforcer
description: Use when styling a UI component or page. Forces project color, typography, and spacing tokens so dark and light mode stay consistent.
---

- Find the project's tokens / theme / CSS variables first (targeted `rg`, not a scan).
- Never hardcode raw hex / RGB colors or arbitrary font sizes and spacing inside a component; use the tokens.
- If a needed token does not exist, use the closest one and flag it; do not invent a parallel system.
