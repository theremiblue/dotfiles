export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
export HOMEBREW_NO_ENV_HINTS=1

if command -v brew >/dev/null 2>&1; then
    homebrew_prefix="$(command brew --prefix)"
    export PATH="$homebrew_prefix/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="$homebrew_prefix/opt/coreutils/libexec/gnuman:$MANPATH"
    unset homebrew_prefix
fi

if ! command -v zed >/dev/null 2>&1; then
    alias zed='open -a Zed'
fi

brew() {
    local confirm
    local side_effects

    case "$1" in
        upgrade) side_effects="upgrades formulae and may rebuild dependents" ;;
        cleanup) side_effects="removes cached downloads and old versions" ;;
        autoremove) side_effects="removes unused dependencies" ;;
        *)
            command brew "$@"
            return
            ;;
    esac

    echo "run screw"
    echo "Command: brew $*"
    echo "Side effects: $side_effects"
    printf "Proceed? [y/N]: "
    read -r confirm

    if [[ "$confirm" != [yY] ]]; then
        echo "Skipped"
        return 0
    fi

    command brew "$@"
}
