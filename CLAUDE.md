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
| `home/dot_config/zsh/dot_zpreztorc` | `~/.config/zsh/.zpreztorc` |
| `home/dot_config/zsh/dot_zprofile` | `~/.config/zsh/.zprofile` |
| `home/dot_config/zsh/dot_p10k.zsh` | `~/.config/zsh/.p10k.zsh` |
| `home/dot_config/zsh/dot_zprezto-contrib/` | `~/.config/zsh/.zprezto-contrib/` |
| `home/dot_config/git/private_config.tmpl` | `~/.config/git/config` (0600, rendered) |
| `home/dot_config/git/ignore` | `~/.config/git/ignore` |
| `home/dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `home/dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `home/.chezmoiexternal.toml` | clones Prezto to `~/.config/zsh/.zprezto` |
| `home/.chezmoiscripts/run_onchange_brew-bundle.sh` | runs on Brewfile changes |
| `home/.chezmoiscripts/run_once_install-volta.sh` | runs once to install Volta |

## Key files and their roles

- **`home/dot_zshenv`** — sets XDG dirs, ZDOTDIR, and PATH for Volta, Cargo, Go, Python tools, and Krew
- **`home/dot_config/zsh/dot_zshrc`** — loads Prezto and Powerlevel10k
- **`home/dot_config/zsh/dot_zpreztorc`** — Prezto module list (ends with custom `faru` module)
- **`home/dot_config/zsh/dot_zprezto-contrib/faru/init.zsh`** — activates Homebrew, mise, kubectl completions, direnv, gcloud, GPG_TTY
- **`home/dot_config/zsh/dot_zprezto-contrib/faru/code-projects.zsh`** — defines `code-projects` shell function (opens multiple VS Code projects from `~/.config/zsh/.vscode-projects.local`)
- **`home/dot_config/git/private_config.tmpl`** — Go template for `~/.config/git/config`; uses `{{ .gitName }}`, `{{ .gitEmail }}`, `{{ .signingKey }}`, `{{ lookPath "gpg" }}`, `{{ lookPath "gh" }}`
- **`home/dot_config/mise/config.toml`** — global tool versions: Go 1.24.5, Rust 1.85.0, golangci-lint 2.3.0, kubectl/kustomize/stern
- **`.chezmoi.toml.tmpl`** — prompts for Git name/email/signingKey on first `chezmoi init`

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
