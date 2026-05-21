typeset -gr FARU_SBX_KITS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sbx/kits"

sbx-claude() {
    emulate -L zsh

    local project_dir="${1:-.}"
    local kit_name="host-claude-sync"
    local kit_path="${FARU_SBX_KITS_DIR}/${kit_name}"
    local claude_dir="${HOME}/.claude"

    if ! command -v sbx >/dev/null 2>&1; then
        print -u2 -- "❌ エラー: sbx コマンドが見つかりません。"
        return 1
    fi

    if [[ ! -d "$project_dir" ]]; then
        print -u2 -- "❌ エラー: プロジェクトディレクトリが見つかりません: $project_dir"
        return 1
    fi

    if [[ ! -d "$kit_path" ]]; then
        print -u2 -- "❌ エラー: Mixin Kit が見つかりません: $kit_path"
        return 1
    fi

    if [[ ! -d "$claude_dir" ]]; then
        print -u2 -- "⚠️  警告: ~/.claude ディレクトリが見つかりません。マウントをスキップします。"
    fi

    print -- "🚀 Docker Sandbox を起動します: $project_dir"

    sbx run claude "$project_dir" "$claude_dir" --kit "$kit_path"
}
