set -g status-style "bg=#{@base00},fg=#{@base05}"
set -g status-justify left
set -g status-position bottom

set -g status-left-length 48
set -g status-left ' #[fg=#{@base0D}]#S #[fg=#{@base02}]│ '

set -g status-right-length 64
set -g status-right '#{?client_prefix,#[fg=#{@base0D}]PREFIX #[fg=#{@base02}]│ ,}#{?pane_in_mode,#[fg=#{@base0A}]COPY #[fg=#{@base02}]│ ,}#{?window_zoomed_flag,#[fg=#{@base0E}]ZOOM #[fg=#{@base02}]│ ,}#[fg=#{@base03}]#H '

set -g window-status-separator ""
set -g window-status-style "fg=#{@base03},bg=default"
set -g window-status-format " #I:#W "
set -g window-status-current-style "fg=#{@base07},bg=#{@base01}"
set -g window-status-current-format "#[fg=#{@base0D}]▎#[fg=#{@base07}]#I:#W#{?window_zoomed_flag, Z,} "
set -g window-status-activity-style "fg=#{@base0A},bg=default"
set -g window-status-bell-style "fg=#{@base08},bg=default"

set -g pane-border-lines single
set -g pane-border-style "fg=#{@hairline}"
set -g pane-active-border-style "fg=#{@base0D}"

set -g mode-style "bg=#{@base02},fg=#{@base06}"
set -g copy-mode-match-style "bg=#{@base02},fg=#{@base0A}"
set -g copy-mode-current-match-style "bg=#{@base0A},fg=#{@base00}"

set -g message-style "bg=#{@base01},fg=#{@base06}"
set -g message-command-style "bg=#{@base01},fg=#{@base0D}"

set -g popup-style "bg=#{@base00},fg=#{@base05}"
set -g popup-border-style "fg=#{@base02}"
set -g popup-border-lines single
