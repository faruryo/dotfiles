# Dotfiles Project Overview

This project manages the dotfiles and environment setup for Murata Ryo. It uses a combination of symlinks and template expansion to configure the system.

## Tech Stack
- **Shell**: Bash (for installation), Zsh (for daily use)
- **Runtime Manager**: `mise`
- **Package Manager**: Homebrew (`Brewfile`)
- **Tools**: `envsubst` (for templates), `git`, `gh`

## Structure
- `git/`: Git configuration files.
  - `gitconfig.tmpl`: Template for `~/.gitconfig`.
  - `link_dirs` in `install.sh` symlinks this whole directory to `~/.config/git`.
- `zsh/`: Zsh configuration files. Symlinked to `~/.config/zsh`.
- `mise/`: Mise configuration. Symlinked to `~/.config/mise`.
- `install.sh`: The main entry point for setting up the environment.

## Conventions
- Files ending in `.tmpl` are processed using `envsubst` during installation.
- Common variables used in templates: `GIT_NAME`, `GIT_EMAIL`, `GIT_SIGNINGKEY`.

## Setup Procedure
1. Clone the repository.
2. Run `./install.sh`. This will:
   - Install Homebrew packages.
   - Install Node.js via Volta (if missing).
   - Create symlinks in `$HOME` and `$HOME/.config`.
   - Expand templates.
