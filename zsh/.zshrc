HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
HISTFILESIZE=100000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_SAVE_NO_DUPS

autoload -U colors && colors

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export DOTFILES_DIR="$HOME/dotfiles"
source "$DOTFILES_DIR/shell/.profile"

command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

bindkey -e
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
else
    bindkey '^R' history-incremental-search-backward
fi
