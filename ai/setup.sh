#!/bin/bash
set -e

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$AI_DIR/.." && pwd)"

if [ -z "$DOTFILES_LINK_DIR" ]; then
    . "$DOTFILES_DIR/scripts/setup-lib.sh"
fi

section "ai"

agents=("$@")
if [ ${#agents[@]} -eq 0 ]; then
    agents=("antigravity")
fi

run_agent_setup() {
    local agent="$1"
    case "$agent" in
        agy|antigravity)
            bash "$AI_DIR/setup/antigravity.sh"
            ;;
        claude)
            bash "$AI_DIR/setup/claude.sh"
            ;;
        opencode)
            bash "$AI_DIR/setup/opencode.sh"
            ;;
        codex)
            bash "$AI_DIR/setup/codex.sh"
            ;;
        all)
            bash "$AI_DIR/setup/antigravity.sh"
            bash "$AI_DIR/setup/claude.sh"
            bash "$AI_DIR/setup/opencode.sh"
            bash "$AI_DIR/setup/codex.sh"
            ;;
        *)
            echo "Unknown agent: $agent" >&2
            exit 1
            ;;
    esac
}

for agent in "${agents[@]}"; do
    run_agent_setup "$agent"
done
