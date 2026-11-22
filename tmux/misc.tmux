set -g mouse on

set -s escape-time 0
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on

set -g history-limit 8192

set -g default-terminal "tmux-256color"
set -s extended-keys on
set -as terminal-features ',xterm-ghostty:RGB'
set -as terminal-features ',xterm-ghostty:extkeys'
set -g allow-passthrough on

