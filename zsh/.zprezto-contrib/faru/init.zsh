#brew
if [[ -r /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -r /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# complete
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    autoload -Uz compinit && compinit
fi

# asdf
if [[ -r $(brew --prefix asdf)/asdf.sh ]]; then
    . $(brew --prefix asdf)/asdf.sh
fi
if [[ -r $(brew --prefix asdf)/libexec/asdf.sh ]]; then
    . $(brew --prefix asdf)/libexec/asdf.sh
fi

# JavaScript
PATH=$PATH:~/.volta/bin

# go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# pipx
export PATH="$PATH:~/.local/bin"

# kubectl
if [[ -r $HOME/.asdf/shims/kubectl ]]; then
    source <(kubectl completion zsh)
elif [[ -r $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin/kubectl ]]; then
    source <(kubectl completion zsh)
fi
alias k=kubectl
compdef __start_kubectl k

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# direnv
emulate zsh -c "$(direnv hook zsh)"

# gcloud
source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

# gpg
export GPG_TTY=$(tty)
