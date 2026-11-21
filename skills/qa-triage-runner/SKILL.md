---
name: qa-triage-runner
description: Run automated tests / QA with filtered output and a concise failure summary.
---

- Triggered when running automated tests / QA (Playwright, Jest, Pytest, Flutter test, Bash scripts, and similar).
- Always cap output (`| tail -n 50`, or save to `/tmp/qa_last.log` then `grep -iE "fail|error|timeout|assert" /tmp/qa_last.log | head -n 30`).
- Never read a full HTML dump, trace zip, or screenshot folder unless explicitly asked.
- Summarize the result in 3 points: Pass / Fail, failure location (`file:line`), and root cause (2 sentences).
