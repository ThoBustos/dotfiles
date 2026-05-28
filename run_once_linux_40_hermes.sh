#!/bin/bash
# Install Hermes agent + systemd service for always-on operation
# Runs once on first chezmoi apply on a Linux machine
[[ "$(uname)" != "Linux" ]] && exit 0
set -euo pipefail

echo "=== Hermes Agent Setup ==="

if command -v hermes &>/dev/null; then
    echo "Hermes already installed ($(hermes --version 2>/dev/null || echo 'unknown version'))"
    exit 0
fi

# Install Hermes via official script
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# Reload PATH to pick up hermes binary
export PATH="$HOME/.local/bin:$PATH"

# Create systemd service for always-on daemon mode
# Run as deploy user if it exists, otherwise current user
SERVICE_USER="${SUDO_USER:-deploy}"
if ! id "$SERVICE_USER" &>/dev/null; then
    SERVICE_USER="$(whoami)"
fi

SERVICE_HOME=$(eval echo "~$SERVICE_USER")

if [[ $EUID -eq 0 ]]; then
    cat > /etc/systemd/system/hermes.service << EOF
[Unit]
Description=Hermes AI Agent
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=simple
User=${SERVICE_USER}
WorkingDirectory=${SERVICE_HOME}
ExecStart=${SERVICE_HOME}/.local/bin/hermes start --daemon
Restart=on-failure
RestartSec=10
Environment=HOME=${SERVICE_HOME}
Environment=PATH=${SERVICE_HOME}/.local/bin:/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable hermes
    echo "systemd service created (hermes.service)"
    echo "Start with: sudo systemctl start hermes"
fi

echo ""
echo "=== Hermes installed ==="
echo "Next steps:"
echo "  1. hermes setup --portal          # OAuth: wire up Claude + integrations"
echo "  2. hermes model                   # Pick Claude Sonnet/Haiku"
echo "  3. hermes config set terminal.backend docker  # Sandboxed execution"
echo "  4. sudo systemctl start hermes    # Run as background daemon"
echo ""
echo "Config lives at: ~/.hermes/"
echo "  config.yaml  — settings"
echo "  .env         — API keys (ANTHROPIC_API_KEY, etc.)"
echo "  SOUL.md      — agent identity"
