local props = require("props")

local function app_on_workspace(workspace, command)
    hl.exec_cmd("[workspace " .. workspace .. " silent] uwsm app -- " .. command)
end

return function()
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- quickshell")

    hl.exec_cmd("uwsm app -- /usr/lib/polkit-kde-authentication-agent-1")

    app_on_workspace(1, props.programs.terminal)
    app_on_workspace(4, "telegram-desktop")
    app_on_workspace(2, props.programs.browser)
end
