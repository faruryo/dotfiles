# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# zsh home directory
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Development tools PATH
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
. "$HOME/.cargo/env"

# Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="$PATH:$GOBIN"

# Python tools & Browser Use
export PATH="$HOME/.browser-use-env/bin:$HOME/.local/bin:$HOME/.poetry/bin:$PATH"

# Kubernetes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
