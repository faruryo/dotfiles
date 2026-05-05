# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

macOS dotfiles managed via [chezmoi](https://www.chezmoi.io/). Requires macOS and Homebrew.

## Installation

On a new machine:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/faruryo/dotfiles/main/install.sh)
```

`install.sh` does: install Homebrew if missing → install chezmoi → clone repo → `chezmoi init --source=~/dotfiles/home --apply`.

On first run, chezmoi prompts for:
- Git commit author name
- Git commit email
- GPG signing key ID

These are stored in `~/.config/chezmoi/chezmoi.toml` and never re-prompted.

On an existing machine (repo already cloned):

```sh
brew install chezmoi
chezmoi init --source="$HOME/dotfiles/home" --apply
```

## chezmoi source layout (`home/`)

| Source path | Target |
|---|---|
| `home/dot_zshenv` | `~/.zshenv` |
| `home/dot_config/zsh/dot_zshrc` | `~/.config/zsh/.zshrc` |
| `home/dot_config/zsh/dot_zprofile` | `~/.config/zsh/.zprofile` |
| `home/dot_config/zsh/dot_code-projects.zsh` | `~/.config/zsh/.code-projects.zsh` |
| `home/dot_config/git/private_config.tmpl` | `~/.config/git/config` (0600, rendered) |
| `home/dot_config/git/ignore` | `~/.config/git/ignore` |
| `home/dot_config/ghostty/config` | `~/.config/ghostty/config` |
| `home/dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `home/dot_config/starship.toml` | `~/.config/starship.toml` |
| `home/dot_config/yazi/yazi.toml` | `~/.config/yazi/yazi.toml` |
| `home/dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| `home/dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `home/dot_claude/private_settings.json` | `~/.claude/settings.json` (0600) |
| `home/.chezmoiexternal.toml` | clones fzf-tab to `~/.config/zsh/.fzf-tab` |
| `home/.chezmoiscripts/run_onchange_brew-bundle.sh` | runs on Brewfile changes |
| `home/.chezmoiscripts/run_once_install-volta.sh` | runs once to install Volta |

## Key files and their roles

- **`home/dot_zshenv`** — sets XDG dirs, ZDOTDIR, and PATH for Volta, Cargo, Go, Python tools, and Krew
- **`home/dot_config/zsh/dot_zshrc`** — loads Homebrew, plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab), Starship, Atuin, Zoxide, mise, direnv, kubectl completions, gcloud, GPG_TTY
- **`home/dot_config/zsh/dot_code-projects.zsh`** — defines `code-projects` shell function (opens multiple VS Code projects from `~/.config/zsh/.vscode-projects.local`)
- **`home/dot_config/ghostty/config`** — Ghostty terminal emulator config (Metal GPU, catppuccin-mocha theme)
- **`home/dot_config/zellij/config.kdl`** — Zellij terminal multiplexer config (replaces tmux)
- **`home/dot_config/starship.toml`** — Starship prompt config (replaces Powerlevel10k); shows git, k8s, gcloud, cmd duration
- **`home/dot_config/yazi/yazi.toml`** — Yazi async TUI file manager config
- **`home/dot_config/lazygit/config.yml`** — Lazygit TUI git client config
- **`home/dot_claude/private_settings.json`** — Claude Code global settings (hooks, plugins, permissions); 0600 permissions
- **`home/dot_config/git/private_config.tmpl`** — Go template for `~/.config/git/config`; uses `{{ .gitName }}`, `{{ .gitEmail }}`, `{{ .signingKey }}`, `{{ lookPath "gpg" }}`, `{{ lookPath "gh" }}`
- **`home/dot_config/mise/config.toml`** — global tool versions: Go 1.24.5, Rust 1.85.0, golangci-lint 2.3.0, kubectl/kustomize/stern
- **`.chezmoi.toml.tmpl`** — prompts for Git name/email/signingKey on first `chezmoi init`

## Tool stack

| Layer | Tool | Notes |
|---|---|---|
| Terminal | Ghostty | Metal GPU, Zig製、catppuccin-mocha |
| Multiplexer | Zellij | WASM拡張、UIヒント表示 |
| Prompt | Starship | 超高速、git/k8s/gcloud対応 |
| History | Atuin | SQLite管理、Ctrl+R強化 |
| Directory jump | Zoxide | `cd` を置き換え、学習型 |
| File manager | Yazi | 非同期Rust製TUI |
| Git TUI | Lazygit | エージェント変更のレビューに |
| Completion | fzf-tab | zsh補完をfuzzy化 |

## Day-to-day chezmoi usage

```sh
chezmoi apply           # apply changes from source to home
chezmoi diff            # preview what would change
chezmoi edit ~/.zshenv  # edit a source file and apply
chezmoi update          # git pull source + apply
chezmoi status          # show pending changes
```

## VS Code multi-project launcher

`code-projects` reads `~/.config/zsh/.vscode-projects.local` (one directory per line, comments with `#`). Copy the example to get started:

```sh
cp ~/.config/zsh/.vscode-projects.example ~/.config/zsh/.vscode-projects.local
```

If a project directory contains `.envrc`, it launches via `direnv exec`; otherwise plain `code`.

## GPG signing troubleshooting

If `gpg: signing failed: No such file or directory` appears from GUI editors:

```sh
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```
