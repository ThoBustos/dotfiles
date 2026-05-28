#!/bin/bash
# Linux security hardening: UFW, fail2ban, SSH hardening, unattended-upgrades
# Runs once on first chezmoi apply on a Linux machine
[[ "$(uname)" != "Linux" ]] && exit 0
set -euo pipefail

echo "=== Linux Security Hardening ==="

# Must run as root
if [[ $EUID -ne 0 ]]; then
    echo "Re-running with sudo..."
    exec sudo bash "$0" "$@"
fi

# Create non-root deploy user
if ! id "deploy" &>/dev/null; then
    echo "Creating deploy user..."
    useradd -m -s /bin/bash deploy
    usermod -aG sudo deploy
    mkdir -p /home/deploy/.ssh
    if [[ -f ~/.ssh/authorized_keys ]]; then
        cp ~/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys
        chown -R deploy:deploy /home/deploy/.ssh
        chmod 700 /home/deploy/.ssh
        chmod 600 /home/deploy/.ssh/authorized_keys
    fi
    # Passwordless sudo for deploy user
    echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
    chmod 440 /etc/sudoers.d/deploy
    echo "deploy user created"
else
    echo "deploy user already exists"
fi

# Install security packages
apt-get update -qq
apt-get install -y --no-install-recommends \
    ufw fail2ban unattended-upgrades apt-listchanges \
    curl wget git jq

# SSH hardening — patch sshd_config in-place
sshd_config="/etc/ssh/sshd_config"
cp "$sshd_config" "${sshd_config}.bak.$(date +%s)"

apply_sshd_setting() {
    local key="$1" val="$2"
    if grep -qE "^#?${key}" "$sshd_config"; then
        sed -i "s/^#\?${key}.*/${key} ${val}/" "$sshd_config"
    else
        echo "${key} ${val}" >> "$sshd_config"
    fi
}

apply_sshd_setting PermitRootLogin no
apply_sshd_setting PasswordAuthentication no
apply_sshd_setting ChallengeResponseAuthentication no
apply_sshd_setting X11Forwarding no
apply_sshd_setting MaxAuthTries 3
apply_sshd_setting LoginGraceTime 20
apply_sshd_setting AllowAgentForwarding no
apply_sshd_setting AllowTcpForwarding no

systemctl restart sshd
echo "SSH hardened"

# UFW firewall
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw limit 22/tcp comment 'SSH rate-limited'    # 6 connections per 30s
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw --force enable
echo "UFW configured"

# fail2ban — SSH jail
# banaction = ufw ensures bans go through UFW, not raw iptables (avoids backend clash)
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime   = 3600
findtime  = 600
maxretry  = 3
backend   = systemd
banaction = ufw

[sshd]
enabled  = true
port     = 22

[recidive]
enabled  = true
bantime  = 604800
findtime = 86400
maxretry = 5
EOF
systemctl enable fail2ban
systemctl restart fail2ban
echo "fail2ban configured (UFW backend, recidive jail enabled)"

# Unattended security upgrades
cat > /etc/apt/apt.conf.d/20auto-upgrades << 'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF
systemctl enable unattended-upgrades
echo "Unattended upgrades enabled"

echo "=== Hardening complete ==="
echo "IMPORTANT: Test SSH access with deploy user before logging out of root."
