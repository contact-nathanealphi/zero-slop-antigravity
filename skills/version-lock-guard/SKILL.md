---
name: version-lock-guard
description: Use when writing code that calls a third-party library or framework. Verifies APIs against the exact installed version.
---

- Get the **installed** version, not the manifest range: `npm ls <pkg> --depth=0` (or pnpm / yarn), `pip show <pkg>`, `composer show <pkg>`, `go list -m <mod>`, or a targeted grep of that single package in the lockfile (`package-lock.json`, `pubspec.lock`, ...). A single-package lockfile lookup is allowed even though lockfiles are ignored for indexing.
- If only the manifest is available, use it and say the version is a range.
- Match every import, API, and syntax to that version. No deprecated APIs, none from a newer version.
- When unsure about a symbol, read only that symbol's declaration in the installed package, not the whole dependency tree.
