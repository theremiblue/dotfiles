-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
--
hl.config({
    input = {
        kb_layout  = "us,ru",

        repeat_rate = 40,
        repeat_delay = 400,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
            drag_lock = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

