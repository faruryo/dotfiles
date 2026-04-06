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

# mise (version manager)
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# kubectl
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi
alias k=kubectl
compdef __start_kubectl k

# direnv
emulate zsh -c "$(direnv hook zsh)"

# gcloud
source $(brew --prefix)/Caskroom/gcloud-cli/latest/google-cloud-sdk/completion.zsh.inc
source $(brew --prefix)/Caskroom/gcloud-cli/latest/google-cloud-sdk/path.zsh.inc

# gpg
export GPG_TTY=$(tty)

if [[ -r "${0:A:h}/code-projects.zsh" ]]; then
    source "${0:A:h}/code-projects.zsh"
fi
