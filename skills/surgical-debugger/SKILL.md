---
name: surgical-debugger
description: Fix bugs, crashes, and build errors from the project stack trace, without blind edits.
---

- Triggered when fixing a bug, exception, or build error.
- Take the main error message plus the top stack-trace line that points to project code (ignore framework / SDK frames).
- Read only about 30 lines around the error, then form the single strongest hypothesis before editing.
- Verify with the fastest check first. If the same error fails 2 times in a row, stop, clean up unnecessary changes, and report 2 options to the user.
