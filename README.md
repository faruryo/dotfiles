# dotfiles

## Required

- MacOSX
- Bash v5

    ```bash
    brew install bash
    ```

### gpg key作成

[新しい GPG キーを生成する - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key)

## Install

1. 個人情報を設定する

    ```sh
    export GIT_NAME=<GitHubアカウント名>
    export GIT_EMAIL=<GitHub登録メールアドレス>
    export GIT_SIGNINGKEY=<GitHubに登録したGPGキー>
    ```

1. install実行

    ```sh
    curl https://raw.githubusercontent.com/faruryo/dotfiles/master/install.sh | $(brew --prefix)/bin/bash
    ```
