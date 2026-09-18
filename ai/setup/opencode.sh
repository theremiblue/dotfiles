#!/bin/bash
set -e

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$(cd "$AI_DIR/.." && pwd)"

if [ -z "$DOTFILES_LINK_DIR" ]; then
    . "$DOTFILES_DIR/scripts/setup-lib.sh"
fi

lnk "ai/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
