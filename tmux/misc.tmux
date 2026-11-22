set -g mouse on

set -s escape-time 0
set -g focus-events on
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on
set -g detach-on-destroy off
set -g history-limit 50000
set -g display-time 2000
set -g status-interval 5

set -g set-titles on
set -g set-titles-string "#S:#W"

set -g default-terminal "tmux-256color"
set -s extended-keys on
set -as terminal-features ',xterm-ghostty:RGB'
set -as terminal-features ',xterm-ghostty:extkeys'
set -as terminal-features ',xterm-ghostty:usstyle'
set -as terminal-features ',xterm-ghostty:sync'
set -g allow-passthrough on
