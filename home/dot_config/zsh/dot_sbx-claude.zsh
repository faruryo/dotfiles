typeset -gr FARU_SBX_KITS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sbx/kits"

alias sbxc='sbx env exec -it -w "$PWD" "$HOME/projects/secret-memo/.sbx" -- claude'
alias sbxd='sbx env exec -u agent -it -w "$PWD" "$HOME/projects/secret-memo/.sbx" -- codex'
