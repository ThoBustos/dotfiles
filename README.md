# Dotfiles

Personal development environment managed with [Chezmoi](https://www.chezmoi.io/).

## What's Included

| Tool | Config | Purpose |
|------|--------|---------|
| **Ghostty** | `~/.config/ghostty/config` | Terminal, Fun Forrest theme |
| **tmux** | `~/.config/tmux/tmux.conf` | Multiplexer with session persistence |
| **Neovim** | `~/.config/nvim/` | Editor, Kickstart-based |
| **Zed** | `~/.config/zed/settings.json` | Editor, Gruvbox dark |
| **Git** | `~/.gitconfig` | Config, aliases, global gitignore |
| **Zsh** | `~/.zshrc` | Shell config |
| **Claude Code** | `~/.claude/` | AI assistant settings |
| **SSH** | `~/.ssh/config` | GitHub host config |

## Quick Start

### macOS Workstation

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThoBustos
```

What macOS setup does:

- Installs Homebrew prerequisites.
- Installs apps and CLI packages from `Brewfile`.
- Installs npm globals like `@anthropic-ai/claude-code` and `@openai/codex`.
- Applies terminal, tmux, Neovim, Zed, Git, Zsh, Claude Code, and SSH config.
- Runs macOS defaults for Dock, keyboard, Finder, and screenshots.
- Clones personal repos.

macOS app groups:

| Category | Apps |
|----------|------|
| Terminal | Ghostty |
| Browsers | Google Chrome |
| Editors | Cursor, Zed |
| Dev Tools | Docker Desktop, Postman, pgAdmin, Linear |
| Productivity | Raycast, Obsidian, Notion, Figma, Spotify, Screen Studio, Zotero, Tailscale |
| Communication | Slack, Zoom, Loom |
| AI | Claude desktop, Granola |

After macOS bootstrap:

```bash
tmux
# Press Ctrl+b I to install tmux plugins

nvim
# Plugins install on first launch
```

Manual macOS steps:

- Raycast: open Settings, General, set hotkey to `Option+Space`.
- Spotlight: disable Spotlight keyboard shortcut if it conflicts with Raycast.
- Password manager: install your preferred browser extension manually.

macOS health check:

```bash
chezmoi doctor
chezmoi status --dry-run --verbose
bash -n run_once_2_clone-repos.sh run_once_3_macos-defaults.sh
brew bundle check --file=Brewfile
```

### Ubuntu Server / Hetzner

SSH in as `root`, then run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThoBustos
```

Before running setup:

- Root must have a valid `~/.ssh/authorized_keys`.
- The setup refuses to disable root/password SSH if no SSH key is present.
- The default server user is `deploy`.
- To use another user, run with `CHEZMOI_SERVER_USER=name`.

After bootstrap, open a second terminal and test the new user before closing root:

```bash
ssh deploy@your-server-public-ip
```

Connect Tailscale:

```bash
sudo tailscale up --ssh
```

After Tailscale works, connect by Tailscale name or IP:

```bash
ssh deploy@your-server-tailnet-name
ssh deploy@100.x.y.z
```

Optional SSH lockdown after Tailscale works:

```bash
sudo bash /root/.local/share/chezmoi/scripts/manual_ubuntu_lockdown_ssh_to_tailscale.sh
```

After this, public-IP SSH should stop working. Tailscale SSH should still work. Only do this after testing Tailscale access from another terminal.

Cloud provider firewall:

- In Hetzner, enable a firewall at the server level.
- Allow UDP `41641` from anywhere for Tailscale.
- Allow TCP `80` and `443` only if the server will host public websites.
- Do not allow public TCP `22` after Tailscale SSH works.
- Keep UFW enabled on the server too.

What Ubuntu setup does:

- Runs only on Ubuntu Linux.
- Creates a `deploy` user and copies root's SSH authorized keys.
- Gives `deploy` passwordless sudo for automation.
- Hardens SSH by disabling root login, password login, agent forwarding, and TCP forwarding.
- Installs UFW, fail2ban, unattended security updates, curl, wget, git, and jq.
- Configures UFW to deny incoming traffic by default, allow outgoing traffic, rate-limit SSH, and allow HTTP/HTTPS.
- Configures fail2ban for SSH with UFW-based bans and longer repeat-offender bans.
- Installs Tailscale so the server can join your private mesh VPN.
- Installs Docker Engine and Docker Compose plugin.
- Adds `deploy` to the Docker group.
- Enables Docker log rotation.
- Installs Hermes Agent as `deploy`.
- Leaves Tailscale auth and Hermes setup as manual steps because they require credentials or OAuth.

Docker notes:

- The Docker group is root-equivalent.
- Published Docker ports need care with UFW.
- Prefer localhost binds, Tailscale binds, or reverse proxy rules for exposed services.

Finish Hermes setup:

```bash
sudo -u deploy -H /home/deploy/.local/bin/hermes setup
sudo -u deploy -H /home/deploy/.local/bin/hermes doctor
sudo -u deploy -H /home/deploy/.local/bin/hermes gateway setup
sudo -u deploy -H /home/deploy/.local/bin/hermes gateway install
sudo -u deploy -H /home/deploy/.local/bin/hermes gateway start
```

Hermes usage:

- From a computer: SSH into the server and run `hermes`.
- From a phone: use `hermes gateway setup`, connect a supported app like Telegram, Discord, or Slack, then message that app.
- Hermes private config lives in `/home/deploy/.hermes`.
- Do not track `/home/deploy/.hermes` in chezmoi.

Hermes phone access with Telegram:

- Telegram is optional, but it is the easiest phone interface.
- Open Telegram and search for `@BotFather`.
- Send `/newbot`.
- Choose a bot name and a username ending in `bot`.
- Copy the bot token from BotFather.
- Paste that token during `hermes gateway setup`.
- Allow only Alexi's Telegram user ID.
- Keep the bot token secret.
- Delete or hide messages that contain setup tokens.

Gateway UI tunnel:

- Keep the Hermes gateway bound to loopback, not the public internet.
- From Alexi's computer, run:

```bash
ssh -N -L 127.0.0.1:18789:127.0.0.1:18789 deploy@100.x.y.z
```

- Replace `100.x.y.z` with the server's Tailscale IP.
- Open `http://127.0.0.1:18789` in the browser.
- Keep the gateway token secret.

LLM spend safety:

- Prefer subscription or OAuth auth when supported.
- If API keys are used, set provider spend limits.
- Enable usage alerts.
- Check usage during the first few days.

Ubuntu health check:

```bash
ssh deploy@your-server
sudo ufw status verbose
sudo fail2ban-client status sshd
tailscale status
docker run hello-world
sudo -u deploy -H /home/deploy/.local/bin/hermes doctor
systemctl status tailscaled docker fail2ban
```

### Other Linux

- Not supported yet.
- Ubuntu server scripts are gated to Ubuntu only.
- macOS scripts skip on Linux.
- Shared dotfiles may still apply, but package/bootstrap scripts are not designed for other distros.

## Public Repo Safety

Safe to commit:

- Install scripts.
- Public config.
- Placeholder examples like `<your-auth-key>`.
- UFW, fail2ban, Docker, Tailscale, and Hermes install commands.

Never commit:

- Tailscale auth keys.
- Hermes API keys.
- OAuth tokens.
- `.env` files.
- SSH private keys.
- Webhook URLs.
- Telegram, Discord, or Slack bot tokens.
- Private server details you do not want public.

Private local files:

- SSH private hosts live in `~/.ssh/private_config`.
- Hermes private state lives in `/home/deploy/.hermes`.
- Password manager setup is manual.

## Updating

```bash
chezmoi update
chezmoi edit ~/.config/tmux/tmux.conf && chezmoi apply
chezmoi add ~/.some-new-config
```

## Key Bindings

### tmux

| Key | Action |
|-----|--------|
| `Ctrl+b c` | New window |
| `Ctrl+b 1-9` | Switch to window N |
| `Ctrl+b %` | Split vertical |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b h/j/k/l` | Navigate panes |
| `Ctrl+b d` | Detach session |
| `Ctrl+b s` | List sessions |
| `Ctrl+b r` | Reload config |
| `Ctrl+b I` | Install plugins |
| `Ctrl+b Ctrl+s` | Save session |
| `Ctrl+b Ctrl+r` | Restore session |

### Session Management

```bash
tmux new -s work
tmux ls
tmux attach -t work
```

## Key Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Terminal | Ghostty | Fast, GPU-accelerated, Fun Forrest theme |
| Dotfiles manager | Chezmoi | Templates, multi-machine, encryption |
| Config location | XDG, `~/.config/` | Modern standard |
| tmux prefix | `Ctrl+b` | Works on any system |
| Theme | Fun Forrest | Warm dark, consistent terminal and tmux theme |
| Neovim approach | Kickstart | Understand every line |
| Font | MesloLGM Nerd Font | Icons for Neovim and tmux status |

## Structure

```text
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                  # Personal data template
├── .chezmoiignore                      # OS-aware ignore rules
├── .gitignore                          # Keeps private_config out of repo
├── Brewfile                            # macOS apps and packages
├── run_onchange_1a_system-prereqs.sh   # macOS prerequisites
├── run_onchange_1b_packages.sh.tmpl    # macOS Homebrew packages
├── run_onchange_1d_dev-tools.sh        # macOS dev tools
├── run_once_2_clone-repos.sh           # macOS personal repo clone
├── run_once_3_macos-defaults.sh        # macOS defaults
├── run_once_linux_10_harden.sh.tmpl    # Ubuntu SSH, UFW, fail2ban, updates
├── run_once_linux_20_tailscale.sh.tmpl # Ubuntu Tailscale install
├── run_once_linux_30_docker.sh.tmpl    # Ubuntu Docker install
├── run_once_linux_40_hermes.sh.tmpl    # Ubuntu Hermes install
├── scripts/
│   └── manual_ubuntu_lockdown_ssh_to_tailscale.sh
├── dot_config/
│   ├── ghostty/config
│   ├── tmux/tmux.conf
│   ├── zed/settings.json
│   └── nvim/
├── dot_claude/
│   ├── CLAUDE.md
│   └── settings.json
├── dot_ssh/
│   └── config                          # GitHub host only
├── dot_local/bin/
│   └── executable_security-status      # Security status dashboard
├── dot_gitconfig.tmpl
├── dot_gitignore_global
└── dot_zshrc
```

## Credits

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim template
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux plugin manager
