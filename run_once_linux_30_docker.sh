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

# SECURITY: Prevent Docker from bypassing UFW
# Docker modifies iptables directly and exposes container ports before UFW chains,
# meaning UFW rules would be silently ignored for any bound container ports.
# Setting "iptables: false" disables this — Docker networking still works via
# the host network, but port exposure is controlled by UFW as expected.
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "iptables": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
echo "Docker daemon configured (UFW-safe, log rotation enabled)"

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
