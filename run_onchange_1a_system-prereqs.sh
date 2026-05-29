#!/bin/bash
# System prerequisites: Xcode CLT, Rosetta 2, Homebrew, SSH key (macOS only)
[[ "$(uname)" != "Darwin" ]] && exit 0
set -euo pipefail

# Xcode CLT
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Waiting for Xcode CLT (follow the GUI prompt)..."
    until xcode-select -p &>/dev/null; do sleep 5; done
fi

# Rosetta 2 (Apple Silicon only)
if [[ "$(uname -m)" == "arm64" ]] && ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto &>/dev/null; then
    echo "Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
fi

# Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off

# SSH key
if [ ! -f "$HOME/.ssh/id_ed25519_github" ]; then
    echo "No GitHub SSH key found. Generating one..."
    read -rp "Enter your email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519_github"
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519_github"
    echo "Your public key (add to https://github.com/settings/keys):"
    cat "$HOME/.ssh/id_ed25519_github.pub"
    read -rp "Press Enter once you've added the key to GitHub..."
else
    echo "GitHub SSH key already exists"
fi
