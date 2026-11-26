# Changelog

## [3.0.1]

**Fixes**
- Fixed `shellcheck` warnings (`SC2012`, `SC2045`, `SC2015`) across `install.sh` and `scripts/*.sh` so CI validation passes cleanly.
- Installer now checks for both `<!-- zero-slop:begin -->` and `<!-- zero-slop:end -->` markers before replacing or stripping the managed block.
- Installer warns when an existing `# Global Core` section is detected outside the managed block to prevent duplicate rules.

**Improvements**
- Refined `core/GEMINI.md` and `README.md` to allow trivial 2-file mechanical edits without a full plan and clarify sequential phases for cross-layer tasks.
- Added modern build/test cache patterns (`.turbo/`, `.nuxt/`, `.svelte-kit/`, `.pytest_cache/`, `.mypy_cache/`, `.ruff_cache/`, `*.tsbuildinfo`) to `templates/.antigravityignore`.
- Expanded CI installer smoke test to cover `--init-local`.

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
