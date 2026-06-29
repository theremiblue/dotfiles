local Mode = {
    Normal    = 0,
    NoBorders = 1,
    Fullscreen = 2,
}

local function current_mode(window)
    if not window or window.fullscreen == 0 then
        return Mode.Normal
    end

    if window.fullscreen == 1 then
        return Mode.NoBorders
    end

    return Mode.Fullscreen
end

local function apply_mode(mode)
    if mode == Mode.Normal then
        hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 0, action = "set" }))
    elseif mode == Mode.NoBorders then
        hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 1, client = 1, action = "set" }))
    else
        hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "set" }))
    end
end

local function next_mode(mode)
    if mode == Mode.Normal then
        return Mode.NoBorders
    end

    if mode == Mode.NoBorders then
        return Mode.Fullscreen
    end

    return Mode.Normal
end

return {
    Mode = Mode,

    cycle = function()
        local window = hl.get_active_window()

        if not window then
            return
        end

        apply_mode(next_mode(current_mode(window)))
    end,
}
