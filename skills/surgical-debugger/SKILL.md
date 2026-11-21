---
name: surgical-debugger
description: Use when fixing a bug, exception, crash, or build error. Works from the project stack-trace frame without blind edits.
---

- Take the main error message plus the top stack-trace line that points to project code (ignore framework / SDK frames).
- Read about 30 lines around it, then state the single strongest hypothesis before editing.
- Verify with the fastest check first.
- If the same error fails twice in a row, stop, revert only your own edits from this task, and report 2 options.
