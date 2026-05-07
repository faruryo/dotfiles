# dotfiles

chezmoi で管理している macOS 用の dotfiles です。

## 新規マシンへの導入

### 事前準備

- macOS
- Homebrew（未インストールの場合は install.sh が自動でインストール）
- GPG キー（[新しい GPG キーを生成する - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key)）

### インストール

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/faruryo/dotfiles/main/install.sh)
```

実行すると以下を順番に行います：

1. Homebrew のインストール（未インストール時）
2. chezmoi のインストール
3. `~/dotfiles` にリポジトリをクローン
4. `chezmoi apply` を実行

初回実行時に以下を対話的に入力します（2回目以降は入力不要）：

- Git コミット著者名
- Git メールアドレス
- GPG 署名キー ID

### インストール後

```sh
gh auth login
brew bundle --file=~/dotfiles/Brewfile   # 全ツールをインストール
```

---

## ツールスタック

### ターミナル・シェル環境

| ツール | 役割 | 起動 |
|---|---|---|
| **Ghostty** | ターミナルエミュレータ | アプリから起動 |
| **Zellij** | ターミナルマルチプレクサ（tmux 代替） | `zellij` |
| **Starship** | プロンプト（自動ロード） | — |
| **Atuin** | シェル履歴検索 | `Ctrl+R` |
| **Zoxide** | ディレクトリジャンプ（cd 代替） | `cd <部分名>` |
| **fzf-tab** | zsh 補完のファジー化（自動ロード） | `Tab` |

### ファイル・Git

| ツール | 役割 | 起動 |
|---|---|---|
| **Yazi** | TUI ファイルマネージャー | `yazi` |
| **Lazygit** | TUI Git クライアント | `lazygit` |
| **fzf** | ファジーファインダー | `Ctrl+T`（ファイル）/ `**Tab` |

### 開発環境管理

| ツール | 役割 | 主なコマンド |
|---|---|---|
| **mise** | ランタイムバージョン管理 | `mise use go@latest` |
| **direnv** | ディレクトリ別環境変数 | `.envrc` を置くだけ |
| **Volta** | Node.js バージョン管理 | `volta install node` |

---

## 各ツールの使い方

### Zellij（マルチプレクサ）

画面下部にキーバインドが常時表示されるため、覚える必要は最小限です。

```
Ctrl+p → 新規ペイン           Ctrl+p → n（新規）/ x（閉じる）
Ctrl+t → タブ操作             Ctrl+n（新規タブ）
Ctrl+p → f  フローティングペイン（一時的なウィンドウ）
Alt+←→ → ペイン間移動
```

### Atuin（履歴検索）

```sh
Ctrl+R          # 履歴をインタラクティブ検索（fzf 風 UI）
atuin stats     # よく使うコマンドの統計
atuin search <キーワード>
```

### Zoxide（ディレクトリジャンプ）

```sh
cd proj         # "proj" を含む直近のディレクトリに移動（学習型）
cd              # zi でインタラクティブ選択（fzf UI）
zi              # fzf で候補を選んでジャンプ
```

### Yazi（ファイルマネージャー）

```sh
yazi            # 起動。終了時に現在ディレクトリに cd される
h/j/k/l         # 移動（Vim キー）
Enter           # 開く / ディレクトリに入る
.               # 隠しファイルの表示/非表示
y               # コピー、p でペースト
Space           # 複数選択
/               # 検索
q               # 終了
```

zsh から yazi を開いて終了時に自動 cd させる：

```sh
# ~/.config/zsh/.zshrc に追加済み（y コマンドとして使いたい場合）
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -s "$tmp" ]; then cd "$(cat "$tmp")"; fi
    rm -f "$tmp"
}
```

### Lazygit（Git TUI）

```sh
lazygit         # プロジェクトルートで起動
```

```
Space           # ファイルをステージ / アンステージ
c               # コミット
P               # プッシュ
p               # プル
b               # ブランチ操作
?               # ヘルプ
```

Claude Code がコード変更した後の差分確認・コミットに最適です。

### fzf-tab（補完）

```sh
cd <Tab>        # ディレクトリをファジー選択
git checkout <Tab>  # ブランチをファジー選択
kill <Tab>      # プロセスをファジー選択
```

### Starship（プロンプト）

コンテキストに応じて自動表示：

```
~/proj/myapp main [↑2] rs 1.89.0    ⎈ local
❯
```

- `main [↑2]` — ブランチ名と git 状態
- `rs 1.89.0` — 言語バージョン（go / rs / py / node / tf など）
- `⎈ local` — kubectl コンテキスト
- `☁️` — gcloud アカウント
- `3s` — 3 秒以上かかったコマンドの実行時間

---

## ツールの組み合わせ方

### Claude Code × Lazygit

エージェントが大量のファイルを変更した後に差分を精査する：

```sh
# Claude Code でタスクを実行
# → 変更後に lazygit を開いてペインで確認
lazygit
# Space で1行ずつステージ → c でコミット
```

### Yazi × Zellij

Zellij のフローティングペインで Yazi を開いてディレクトリツリーを俯瞰：

```
Ctrl+p → f    # フローティングペインを開く
yazi          # Yazi 起動
q             # Yazi 終了 → ペインも閉じる
```

### Atuin × fzf-tab

コマンド履歴から再実行：

```
Ctrl+R → 検索ワード → Enter    # 過去のコマンドを再実行
↑/↓                            # 候補を絞り込み
```

### mise × direnv

プロジェクトごとに自動でランタイムを切り替える：

```sh
# プロジェクトルートで
echo "go 1.24.5" > .tool-versions   # mise が自動認識
echo "export GOFLAGS=-mod=vendor" > .envrc
direnv allow                          # .envrc を有効化
# → ディレクトリに入ると自動で go 1.24.5 + 環境変数が設定される
```

---

## 日常的な chezmoi の使い方

```sh
chezmoi apply           # 変更をホームディレクトリに適用
chezmoi diff            # 適用前に差分を確認
chezmoi edit ~/.zshenv  # ソースファイルを編集して apply
chezmoi update          # git pull + apply を一度に実行
chezmoi status          # 未適用の変更を確認
chezmoi re-add ~/.config/starship.toml  # 直接編集した設定を取り込む
```

---

## VS Code project launcher

複数のプロジェクトをまとめて VS Code で開くために、zsh 関数 `code-projects` を用意しています。

```sh
cp ~/.config/zsh/.vscode-projects.example ~/.config/zsh/.vscode-projects.local
```

`~/.config/zsh/.vscode-projects.local` を編集する：

- 1 行に 1 ディレクトリを書く
- 空行と `#` で始まる行は無視される
- `$HOME` と `~` を使える

```sh
code-projects
```

各ディレクトリに `.envrc` があり `direnv` が使える場合は `direnv exec` 経由で起動し、それ以外は通常の `code` 起動になります。

---

## GPG コミット署名のトラブルシューティング

コミット時に `gpg: signing failed: No such file or directory` が出る場合：

```sh
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```
