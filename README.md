# Dotfiles

Personal development environment managed with [Chezmoi](https://www.chezmoi.io/).

## What's Included

| Tool | Config | Purpose |
|------|--------|---------|
| **tmux** | `~/.config/tmux/tmux.conf` | Terminal multiplexer with session persistence |
| **Git** | `~/.gitconfig` | Git configuration |
| **Zsh** | `~/.zshrc` | Shell configuration |
| **Claude Code** | `~/.claude/` | AI assistant settings |
| **Neovim** | `~/.config/nvim/` | Editor (coming soon) |

## Quick Start

### New Machine Setup

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ThoBustos
```

Or step by step:

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply
chezmoi init --apply https://github.com/ThoBustos/dotfiles
```

### After Setup

Install tmux plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then in tmux, press `Ctrl+b I` to install plugins.

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

### Session Persistence

Sessions auto-save every 15 minutes and auto-restore on tmux start.

- `Ctrl+b Ctrl+s` - Manual save
- `Ctrl+b Ctrl+r` - Manual restore

## Stack

- **Terminal**: tmux + Catppuccin Mocha
- **Editor**: Neovim (Kickstart-based) + Catppuccin
- **Shell**: Zsh
- **Dotfiles**: Chezmoi

## Updating

```bash
# Pull latest and apply
chezmoi update

# Or edit locally
chezmoi edit ~/.config/tmux/tmux.conf
chezmoi apply
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl     # Personal data template
├── .chezmoiignore         # Files to not apply
├── dot_config/
│   ├── tmux/tmux.conf     # → ~/.config/tmux/tmux.conf
│   └── nvim/              # → ~/.config/nvim/ (coming soon)
├── dot_claude/            # → ~/.claude/
├── dot_gitconfig          # → ~/.gitconfig
├── dot_zshrc              # → ~/.zshrc
└── README.md
```

## Credits

- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager
- [Catppuccin](https://github.com/catppuccin) - Theme
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux plugin manager
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) - Session persistence
