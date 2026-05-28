#!/bin/bash
# Install Docker Engine + docker compose plugin
# Runs once on first chezmoi apply on a Linux machine
[[ "$(uname)" != "Linux" ]] && exit 0
set -euo pipefail

echo "=== Docker Setup ==="

if command -v docker &>/dev/null; then
    echo "Docker already installed ($(docker --version))"
    exit 0
fi

# Must run as root
if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi

# Official Docker install script (adds apt repo + installs latest stable)
curl -fsSL https://get.docker.com | sh

# Add deploy user to docker group (no sudo needed for docker commands)
if id "deploy" &>/dev/null; then
    usermod -aG docker deploy
    echo "deploy user added to docker group"
fi

systemctl enable docker
systemctl start docker

echo "=== Docker installed ==="
docker --version
docker compose version
