#!/usr/bin/env bash

set -euo pipefail

# Trap errors per command without stopping the whole script
report_error() {
    echo -e "\n[ERROR] $1 failed. Continuing...\n"
}

USER_HOME="$HOME"
ZSHRC="$USER_HOME/.zshrc"
SPACESHIP_CFG="$USER_HOME/.config/.spaceshiprc.zsh"

echo "=== Debian Initialization Script ==="

# ---------------------------------------------------------------------
# 1. Install required packages
# ---------------------------------------------------------------------
echo "[STEP] Installing base packages (curl git zsh figlet ncdu)..."

if sudo apt update && sudo apt install -y curl git zsh figlet ncdu; then
    echo "[OK] Packages installed."
} else {
    report_error "Package installation"
}

# ---------------------------------------------------------------------
# 2. Install oh-my-zsh
# ---------------------------------------------------------------------
echo "[STEP] Installing oh-my-zsh..."

if RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo "[OK] oh-my-zsh installed."
} else {
    report_error "oh-my-zsh installation"
}

# ---------------------------------------------------------------------
# 3. Set ZSH as default shell
# ---------------------------------------------------------------------
echo "[STEP] Setting zsh as default shell..."

if chsh -s "$(command -v zsh)"; then
    echo "[OK] Shell changed to zsh."
} else {
    report_error "chsh command"
}

# ---------------------------------------------------------------------
# 4. Write .zshrc
# ---------------------------------------------------------------------
echo "[STEP] Creating ~/.zshrc ..."

cat > "$ZSHRC" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
export PATH=:/usr/sbin:$PATH
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export SPACESHIP_CONFIG="$HOME/.config/.spaceshiprc.zsh"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# alias python="python3"
ZSH_THEME="robbyrussell"
plugins=(git docker docker-compose)

source $ZSH/oh-my-zsh.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Plugin Manager …%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
}

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light spaceship-prompt/spaceship-prompt
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

alias clear-shell-history="echo '' > ~/.zsh_history"
alias clear-journal="sudo journalctl --rotate && sudo journalctl --vacuum-time=1s"
alias disk-usage="cd / && sudo ncdu && cd - > /dev/null"
alias dps="docker ps -a --format \"table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.Size}}\""
alias dpsp="docker ps -a --format \"table {{.Names}}\t{{.State}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}\""
alias listen-ports="sudo lsof -i -P -n | grep LISTEN"

[ -x "$(command -v motd)" ] && motd
EOF

if [ $? -eq 0 ]; then
    echo "[OK] .zshrc created."
} else {
    report_error ".zshrc creation"
}

# ---------------------------------------------------------------------
# 5. Create ~/.config/.spaceshiprc.zsh
# ---------------------------------------------------------------------
echo "[STEP] Creating spaceship configuration..."

mkdir -p "$USER_HOME/.config"

cat > "$SPACESHIP_CFG" << 'EOF'
SPACESHIP_USER_SHOW=always
SPACESHIP_HOST_SHOW=always
SPACESHIP_TIME_SHOW=true
SPACESHIP_CHAR_SYMBOL_ROOT="# "

SPACESHIP_HG_SHOW=false
SPACESHIP_HG_BRANCH_SHOW=false
SPACESHIP_HG_STATUS_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_XCODE_SHOW_LOCAL=false
SPACESHIP_SWIFT_SHOW_LOCAL=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_HASKELL_SHOW=false
SPACESHIP_JULIA_SHOW=false
SPACESHIP_DOCKER_CONTEXT_SHOW=false
SPACESHIP_AWS_SHOW=false
SPACESHIP_VENV_SHOW=false
SPACESHIP_CONDA_SHOW=false
SPACESHIP_PYTHON_SHOW=false
SPACESHIP_EMBER_SHOW=false
SPACESHIP_KUBECTL_SHOW=false
SPACESHIP_KUBECTL_CONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_BATTERY_SHOW=false
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_JOBS_SHOW=false
SPACESHIP_EXIT_CODE_SHOW=false

SPACESHIP_PROMPT_ORDER=(host time user dir git node dotnet docker exec_time char)
EOF

if [ $? -eq 0 ]; then
    echo "[OK] Spaceship config created."
} else {
    report_error "spaceship config creation"
}

# ---------------------------------------------------------------------
# 6. Install motd
# ---------------------------------------------------------------------
echo "[STEP] Installing motd..."

if sh -c "$(curl -fsSL https://raw.githubusercontent.com/milvasic/motd/refs/heads/main/install.sh)" -- --yes; then
    echo "[OK] motd installed."
} else {
    report_error "motd installation"
}

# ---------------------------------------------------------------------
# 7. Install mcli
# ---------------------------------------------------------------------
echo "[STEP] Installing mcli..."

if sh -c "$(curl -fsSL https://raw.githubusercontent.com/milvasic/mcli/refs/heads/main/install.sh)" -- --yes; then
    echo "[OK] mcli installed."
} else {
    report_error "mcli installation"
}

# ---------------------------------------------------------------------
echo -e "\n=== Initialization complete ==="
echo "Restart your terminal or log out/in to activate zsh."