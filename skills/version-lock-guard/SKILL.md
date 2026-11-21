---
name: version-lock-guard
description: Make sure third-party library APIs and syntax match 100% of the version installed in the project.
---

- Triggered when writing code that uses a third-party library or framework.
- Read the exact installed version first, from `package.json`, `pubspec.yaml`, `composer.json`, or `requirements.txt`.
- Make sure every API, import, and syntax matches the installed version exactly (never use a deprecated API or one from a version that is not installed).
