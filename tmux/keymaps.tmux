unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

bind r source-file "$HOME/.config/tmux/tmux.conf" \; display-message "tmux reloaded"

set -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi C-v send -X rectangle-toggle
bind -T copy-mode-vi y send -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send -X cancel

bind Space last-window

bind c new-window -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind -r C-j resize-pane -D 5
bind -r C-k resize-pane -U 5
bind -r C-h resize-pane -L 5
bind -r C-l resize-pane -R 5

bind -r "<" swap-window -d -t -1
bind -r ">" swap-window -d -t +1

bind f display-popup -E -w 50% -h 50% -T " sessions " 'tmux list-sessions -F "#S" | fzf --reverse --border=none --prompt="> " | xargs -r tmux switch-client -t'
bind t display-popup -E -w 80% -h 80% -d "#{pane_current_path}" -T " scratch "
bind g display-popup -E -w 85% -h 85% -d "#{pane_current_path}" -T " git " 'sh -c "if command -v lazygit >/dev/null 2>&1; then lazygit; else git status; read -r _; fi"'
