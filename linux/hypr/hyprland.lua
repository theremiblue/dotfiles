-- https://wiki.hypr.land/ used as a reference
-- TODO: split into multiple files

local props = require("props")

hl.monitor({
    output   = "DP-1",
    mode     = "3840x2160@144",
    position = "0x0",
    scale    = 1.5,
})

require("env")
hl.on("hyprland.start", require("autostart"))
require("permissions")
require("look")
require("rules")
require("input")
require("binds")
