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

chmod -R go-w $(brew --prefix)/share

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

asdf plugin-add nodejs
asdf install nodejs latest
asdf global nodejs latest

e_header "Symlink z files..."
XDG_CONFIG_HOME=$HOME/.config

# files
declare -A dot_files
dot_files=(
    ["zshenv"]="zsh/.zshenv" \
    ["gitconfig"]="git/gitconfig" \
)
for file in "${!dot_files[@]}"; do
    if [[ -f  $HOME/.$file && ! -L $HOME/.$file ]]; then
        mv -v $HOME/.$file $HOME/.$file.$(date +'%Y%m%d%H%M%S').backup
    fi
    ln -vsnf $DOTPATH/${dot_files[$file]} $HOME/.$file
done

# directories
link_dirs=(zsh git tmux)
for dir in "${link_dirs[@]}"; do
    if [[ -d "$XDG_CONFIG_HOME/$dir" && ! -L "$XDG_CONFIG_HOME/$dir" ]]; then
        mv -v $XDG_CONFIG_HOME/$dir $XDG_CONFIG_HOME/$dir.$(date +'%Y%m%d%H%M%S').backup
    fi
    ln -vsnf $DOTPATH/$dir $XDG_CONFIG_HOME/$dir
done

# 変数チェック
vars=(GIT_NAME GIT_EMAIL GIT_SIGNINGKEY)
for var in "${vars[@]}"; do
    eval 'echo $'$var > /dev/null
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