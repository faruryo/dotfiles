typeset -gr FARU_VSCODE_PROJECTS_FILE="${ZDOTDIR:-$HOME/.config/zsh}/.vscode-projects.local"
typeset -gr FARU_VSCODE_PROJECTS_EXAMPLE_FILE="${ZDOTDIR:-$HOME/.config/zsh}/.vscode-projects.example"

_faru_trim() {
    local value="$1"

    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"

    print -r -- "$value"
}

_faru_expand_project_path() {
    local value="$1"

    value="${value/#\~/$HOME}"
    value="${value//\$HOME/$HOME}"

    print -r -- "$value"
}

code-projects() {
    emulate -L zsh

    local config_file="${FARU_VSCODE_PROJECTS_FILE}"
    local example_file="${FARU_VSCODE_PROJECTS_EXAMPLE_FILE}"
    local raw_line
    local project_path
    local trimmed_line
    local launched_count=0

    if ! command -v code >/dev/null 2>&1; then
        print -u2 -- "❌ エラー: code コマンドが見つかりません。"
        return 1
    fi

    if [[ ! -f "$config_file" ]]; then
        print -u2 -- "❌ エラー: プロジェクト一覧ファイルが見つかりません: $config_file"
        if [[ -f "$example_file" ]]; then
            print -u2 -- "   例: cp $example_file $config_file"
        fi
        return 1
    fi

    print -- "🚀 VS Code プロジェクトを順次起動します..."

    while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
        trimmed_line="$(_faru_trim "$raw_line")"

        if [[ -z "$trimmed_line" || "$trimmed_line" == \#* ]]; then
            continue
        fi

        project_path="$(_faru_expand_project_path "$trimmed_line")"

        if [[ ! -d "$project_path" ]]; then
            print -u2 -- "⚠️  スキップ (ディレクトリ未検出): $project_path"
            continue
        fi

        print -- "✅ 起動中: $project_path"

        if [[ -f "$project_path/.envrc" ]]; then
            if command -v direnv >/dev/null 2>&1; then
                direnv exec "$project_path" code "$project_path" </dev/null
            else
                print -u2 -- "⚠️  direnv が見つからないため通常起動します: $project_path"
                code "$project_path" </dev/null
            fi
        else
            code "$project_path" </dev/null
        fi

        launched_count=$((launched_count + 1))
    done < "$config_file"

    print -- "🎉 起動処理が完了しました。対象: $launched_count 件"
}