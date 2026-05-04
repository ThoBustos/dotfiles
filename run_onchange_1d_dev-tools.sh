#!/bin/bash
# Dev tools: Bun, Python+Node via mise, GitHub CLI auth, tmux plugin manager, npm globals
set -euo pipefail

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Python 3.12.2 + Node 22.14.0 via mise
# mise reads per-project .tool-versions automatically; globals are just fallbacks
# Use shim PATH directly — mise activate is for interactive shells only
if command -v mise &>/dev/null; then
    export PATH="${MISE_DATA_DIR:-$HOME/.local/share/mise}/shims:$PATH"
    mise use --global python@3.12.2
    mise use --global node@22.14.0
    echo "mise globals set: python@3.12.2, node@22.14.0"
else
    echo "Warning: mise not found — skipping Python/Node setup (fix Brewfile failures first)"
fi

# Bun
if ! command -v bun &>/dev/null; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun already installed"
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
