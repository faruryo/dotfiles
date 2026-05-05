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
```

---

## 既存環境からの移行（旧シンボリックリンク方式 → chezmoi）

以前の `install.sh`（`~/.dotfiles/` へのシンボリックリンク方式）を使っていた場合の移行手順です。

### 1. chezmoi をインストール

```sh
brew install chezmoi
```

### 2. リポジトリを取得

すでに `~/dotfiles` にクローン済みの場合はスキップ。

```sh
git clone https://github.com/faruryo/dotfiles ~/dotfiles
```

### 3. chezmoi の設定ファイルを作成

```sh
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << EOF
sourceDir = "$HOME/dotfiles/home"

[data]
    gitName    = "YOUR_GIT_NAME"
    gitEmail   = "YOUR_GIT_EMAIL"
    signingKey = "YOUR_GPG_KEY_ID"
EOF
```

現在の signingKey は `git config user.signingkey` で確認できます。

### 4. 古いシンボリックリンクを削除

```sh
rm -f ~/.zshenv ~/.gitconfig
rm -f ~/.config/zsh ~/.config/git ~/.config/tmux ~/.config/mise
```

### 5. chezmoi を適用

```sh
chezmoi apply
```

### 6. 動作確認

```sh
chezmoi status              # 差分なし（何も pending でない）
cat ~/.config/git/config    # name/email が正しく展開されているか確認
ls ~/.config/zsh/.zprezto   # Prezto がクローンされているか確認
```

### 7. 古いリポジトリを削除（任意）

問題なければ古い `~/.dotfiles/` は不要です。

```sh
rm -rf ~/.dotfiles
```

---

## 日常的な使い方

```sh
chezmoi apply           # 変更をホームディレクトリに適用
chezmoi diff            # 適用前に差分を確認
chezmoi edit ~/.zshenv  # ソースファイルを編集して apply
chezmoi update          # git pull + apply を一度に実行
chezmoi status          # 未適用の変更を確認
```

ファイルを直接編集した場合はソースに取り込む：

```sh
chezmoi re-add ~/.zshenv
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
