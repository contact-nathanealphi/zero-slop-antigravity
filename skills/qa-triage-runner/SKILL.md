---
name: qa-triage-runner
description: Use when running automated tests or QA such as Playwright, Jest, Pytest, or Flutter test. Caps output and summarizes failures concisely.
---

- Always cap output: `| tail -n 50`, or save to a temp file outside the repo (`mktemp`) and `grep -iE "fail|error|timeout|assert" <file> | head -n 30`. PowerShell: `| Select-Object -Last 50`.
- Never read full HTML reports, trace zips, or screenshot folders unless asked.
- Summarize in 3 points: Pass / Fail, failure location (`file:line`), root cause (2 sentences).
