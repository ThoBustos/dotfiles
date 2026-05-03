# Dotfiles

Personal development environment managed with [Chezmoi](https://www.chezmoi.io/).

## What's Included

| Tool | Config | Purpose |
|------|--------|---------|
| **Ghostty** | `~/.config/ghostty/config` | Terminal (Fun Forrest theme) |
| **tmux** | `~/.config/tmux/tmux.conf` | Multiplexer with Fun Forrest theme + session persistence |
| **Neovim** | `~/.config/nvim/` | Editor (Kickstart-based) |
| **Zed** | `~/.config/zed/settings.json` | Fast editor (Gruvbox dark, Claude Sonnet agent) |
| **Git** | `~/.gitconfig` | Config + aliases, global gitignore |
| **Zsh** | `~/.zshrc` | Shell config |
| **Claude Code** | `~/.claude/` | AI assistant settings + permissions |
| **SSH** | `~/.ssh/config` | GitHub host config |

## Stack

| Layer | Tool | Theme |
|-------|------|-------|
| Terminal | Ghostty | Fun Forrest |
| Multiplexer | tmux | Fun Forrest |
| Editor | Neovim (Kickstart) | - |
| Editor | Zed | Gruvbox Dark |
| Editor | Cursor | - |
| Font | MesloLGM Nerd Font | - |
| Dotfiles | Chezmoi | - |

## macOS Apps (Brewfile)

All apps installed via `brew bundle install`:

| Category | Apps |
|----------|------|
| Terminal | Ghostty |
| Browsers | Google Chrome |
| Editors | Cursor, Zed |
| Dev Tools | Docker Desktop, Postman, pgAdmin, Linear |
| Productivity | Raycast, Obsidian, Notion, Figma, Spotify, Screen Studio, Zotero, Tailscale |
| Communication | Slack, Zoom, Loom |
| AI | Claude desktop |

**App Store (via `mas`):** Brain.fm, CapCut, FocuSee

**Manual installs:** Granola, Fathom, Wispr Flow, Rippling, SentinelOne, MS Office

**npm globals:** `npm i -g @anthropic-ai/claude-code @openai/codex`

## Quick Start

### New Machine Setup (macOS)

```bash
# 1. Install chezmoi + apply dotfiles (runs bootstrap automatically)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThoBustos
```

That single command will:
- Clone this repo to `~/.local/share/chezmoi/`
- Apply all configs to your home directory
- Run `run_once_1_install-packages.sh` - Homebrew, SSH key, NVM, Bun, all packages via Brewfile, gh auth, TPM, npm globals
- Run `run_once_2_clone-repos.sh` - clone personal repos (my-vault, openyoko, ideabench, learnrep)
- Run `run_once_3_macos-defaults.sh` - dock, keyboard, finder, screenshot defaults

### After Bootstrap

```bash
# Install tmux plugins (inside tmux)
tmux
# Press: Ctrl+b I

# Neovim plugins install automatically on first launch
nvim

# Install manually: Granola, Fathom, Wispr Flow
```

### Private SSH Hosts

The bootstrap deploys `~/.ssh/config` with only the GitHub host. For VPS/internal hosts, create `~/.ssh/private_config` manually - it is included automatically via the SSH config but never tracked in this repo.

## Key Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Terminal | Ghostty | Fast, GPU-accelerated, Fun Forrest theme |
| Dotfiles manager | Chezmoi | Templates, multi-machine, encryption |
| Config location | XDG (`~/.config/`) | Modern standard |
| tmux prefix | `Ctrl+b` (default) | Works on any system |
| Theme | Fun Forrest | Warm dark, consistent across terminal + tmux |
| Neovim approach | Kickstart | Understand every line |
| Font | MesloLGM Nerd Font | Icons for Neovim/tmux status |

## Key Bindings

### tmux

| Key | Action |
|-----|--------|
| `Ctrl+b c` | New window |
| `Ctrl+b 1-9` | Switch to window N |
| `Ctrl+b %` | Split vertical |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+b d` | Detach session |
| `Ctrl+b s` | List sessions |
| `Ctrl+b r` | Reload config |
| `Ctrl+b I` | Install plugins (TPM) |
| `Ctrl+b Ctrl+s` | Save session |
| `Ctrl+b Ctrl+r` | Restore session |

### Session Management

```bash
tmux new -s work       # New named session
tmux ls                # List sessions
tmux attach -t work    # Attach to session
Ctrl+b $               # Rename current session
```

Sessions auto-save every 15 minutes and restore automatically on tmux start.

### Post-Install Manual Steps

- **Raycast**: Open → Settings → General → set hotkey to `Option+Space`. Then disable Spotlight in System Settings → Keyboard Shortcuts → Spotlight.
- **Granola, Fathom, Wispr Flow**: install manually (see Brewfile comments)
- **SSH private hosts**: create `~/.ssh/private_config` manually for VPS/internal hosts

## Updating

```bash
chezmoi update        # Pull latest and apply
chezmoi edit ~/.config/tmux/tmux.conf && chezmoi apply
chezmoi add ~/.some-new-config
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl               # Personal data template (prompts for email)
├── .chezmoiignore                   # OS-aware ignore rules
├── .gitignore                       # Keeps private_config out of repo
├── Brewfile                         # All macOS apps
├── run_once_1_install-packages.sh   # Bootstrap: Homebrew, SSH, packages, auth
├── run_once_2_clone-repos.sh        # Clone personal repos
├── run_once_3_macos-defaults.sh     # macOS system defaults
├── dot_config/
│   ├── ghostty/config
│   ├── tmux/tmux.conf
│   ├── zed/settings.json
│   └── nvim/
├── dot_claude/
│   ├── CLAUDE.md
│   └── settings.json
├── dot_ssh/
│   └── config                       # GitHub host only (private_config excluded)
├── dot_local/bin/
│   └── executable_security-status   # Security status dashboard
├── dot_gitconfig.tmpl
├── dot_gitignore_global
└── dot_zshrc
```

## Secrets & Password Manager

No password manager is bootstrapped automatically — browser extensions can't be installed via CLI.

After Chrome is set up, install your preferred extension manually:
- [Dashlane](https://chromewebstore.google.com/detail/dashlane-password-manager/fdjamakpfbbddfjaooikfcpapjohcfmg)
- [1Password](https://chromewebstore.google.com/detail/1password-password-manage/aeblfdkhhhdcdjpifhhbdiojplfjncoa)
- [Bitwarden](https://chromewebstore.google.com/detail/bitwarden-password-manage/nngceckbapebfimnlniiiahkandclblb)

SSH private hosts live in `~/.ssh/private_config` (never tracked in this repo).

## Health Check

```bash
chezmoi doctor
chezmoi status --dry-run --verbose
bash -n run_once_1_install-packages.sh run_once_2_clone-repos.sh run_once_3_macos-defaults.sh
brew bundle check --file=Brewfile
```

## Credits

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim template
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux plugin manager
