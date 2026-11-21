# Changelog

## [3.0.0]

**Fixes**
- `adversarial-reviewer` no longer audits an empty diff (uses the base hash; runs before the final commit) and only fixes bugs inside the approved plan scope.
- `version-lock-guard` reads the *installed* version (`npm ls`, `pip show`, single-package lockfile lookup) instead of manifest ranges.
- `git-safety-net` no longer runs `git add -A`; rollback point is a local `git stash create`; commits only when the plan says so; never pushes.
- `rekap-auto-updater` writes `PROGRESS.md`; `HANDOFF.md` belongs only to `session-handoff`.
- `.antigravityignore`: `migrations/*.sql` readable; `*secret*` no longer blocks source files; images no longer blocked globally.
- Installer: fixed local-vs-piped detection, atomic staged download, SHA256 verification, accurate summary.

**Added**
- Core: broader Secret Guard, global destructive-command confirmation, small-task fast path, typed router (Work / Guard / Memory) with priorities, conditional model tip, Windows equivalents.
- Installer: managed block in `GEMINI.md` (user content preserved), `--dry-run`, `--uninstall`, `--no-verify`, `ZS_REF` pinning, `ZS_SKILLS_DIR`.
- `scripts/` (build, checksums, validate) and CI; `MASTER_PROMPT.md` is now generated.
- Skill descriptions now contain the trigger (used for discovery).

## [2.0.0]
Initial public version: Global Core, 15 skills, installer, master prompt.
