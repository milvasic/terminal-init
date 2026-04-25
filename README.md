# terminal-init

A single-file Bash script that sets up a Debian/Ubuntu terminal environment from scratch.

Run once on a fresh machine to get a fully configured zsh shell with a curated set of tools and plugins.

## What it sets up

- **Base packages** — `curl`, `git`, `zsh`, `ncdu`
- **oh-my-zsh** — framework for managing zsh configuration
- **zsh as default shell** — replaces bash
- **~/.zshrc** — pre-configured with [zinit](https://github.com/zdharma-continuum/zinit), plugins, and aliases
- **Zinit plugins** — [spaceship-prompt](https://github.com/spaceship-prompt/spaceship-prompt), [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-completions](https://github.com/zsh-users/zsh-completions)
- **~/.config/.spaceshiprc.zsh** — spaceship prompt configuration
- **[motd](https://github.com/milvasic/motd)** — message of the day on shell login
- **[mcli](https://github.com/milvasic/mcli)** — Docker Compose service manager

## Usage

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/milvasic/terminal-init/refs/heads/main/init.sh)"
```

The script is idempotent — it skips steps that are already done and backs up existing config files before overwriting them.

After the script completes, restart your terminal or log out and back in to activate zsh.

## Requirements

- Debian or Ubuntu (requires `apt`)
- `curl` or `wget` for the one-liner above (the script installs `curl` itself if run another way)
