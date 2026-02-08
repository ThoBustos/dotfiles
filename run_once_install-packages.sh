#!/bin/bash
# Bootstrap script - runs once on new machine setup
# Managed by Chezmoi

set -e  # Exit on error

echo "🚀 Starting bootstrap..."

# ----------------------------
# Homebrew
# ----------------------------

if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrew already installed"
fi

# ----------------------------
# CLI Tools
# ----------------------------

echo "📦 Installing CLI tools..."

brew install tmux
brew install neovim
brew install ripgrep      # For Telescope (neovim fuzzy finder)
brew install fd           # For Telescope
brew install git
brew install node         # For some Neovim LSPs

# ----------------------------
# Applications
# ----------------------------

echo "📦 Installing applications..."

brew install --cask alacritty
brew install --cask font-meslo-lg-nerd-font

# ----------------------------
# tmux Plugin Manager
# ----------------------------

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "📦 Installing TPM (tmux plugin manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "✓ TPM already installed"
fi

# ----------------------------
# Done
# ----------------------------

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open Alacritty (may need to allow in Security settings)"
echo "  2. Run: tmux"
echo "  3. Press: Ctrl+b I (to install tmux plugins)"
echo "  4. Run: nvim (plugins install automatically)"
echo ""
