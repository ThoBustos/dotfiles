#!/bin/bash
# Dev tools: GitHub CLI auth, tmux plugin manager, npm globals
set -euo pipefail

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# GitHub CLI auth
if ! gh auth status &>/dev/null; then
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
