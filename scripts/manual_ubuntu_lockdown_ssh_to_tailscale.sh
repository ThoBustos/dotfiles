#!/bin/bash
# Manually lock SSH to Tailscale after Tailscale SSH access has been tested.
set -euo pipefail

if [[ "$(uname)" != "Linux" ]]; then
    echo "This script only runs on Linux." >&2
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    exec sudo bash "$0" "$@"
fi

command -v ufw >/dev/null || { echo "ufw not found" >&2; exit 1; }
command -v tailscale >/dev/null || { echo "tailscale not found" >&2; exit 1; }

if ! ip link show tailscale0 >/dev/null 2>&1; then
    echo "tailscale0 not found. Run tailscale up and verify access first." >&2
    exit 1
fi

echo "This will remove public SSH access and allow SSH only on tailscale0."
echo "Before continuing, verify from another terminal:"
echo "  ssh deploy@<tailscale-name-or-ip>"
read -r -p "Type LOCKDOWN to continue: " confirmation

if [[ "$confirmation" != "LOCKDOWN" ]]; then
    echo "Aborted."
    exit 1
fi

ufw delete limit 22/tcp || true
ufw delete allow 22/tcp || true
ufw allow in on tailscale0 to any port 22 proto tcp comment 'SSH via Tailscale only'
ufw reload

echo "SSH is now allowed only via tailscale0."
ufw status verbose
