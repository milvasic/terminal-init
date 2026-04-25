# Project Guidelines

## Overview

`terminal-init` is a single-file Bash script (`./init.sh`) that provisions a Debian/Ubuntu terminal environment. It installs base packages, oh-my-zsh, zinit plugins, a spaceship prompt config, motd, and mcli — then wires everything together in `~/.zshrc`.

The script is designed to be run once on a fresh machine via a `curl | sh` one-liner.

## Code Style

- Bash with `set -euo pipefail`
- Step output follows the pattern: `[STEP]`, `[OK]`, `[SKIP]`, `[INFO]`, `[ERROR]`
- Each major step is wrapped in a clearly labelled section comment block
- Errors are non-fatal: `report_error()` prints a message and continues (no `exit 1` mid-script)
- Variables for paths are declared near the top (`USER_HOME`, `ZSHRC`, `SPACESHIP_CFG`, `MOTD_SH`)

## Architecture

- **Single file**: All logic lives in `./init.sh` — no external scripts or libraries beyond what is curled at runtime
- **Idempotency**: Every step checks whether the work is already done and emits `[SKIP]` rather than re-running
- **Backups**: Existing config files (`~/.zshrc`, `.spaceshiprc.zsh`) are backed up with a `.bak` suffix before overwriting
- **Error accumulation**: `report_error()` logs failures without stopping the script; the final message indicates completion regardless

## Conventions

- New steps follow the numbered section pattern: add a comment block, a `[STEP]` echo, a skip guard, an action, and an `[OK]` / `report_error` pair
- Heredoc config blocks use `<<'EOF'` (single-quoted) to prevent variable expansion inside the written file
- External tools (motd, mcli) are installed via their own `install.sh` with `--yes` for non-interactive execution
- Keep the script Debian/Ubuntu only; do not add support for other distros
- Update `README.md` whenever the script changes (new steps, new packages, new tools)
- Format all Markdown files with `prettier` after editing (`prettier --write *.md`)

## Validation

There is no test suite. After making changes, verify syntax with:

```sh
bash -n init.sh
```

Then do a quick smoke-test by running the script on a fresh Debian/Ubuntu environment (VM or container) and confirming all `[OK]` / `[SKIP]` lines appear as expected.
