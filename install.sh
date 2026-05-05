#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/dotfiles"
REPO="https://github.com/faruryo/dotfiles"

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

if ! command -v chezmoi >/dev/null 2>&1; then
    brew install chezmoi
fi

if [ ! -d "$SOURCE_DIR" ]; then
    git clone "$REPO" "$SOURCE_DIR"
fi

chezmoi init --source="$SOURCE_DIR/home" --apply
