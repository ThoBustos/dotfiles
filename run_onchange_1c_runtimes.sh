#!/bin/bash
# Language runtimes: Bun, Node via fnm
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
    exit 0
fi
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
fnm use --lts
