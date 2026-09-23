typeset -gr FARU_SBX_KITS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sbx/kits"

sbxc() {
  if [ $# -eq 0 ]; then
    "$HOME/projects/secret-memo/scripts/start-named-session/new.sh"
  else
    sbx env exec -it -w "$PWD" "$HOME/projects/secret-memo/.sbx" -- claude "$@"
  fi
}
alias sbxd='sbx env exec -u agent -it -w "$PWD" "$HOME/projects/secret-memo/.sbx" -- codex'
