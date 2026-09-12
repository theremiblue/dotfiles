-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local props = require("props")

local gaps_and_rounding = _G.gaps_and_rounding
if gaps_and_rounding == nil then
    gaps_and_rounding = props.gaps_and_rounding
end

local enabled = gaps_and_rounding == true or type(gaps_and_rounding) == "table"
local popup_border_size = 2
local popup_rounding = 0

if enabled then
    if type(gaps_and_rounding) == "table" then
        popup_border_size = gaps_and_rounding.border_size or 2
        popup_rounding = gaps_and_rounding.rounding or 8
    else
        popup_border_size = 2
        popup_rounding = 8
    end
else
    if type(gaps_and_rounding) == "table" and gaps_and_rounding.border_size then
        popup_border_size = gaps_and_rounding.border_size
    end
    popup_rounding = 0
end

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "telegram-workspace",
    match = { class = "^(org\\.telegram\\.desktop|TelegramDesktop)$" },

    workspace = "4",
})

hl.window_rule({
    name  = "discord-workspace",
    match = { class = "^(discord|Discord)$" },

    workspace = "5",
})

hl.window_rule({
    name  = "browser-workspace",
    match = { class = "^(librewolf|LibreWolf)$" },

    workspace = "2",
})

hl.window_rule({
    name  = "reaper-workspace",
    match = { class = "^REAPER$" },

    workspace = "7",
})

hl.window_rule({
    name  = "reaper-low-compositor",
    match = { class = "^REAPER$" },

    immediate  = true,
    no_anim    = true,
    no_blur    = true,
    no_dim     = true,
    no_shadow  = true,
    opaque     = true,
    force_rgbx = true,
    decorate   = false,
    rounding   = 0,
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_in   = 0,
    gaps_out  = 0,
})

hl.window_rule({
    name  = "no-border-maximized-tiled",
    match = { float = false, workspace = "f[1]" },

    border_size = 0,
    rounding    = 0,
})

-- Floating / popup windows get borders (sharp when gaps_and_rounding is off) and shadow
hl.window_rule({
    name  = "floating-popup-borders",
    match = { float = true },

    border_size = popup_border_size,
    rounding    = popup_rounding,
})

-- Tiled windows do not have shadows
hl.window_rule({
    name  = "tiled-no-shadow",
    match = { float = false },

    no_shadow = true,
})
