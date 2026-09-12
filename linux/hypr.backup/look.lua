local props = require("props")

-- Global variable or props setting controls rounded borders and gaps
local gaps_and_rounding = _G.gaps_and_rounding
if gaps_and_rounding == nil then
    gaps_and_rounding = props.gaps_and_rounding
end

local enabled = gaps_and_rounding == true or type(gaps_and_rounding) == "table"
local gaps_in = 0
local gaps_out = 0
local rounding = 0
local border_size = 0

if enabled then
    if type(gaps_and_rounding) == "table" then
        gaps_in = gaps_and_rounding.gaps_in or 4
        gaps_out = gaps_and_rounding.gaps_out or 8
        rounding = gaps_and_rounding.rounding or 8
        border_size = gaps_and_rounding.border_size or 2
    else
        gaps_in = 4
        gaps_out = 8
        rounding = 8
        border_size = 2
    end
end

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = gaps_in,
        gaps_out = gaps_out,

        border_size = border_size,

        resize_on_border = false,

        allow_tearing = true,

        col = {
            active_border   = "rgba(81a2beee)",
            inactive_border = "rgba(373b41aa)",
        },

        layout = "dwindle",
    },

    xwayland = {
        -- XWayland apps appear blurry otherwise
        -- Specific frameworks scale will be controlled through the environment in env
        force_zero_scaling = true,
    },

    dwindle = {
        preserve_split = true,
    },

    decoration = {
        rounding       = rounding,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 2,
            color        = "rgba(00000066)",
        },

        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,

        bezier = {
            instantish = { 0.1, 0.9, 0.2, 1.0 },
        },

        animation = {
            windows = { true, 1, "instantish", "slide" },
            windowsOut = { true, 1, "instantish", "slide" },

            border = { false },
            fade = { false },
            workspaces = { false },
            layers = { false },
        },
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },

    render = {
        direct_scanout = true,
    },
})

-- -- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
-- hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
-- hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
-- hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
-- hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
--
-- -- Default springs
-- hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
--
-- hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
-- hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
-- hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
--
