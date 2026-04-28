# Project Guidelines

## Overview

`terminal-init` is a single-file Bash CLI (`./terminal-init`) that provisions a Debian/Ubuntu terminal environment. It installs base packages, oh-my-zsh, Zinit plugins, a Spaceship prompt config, motd, and mcli — then wires everything together in `~/.zshrc`.

A companion `install.sh` handles installation, upgrades, and uninstallation of `terminal-init` to `/usr/local/bin`. The `update` command in `terminal-init` invokes it directly via `curl`.

## Code Style

- Bash with `set -euo pipefail` and `#!/usr/bin/env bash` shebang
- Functions use snake_case and are named after commands (e.g., `help`, `ensure_tools`, `ensure_config`, `update`)
- Color-coded output via ANSI escape sequences with TTY detection (`[ -t 1 ]`); disabled for pipes/redirects
- Output goes to stderr for `log()`, `error()`, `step()`, `skip()`, `info()` helpers; stdout for `ok()`
- Commands that may fail in pipes or substitutions use `|| true` to stay compatible with `set -euo pipefail`
- Section headers use the short format: `# ── section name ──`

## Architecture

- **Single file**: All logic lives in `./terminal-init` — no external scripts or libraries
- **Idempotency**: Every step checks whether the work is already done and emits `[skip]` rather than re-running
- **Backups**: Existing config files (`~/.zshrc`, `.spaceshiprc.zsh`) are backed up with a `.bak` suffix before overwriting
- **Error accumulation**: `report_error()` logs failures without stopping the script; the final message indicates completion regardless
- **External tools**: motd and mcli are installed via their own `install.sh` with `--yes` for non-interactive execution

## Conventions

- New commands follow the existing pattern: define a function, add a case in the dispatch block
- Heredoc config blocks use `<<'EOF'` (single-quoted) to prevent variable expansion inside the written file
- Errors are non-fatal: `report_error()` prints a message and continues (no `exit 1` mid-script)
- Variables for paths are declared near the top (`USER_HOME`, `ZSHRC`, `SPACESHIP_CFG`)
- Keep the script Debian/Ubuntu only; do not add support for other distros
- Help text uses the `colorize()` function to color-code output based on command names and options (see `colorize_line()` for rules)
- Update the `help()` function whenever the script changes (bug fixes, new features, new options)
- Update `README.md` whenever the script changes (new features, changed behavior)
- Format all Markdown files with `prettier` after editing (`prettier --write *.md`)

## Versioning

The version is hardcoded as `VERSION` near the top of `./terminal-init`. Follow semver:

- **Patch** (`0.1.x`): bug fixes, behavioral tweaks, internal refactors
- **Minor** (`0.x.0`): new commands, new install steps, new configurations
- **No bump**: doc-only changes (`README.md`, `AGENTS.md`, comments)

When bumping the version, also regenerate `install.sh` so the generated-by comment stays current.

## Validation

There is no test suite. After making changes, verify syntax with:

```sh
bash -n terminal-init
bash -n install.sh
bash -n install-regen.sh
```

Then do a quick smoke-test by running:

```sh
./terminal-init help
./terminal-init version
./terminal-init ensure-config
./terminal-init update
```

Verify that help text displays correctly with colorized output.
