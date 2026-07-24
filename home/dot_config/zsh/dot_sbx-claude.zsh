typeset -gr FARU_SBX_KITS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sbx/kits"

alias sbxc='sbx exec -it -w "$PWD" claude-projects claude'
alias sbxd='sbx exec -it -w "$PWD" claude-projects codex'
