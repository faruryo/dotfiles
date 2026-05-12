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
brew bundle install --file="$HOME/dotfiles/Brewfile"
```

2 行目で Brewfile にあるツールをまとめてインストールします。

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
| **Worktrunk** | Git worktree 管理 | `wt` |
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
Alt+d    → 開発用タブ（2カラム: Git/Claude）
Alt+y    → フローティング Yazi（ファイラ）
Alt+g    → フローティング Lazygit
Alt+[    → レイアウト切り替え（2カラム/集中/全画面）
```

### Atuin（履歴検索）

```sh
atuin stats
atuin search <キーワード>
```

- `Ctrl+R` で履歴をインタラクティブ検索できます。
- `atuin stats` でよく使うコマンドの統計を見られます。

### browser-use（AIブラウザ操作）

AIエージェント向けのブラウザ操作ライブラリです。

```sh
# 専用の仮想環境が自動構築されています
~/.browser-use-env/bin/python your_agent.py
```

- `~/.browser-use-env` にライブラリと専用の Chromium がインストールされています。

### playwright-cli（Playwright CLI）

Playwright をコマンドラインから操作するための公式ツールです。

```sh
playwright-cli --help
playwright-cli open https://example.com
```

- `volta` を介してグローバルにインストールされています。

### Zoxide（ディレクトリジャンプ）

```sh
cd proj
cd
zi
```

- `cd proj` で `proj` を含む直近のディレクトリに移動します。
- `cd` で `zi` 相当のインタラクティブ選択を開けます。
- `zi` で候補を選んでジャンプできます。

### Yazi（ファイルマネージャー）

```sh
yazi
```

- `yazi` で起動します。終了時に現在ディレクトリへ `cd` されます。
- 移動は `h/j/k/l`、開くには `Enter`、検索は `/`、終了は `q` です。
- `.` で隠しファイルの表示切り替え、`y` と `p` でコピーとペースト、`Space` で複数選択できます。

zsh から yazi を開いて終了時に自動 cd させる：

```sh
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -s "$tmp" ]; then cd "$(cat "$tmp")"; fi
    rm -f "$tmp"
}
```

この関数は [home/dot_config/zsh/dot_zshrc](home/dot_config/zsh/dot_zshrc) に追加済みです。

### Lazygit（Git TUI）

```sh
lazygit
```

プロジェクトルートで実行すると起動します。

```
Space           # ファイルをステージ / アンステージ
c               # コミット
P               # プッシュ
p               # プル
b               # ブランチ操作
?               # ヘルプ
```

Claude Code がコード変更した後の差分確認・コミットに最適です。

### Worktrunk（git worktree 管理）

```sh
wt start feature/my-task
wt list
wt remove feature/my-task
```

- `wt start <branch>` で作業用 worktree を作成してその場で移動できます。
- `wt list` で worktree 一覧を確認できます。
- `wt remove <branch>` で不要な worktree を片付けられます。
- zsh では shell integration を自動ロードしているため、`wt` 実行後のディレクトリ移動もそのまま反映されます。

### fzf-tab（補完）

```sh
cd <Tab>
git checkout <Tab>
kill <Tab>
```

- `cd <Tab>` でディレクトリをファジー選択します。
- `git checkout <Tab>` でブランチをファジー選択します。
- `kill <Tab>` でプロセスをファジー選択します。

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
lazygit
```

Claude Code で変更を入れたあとに `lazygit` を開き、差分を確認してからステージとコミットを進めます。

### Yazi × Zellij

Zellij のフローティングペインで Yazi を開いてディレクトリツリーを俯瞰：

```
Ctrl+p → f    # フローティングペインを開く
yazi          # Yazi 起動
q             # Yazi 終了 → ペインも閉じる

またはショートカットを使用：

Alt+y         # 一撃でフローティング Yazi を起動
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
echo "go 1.24.5" > .tool-versions
echo "export GOFLAGS=-mod=vendor" > .envrc
direnv allow
```

- `.tool-versions` を置くと `mise` がランタイムを自動認識します。
- `direnv allow` を実行すると、以後はディレクトリに入るだけで Go のバージョンと環境変数が自動で反映されます。

---

## 日常的な chezmoi の使い方

```sh
chezmoi apply
chezmoi diff
chezmoi edit ~/.zshenv
chezmoi update
chezmoi status
chezmoi re-add ~/.config/starship.toml
```

- `chezmoi apply` で変更をホームディレクトリに適用します。
- `chezmoi diff` で適用前の差分を確認できます。
- `chezmoi edit ~/.zshenv` でソースを編集し、そのまま `apply` まで進められます。
- `chezmoi update` で `git pull` と `apply` をまとめて実行できます。
- `chezmoi status` で未適用の変更を確認できます。
- `chezmoi re-add ~/.config/starship.toml` でホーム側の直接編集をソースへ取り込めます。

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
