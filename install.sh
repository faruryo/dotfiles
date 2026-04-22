#! /usr/bin/env bash
set -u

e_newline() {
    printf "\n"
}

e_header() {
    printf "\033[37;1m%s\033[m\n" "$*"
}

e_error() {
    printf "\033[31m%s\033[m\n" "✖ $*" 1>&2
}

if command -v brew >/dev/null 2>&1; then
    chmod -R go-w $(brew --prefix)/share
fi

DOTPATH=${DOTPATH:-$HOME/.dotfiles}
REPO="https://github.com/faruryo/dotfiles"

if [ -d "$DOTPATH" ]; then
    e_header "$DOTPATH: already exists"
    cd "$DOTPATH" && git switch main && git pull
else
    e_newline
    e_header "Downloading dotfiles..."
    git clone --recursive "$REPO" "$DOTPATH"
fi

brew bundle --file $DOTPATH/Brewfile

if ! command -v volta >/dev/null 2>&1; then
    curl https://get.volta.sh | bash
    volta install node@latest
fi

e_header "Symlink z files..."
XDG_CONFIG_HOME=$HOME/.config

# files
dot_files="zshenv:zsh/.zshenv gitconfig:git/gitconfig"
for item in $dot_files; do
    file="${item%%:*}"
    path="${item#*:}"
    if [[ -f $HOME/.$file && ! -L $HOME/.$file ]]; then
        mv -v $HOME/.$file $HOME/.$file.$(date +'%Y%m%d%H%M%S').backup
    fi
    ln -vsnf $DOTPATH/$path $HOME/.$file
done

# directories
link_dirs=(zsh git tmux mise)
for dir in "${link_dirs[@]}"; do
    if [[ -d "$XDG_CONFIG_HOME/$dir" && ! -L "$XDG_CONFIG_HOME/$dir" ]]; then
        mv -v $XDG_CONFIG_HOME/$dir $XDG_CONFIG_HOME/$dir.$(date +'%Y%m%d%H%M%S').backup
    fi
    ln -vsnf $DOTPATH/$dir $XDG_CONFIG_HOME/$dir
done

# パスを取得
export GPG_PATH=$(command -v gpg)
export GH_PATH=$(command -v gh)

# 変数チェック
vars=(GIT_NAME GIT_EMAIL GIT_SIGNINGKEY GPG_PATH GH_PATH)
for var in "${vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        e_error "$var is not set."
        exit 1
    fi
done

# template展開
vars_str=\$$(echo ${vars[@]} | sed 's/ /$/g')
for dir in "${link_dirs[@]}"; do
    # envsubst < git/gitconfig.tmpl
    for file in $(find . -path "./${dir}/*.tmpl"); do
        echo $file => ${file%.tmpl}
        cat ${file} | envsubst "${vars_str}" > ${file%.tmpl}
    done
done