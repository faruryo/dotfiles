#!/usr/bin/env bash
# Brewfile hash: {{ include (joinPath .chezmoi.sourceDir "../Brewfile") | sha256sum }}
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
    chmod -R go-w "$(brew --prefix)/share"
fi

brew bundle --file "{{ .chezmoi.sourceDir }}/../Brewfile"
