#!/bin/bash
# Dev tools: Bun, Node via fnm, GitHub CLI auth, tmux plugin manager, npm globals
set -euo pipefail

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Bun
if ! command -v bun &>/dev/null; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun already installed"
fi

# Node LTS via fnm
if ! command -v fnm &>/dev/null; then
    echo "Warning: fnm not found — skipping Node setup (fix Brewfile failures first)"
else
    eval "$(fnm env)"
    fnm install --lts
    fnm default lts-latest
fi

# GitHub CLI auth
if ! command -v gh &>/dev/null; then
    echo "Warning: gh not found — skipping GitHub CLI auth (fix Brewfile failures first)"
elif ! gh auth status &>/dev/null; then
    echo "Logging into GitHub CLI..."
    gh auth login
else
    echo "GitHub CLI already authenticated"
fi

# tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed"
fi

# npm globals
if command -v npm &>/dev/null; then
    echo "Installing npm global tools..."
    npm install -g @anthropic-ai/claude-code
    npm install -g @openai/codex
else
    echo "Warning: npm not found — skipping global installs (fix Brewfile failures first)"
fi
