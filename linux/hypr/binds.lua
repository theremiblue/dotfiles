-- https://wiki.hypr.land/Configuring/Basics/Binds/

local props = require("props")


local lmb = "mouse:272"
local rmb = "mouse:273"

hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
-- hl.bind(props.mod .. " + M",
hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")

hl.bind(props.mod .. " + C", hl.dsp.window.close())

hl.bind(props.mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(props.mod .. " + P", hl.dsp.window.pseudo())       -- TODO: what?
hl.bind(props.mod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with props.mod + arrow keys
hl.bind(props.mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(props.mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(props.mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(props.mod .. " + down", hl.dsp.focus({ direction = "down" }))


-- Switch workspaces with props.mod + [0-9]
-- Move active window to a workspace with props.mod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(props.super .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(props.super .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(props.mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(props.mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with props.mod + LMB/RMB and dragging
hl.bind(props.mod .. " + " .. lmb, hl.dsp.window.drag(), { mouse = true })
hl.bind(props.mod .. " + " .. rmb, hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- TODO: super key doesn't work
hl.bind(props.mod .. " + Return", hl.dsp.exec_cmd(props.programs.terminal))
hl.bind(props.mod .. " + E", hl.dsp.exec_cmd(props.programs.fileManager))
hl.bind(props.mod .. " + R", hl.dsp.exec_cmd(props.programs.menu))
hl.bind("ALT + Space", hl.dsp.exec_cmd(props.programs.menu))
hl.bind(props.mod .. " + B", hl.dsp.exec_cmd(props.programs.browser))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("screenshot full-copy"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("screenshot region-copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("screenshot full-save"))
hl.bind("CTRL + ALT + Print", hl.dsp.exec_cmd("screenshot region-save"))
