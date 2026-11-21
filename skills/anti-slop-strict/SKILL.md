---
name: anti-slop-strict
description: Keep new code clean, repo-native, and free of placeholders or over-engineering.
---

- **Strict mimicry:** Read 1–2 similar files in the repo before writing new code. Follow the existing naming, folder structure, state management, and error handling exactly.
- **Zero obvious comments:** Never write comments that explain *what* the code does (for example `// handle click`). Comments may only explain *why* (a business rule or workaround).
- **Rule of Three (no over-engineering):** Never create a factory, manager, base class, or helper for logic used only 1–2 times. Write it plainly and directly.
- **No defensive slop:** No empty `try/catch`, no swallowing errors with `console.log` alone, and no excessive `null` checks on values that are already guaranteed by type.
- **Zero placeholders:** Never leave `// TODO`, `// ... rest of code`, or mock data pretending to be a finished implementation.
- **Anti-slop UI:** No generic AI aesthetics (neon purple-blue gradients, excessive glassmorphism, heavy shadows, random emojis on buttons / titles, or cliche copy).
- **Minimal diff:** Never reformat, re-sort imports, or rename code outside the task scope.
