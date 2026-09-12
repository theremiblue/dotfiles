-- https://wiki.hypr.land/ used as a reference
-- TODO: split into multiple files

local props = require("props")

hl.monitor({
    output   = "DP-1",
    mode     = "3840x2160@120",
    position = "0x0",
    -- 4K UI scale: 3840x2160 / 1.5 = 2560x1440 logical pixels.
    scale    = 1.5,
    bitdepth = 10,

    -- Accurate, compatible SDR desktop. HDR clients can trigger the
    -- automatic switch configured below.
    cm       = "srgb",
    sdr_eotf = "srgb",

    -- Only enable VRR for fullscreen game/video content.
    -- Change to 0 if this display does not activate VRR or shows flicker.
    vrr = 3,
})

hl.config({
    render = {
        cm_enabled = true,

        cm_auto_hdr = 1,

        send_content_type = true,

        use_fp16 = 2,

        -- Preserve an SDR copy when necessary for screenshots/sharing.
        keep_unmodified_copy = 2,

        -- Leave direct scanout conservative on NVIDIA. Change to 2 later
        -- only after confirming games, HDR and overlays behave correctly.
        direct_scanout = 0,
    },

    cursor = {
        -- Avoid cursor movement disrupting fullscreen VRR where possible.
        no_break_fs_vrr = 2,

        -- The EDID advertises a minimum vertical rate of 48 Hz.
        min_refresh_rate = 48,

        -- Hyprland's automatic NVIDIA cursor-buffer handling.
        use_cpu_buffer = 2,
    },

    quirks = {
        -- Leave disabled normally. Set to 2 only if Gamescope refuses to
        -- expose HDR until the output is already in HDR mode.
        prefer_hdr = 0,
    },
})

require("env")
hl.on("hyprland.start", require("autostart"))
require("permissions")
require("look")
require("rules")
require("input")
require("binds")
