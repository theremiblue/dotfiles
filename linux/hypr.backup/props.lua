local props = {
    mod = "WIN",
    mod_shift = "WIN + SHIFT",
    super = "WIN",
    super_shift = "WIN + SHIFT",
    mouse_mod = "WIN",

    -- Controls window borders, rounded corners, and spaces (gaps) between windows (off by default)
    gaps_and_rounding = false,

    programs = {
        terminal    = "kitty",
        fileManager = "thunar",
        menu        = "lantern",
        browser     = "librewolf",
    },
}

_G.gaps_and_rounding = props.gaps_and_rounding

return props
