# Dotfiles

Personal development environment managed with [Chezmoi](https://www.chezmoi.io/).

## What's Included

| Tool | Config | Purpose |
|------|--------|---------|
| **Alacritty** | `~/.config/alacritty/alacritty.toml` | Terminal emulator |
| **tmux** | `~/.config/tmux/tmux.conf` | Terminal multiplexer with session persistence |
| **Neovim** | `~/.config/nvim/` | Editor (Kickstart-based) |
| **Git** | `~/.gitconfig` | Git configuration |
| **Zsh** | `~/.zshrc` | Shell configuration |
| **Claude Code** | `~/.claude/` | AI assistant settings |

## Stack

| Layer | Tool | Theme |
|-------|------|-------|
| Terminal | Alacritty | Catppuccin Mocha |
| Multiplexer | tmux | Catppuccin Mocha |
| Editor | Neovim (Kickstart) | Catppuccin Mocha |
| Font | MesloLGM Nerd Font | - |
| Dotfiles | Chezmoi | - |

## Quick Start

### New Machine Setup

```bash
# One command: install chezmoi + apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThoBustos

# Then run the bootstrap script (installs tools)
~/.local/share/chezmoi/run_once_install-packages.sh
```

Or step by step:

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply
chezmoi init --apply https://github.com/ThoBustos/dotfiles
```

### Manual Post-Setup

```bash
# Install tmux plugins (inside tmux)
# Press: Ctrl+b I

# Neovim plugins install automatically on first launch
nvim
```

## Key Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Terminal | Alacritty | Fast, minimal, GPU-accelerated |
| Dotfiles manager | Chezmoi | Templates, multi-machine, encryption |
| Config location | XDG (`~/.config/`) | Modern standard |
| tmux prefix | `Ctrl+b` (default) | Works on any system |
| Theme | Catppuccin Mocha | Warm dark, consistent across tools |
| Neovim approach | Kickstart | Understand every line, not a distribution |
| Font | MesloLGM Nerd Font | Icons for Neovim/tmux status |

## Key Bindings

### tmux

| Key | Action |
|-----|--------|
| `Ctrl+b c` | New window |
| `Ctrl+b 1-9` | Switch to window N |
| `Ctrl+b n/p` | Next/previous window |
| `Ctrl+b %` | Split vertical |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+b d` | Detach session |
| `Ctrl+b s` | List sessions |
| `Ctrl+b r` | Reload config |
| `Ctrl+b I` | Install plugins (TPM) |

### Session Management

```bash
tmux new -s work      # New named session
tmux ls               # List sessions
tmux attach -t work   # Attach to session
Ctrl+b $              # Rename current session
```

### Session Persistence

Sessions auto-save every 15 minutes and auto-restore on tmux start.

- `Ctrl+b Ctrl+s` - Manual save
- `Ctrl+b Ctrl+r` - Manual restore

## Updating

```bash
# Pull latest and apply
chezmoi update

# Edit a config
chezmoi edit ~/.config/tmux/tmux.conf
chezmoi apply

# Add a new file
chezmoi add ~/.some-config
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl          # Personal data template
├── .chezmoiignore              # Files to not apply
├── run_once_install-packages.sh # Bootstrap script
├── dot_config/
│   ├── alacritty/alacritty.toml
│   ├── tmux/tmux.conf
│   └── nvim/                   # Neovim config
├── dot_claude/
│   ├── CLAUDE.md
│   └── settings.json
├── dot_gitconfig
├── dot_zshrc
└── README.md
```

## Credits

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Catppuccin](https://github.com/catppuccin) - Theme
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim template
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux plugin manager
- [Mischa van den Burg](https://www.youtube.com/@MischavandenBurg) - Inspiration
- [Dreams of Code](https://www.youtube.com/@dreamsofcode) - tmux setup guide
- [TJ DeVries](https://www.youtube.com/@teikidev) - Kickstart.nvim
