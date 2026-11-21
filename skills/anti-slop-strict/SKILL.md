---
name: anti-slop-strict
description: Use when writing a new feature, module, or page from scratch. Keeps code repo-native, minimal, and free of placeholders.
---

1. **Strict mimicry:** read 1–2 similar files first; follow the repo's naming, folder structure, state management, and error handling exactly.
2. **Zero obvious comments:** comments explain *why* (business rule, workaround), never *what*.
3. **Rule of Three:** no factory / manager / base class / helper for logic used only 1–2 times.
4. **No defensive slop:** no empty `try/catch`, no swallowing errors with `console.log` alone, no `null` checks on values guaranteed by type.
5. **Zero placeholders:** no `// TODO`, `// ... rest of code`, or mock data posing as finished work.
6. **Anti-slop UI:** no generic AI look (neon purple-blue gradients, heavy glassmorphism, heavy shadows, random emojis, cliche copy).
7. **Minimal diff:** no reformatting, import re-sorting, or renames outside the task scope.
