export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias ls='ls --color=auto -lt'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

case "$(uname -s)" in
    Linux)
        if ! command -v zed >/dev/null 2>&1 &&
            command -v zeditor >/dev/null 2>&1; then
            alias zed='zeditor'
        fi
        ;;
    # TODO: do we need it? Test on clean windows setup
    MINGW*|MSYS*|CYGWIN*)
        if ! command -v zed >/dev/null 2>&1 &&
            command -v zed.exe >/dev/null 2>&1; then
            alias zed='zed.exe'
        fi
        ;;
esac

ls_base_="ls -lAh --time-style=long-iso"

alias lsl="$ls_base_ --sort=name --group-directories-first"
alias lslt="$ls_base_ -t"

