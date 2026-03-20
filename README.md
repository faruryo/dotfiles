# dotfiles

## Required

- MacOSX
- Bash v5

    ```bash
    brew install bash
    ```

### gpg key作成

[新しい GPG キーを生成する - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/managing-commit-signature-verification/generating-a-new-gpg-key)

### GPG コミット署名のトラブルシューティング

コミット時に `gpg: signing failed: No such file or directory` エラーが発生する場合、GUI（VS Code 等）からのパスフレーズ入力用プログラムの設定が必要です。

```bash
# gpg-agent.conf の作成と設定
touch ~/.gnupg/gpg-agent.conf
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf

# gpg-agent を再起動して設定を反映
gpgconf --kill gpg-agent
```

## Install & Update

1. 個人情報を設定する

    設定しない場合はGitの設定がなされません。

    ```sh
    export GIT_NAME=<GitHubアカウント名>
    export GIT_EMAIL=<GitHub登録メールアドレス>
    export GIT_SIGNINGKEY=<GitHubに登録したGPGキー>
    ```

1. install実行

    ```sh
    curl https://raw.githubusercontent.com/faruryo/dotfiles/main/install.sh | $(brew --prefix)/bin/bash
    ```

1. gh setup

    ```sh
    gh auth login
    ```
