#!/bin/bash
# Bootstrap script - runs once on new machine setup
# Managed by Chezmoi

set -euo pipefail

# ----------------------------
# Xcode Command Line Tools
# ----------------------------

if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Waiting for Xcode CLT install to complete (follow the GUI prompt)..."
    until xcode-select -p &>/dev/null; do sleep 5; done
fi

echo "Starting bootstrap..."

# ----------------------------
# Homebrew
# ----------------------------

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to PATH for Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# ----------------------------
# SSH Key Setup
# ----------------------------

if [ ! -f "$HOME/.ssh/id_ed25519_github" ]; then
    echo ""
    echo "No GitHub SSH key found. Generating one..."
    read -p "Enter your email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519_github"
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519_github"
    echo ""
    echo "Your public key (add to https://github.com/settings/keys):"
    cat "$HOME/.ssh/id_ed25519_github.pub"
    echo ""
    read -p "Press Enter once you've added the key to GitHub..."
else
    echo "GitHub SSH key already exists"
fi

# ----------------------------
# NVM + Node
# ----------------------------

if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
else
    echo "NVM already installed"
fi

# ----------------------------
# Bun
# ----------------------------

if ! command -v bun &> /dev/null; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun already installed"
fi

# ----------------------------
# All packages via Brewfile
# ----------------------------

BREWFILE="$HOME/.local/share/chezmoi/Brewfile"
echo "Installing packages from Brewfile..."
brew bundle install --file="$BREWFILE"

# ----------------------------
# GitHub CLI Auth
# ----------------------------

if ! gh auth status &> /dev/null; then
    echo "Logging into GitHub CLI..."
    gh auth login
else
    echo "GitHub CLI already authenticated"
fi

# ----------------------------
# tmux Plugin Manager
# ----------------------------

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed"
fi

# ----------------------------
# npm Global Tools
# ----------------------------

echo "Installing npm global tools..."
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex

# ----------------------------
# Done
# ----------------------------

echo ""
echo "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Run: tmux, then Ctrl+b I (to install tmux plugins)"
echo "  2. Run: nvim (plugins install automatically)"
echo "  3. Install manually: Granola (https://granola.so/download)"
echo ""
