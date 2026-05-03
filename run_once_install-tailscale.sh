#!/bin/bash
# Install Tailscale (runs once on new machine)

set -e

if command -v tailscale &> /dev/null; then
    echo "Tailscale already installed"
    exit 0
fi

echo "Installing Tailscale..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install tailscale
    echo "Tailscale installed. Run 'tailscale up' to connect."
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    curl -fsSL https://tailscale.com/install.sh | sh
    echo "Tailscale installed. Run 'sudo tailscale up' to connect."
else
    echo "Unknown OS. Install Tailscale manually: https://tailscale.com/download"
    exit 1
fi
