#!/bin/bash
# Bootstrap script - runs once on new machine setup
# Managed by Chezmoi

set -e  # Exit on error

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
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519_github" -N ""
    ssh-add "$HOME/.ssh/id_ed25519_github"
    echo ""
    echo "Your public key (add to https://github.com/settings/keys):"
    cat "$HOME/.ssh/id_ed25519_github.pub"
    echo ""
    read -p "Press Enter once you've added the key to GitHub..."
else
    echo "GitHub SSH key already exists"
fi

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
# CLI Tools (via Homebrew)
# ----------------------------

echo "Installing CLI tools..."
brew install tmux
brew install neovim
brew install ripgrep
brew install fd
brew install git
brew install node
brew install gh
brew install fzf
brew install jq
brew install graphite
brew install python
brew install poetry
brew install pnpm
brew install uv

# ----------------------------
# Ghostty
# ----------------------------

echo "Installing Ghostty..."
brew install --cask ghostty
brew install --cask font-meslo-lg-nerd-font

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
echo "  1. Run: brew bundle install (to install all apps from Brewfile)"
echo "  2. Run: tmux, then Ctrl+b I (to install tmux plugins)"
echo "  3. Run: nvim (plugins install automatically)"
echo "  4. Install manually: Granola, Brain.fm, CapCut, Fathom, Wispr Flow"
echo ""
