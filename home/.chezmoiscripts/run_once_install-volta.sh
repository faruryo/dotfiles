#!/usr/bin/env bash
# Install Volta (Node.js manager) — runs once per machine
set -euo pipefail

if command -v volta >/dev/null 2>&1; then
    exit 0
fi

curl https://get.volta.sh | bash
volta install node@latest
volta install @playwright/cli@latest
