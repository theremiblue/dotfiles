pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root

    property var workspaces: []
    property int activeWorkspaceId: 0
    property var windows: []
    property var focusedWindow: null
    property string focusedWindowTitle: "Desktop"
    property var keyboardLayouts: []
    property int activeLayoutIndex: 0
    property string activeLayoutName: ""
    property string layoutLabel: "??"
    property bool overviewOpen: false
    property var casts: []
    readonly property bool isCasting: hasActiveCast()

    function compactLabel(value) {
        const text = String(value || "").trim();
        if (text.length === 0) {
            return "??";
        }

        const region = text.match(/\(([^)]+)\)/);
        if (region && region[1]) {
            return region[1].slice(0, 2).toUpperCase();
        }

        return text.slice(0, 2).toUpperCase();
    }

    function updateLayoutLabel() {
        if (activeLayoutIndex >= 0 && activeLayoutIndex < keyboardLayouts.length) {
            const name = keyboardLayouts[activeLayoutIndex];
            activeLayoutName = name;
            layoutLabel = compactLabel(name);
            return;
        }

        layoutLabel = "??";
    }

    function sortedWorkspaces(list) {
        return (list || []).slice().sort((left, right) => left.idx - right.idx);
    }

    function workspacesForOutput(outputName) {
        if (!outputName || outputName.length === 0) {
            return workspaces;
        }

        const filtered = workspaces.filter(ws => ws.output === outputName);
        return filtered.length > 0 ? filtered : workspaces;
    }

    function isWorkspaceOccupiedById(workspaceId) {
        return windows.some(w => w.workspace_id === workspaceId);
    }

    function hasActiveCast() {
        return casts.some(cast => cast && cast.is_active !== false);
    }

    function focusWorkspace(wsIdx) {
        runAction(["focus-workspace", wsIdx.toString()]);
    }

    function focusWorkspaceUp() {
        runAction(["focus-workspace-up"]);
    }

    function focusWorkspaceDown() {
        runAction(["focus-workspace-down"]);
    }

    function clearDynamicCastTarget() {
        runAction(["clear-dynamic-cast-target"]);
    }

    function toggleOverview() {
        runAction(["toggle-overview"]);
    }

    function switchLayout() {
        runAction(["switch-layout", "next"]);
    }

    function logout() {
        runAction(["quit", "--skip-confirmation"]);
    }

    function runAction(args) {
        const proc = actionProcess.createObject(root);
        proc.exec(["niri", "msg", "action", ...args]);
    }

    function handleWorkspacesChanged(list) {
        const ordered = sortedWorkspaces(list);
        workspaces = ordered;

        const active = ordered.find(ws => ws.is_focused || ws.is_active);
        if (active) {
            activeWorkspaceId = active.id;
        }
    }

    function handleWorkspaceActivated(id, focused) {
        const target = workspaces.find(ws => ws.id === id);
        const targetOutput = target ? target.output : null;

        if (focused) {
            activeWorkspaceId = id;
        }

        workspaces = workspaces.map(ws => {
            const sameOutput = targetOutput === null || ws.output === targetOutput;
            return Object.assign({}, ws, {
                is_active: sameOutput ? ws.id === id : ws.is_active,
                is_focused: focused ? ws.id === id : ws.is_focused
            });
        });
    }

    function handleWorkspaceUrgencyChanged(id, urgent) {
        workspaces = workspaces.map(ws => ws.id === id
            ? Object.assign({}, ws, { is_urgent: !!urgent })
            : ws);
    }

    function handleWorkspaceActiveWindowChanged(workspaceId, activeWindowId) {
        workspaces = workspaces.map(ws => ws.id === workspaceId
            ? Object.assign({}, ws, { active_window_id: activeWindowId })
            : ws);
    }

    function handleWindowsChanged(list) {
        windows = list || [];
        const focused = windows.find(w => w.is_focused);

        if (focused) {
            focusedWindow = focused;
            focusedWindowTitle = focused.title || "Desktop";
            return;
        }

        if (windows.length === 0) {
            focusedWindow = null;
            focusedWindowTitle = "Desktop";
        }
    }

    function handleWindowFocusChanged(id) {
        if (id === null || id === undefined) {
            focusedWindow = null;
            focusedWindowTitle = "Desktop";
            return;
        }

        const focused = windows.find(w => w.id === id);
        if (!focused) {
            return;
        }

        focusedWindow = focused;
        focusedWindowTitle = focused.title || "Desktop";
    }

    function handleWindowOpenedOrChanged(win) {
        if (!win) {
            return;
        }

        const exists = windows.some(w => w.id === win.id);
        windows = exists
            ? windows.map(w => w.id === win.id ? win : w)
            : windows.concat([win]);

        if (win.is_focused) {
            focusedWindow = win;
            focusedWindowTitle = win.title || "Desktop";
        }
    }

    function handleWindowClosed(closedId) {
        windows = windows.filter(w => w.id !== closedId);
        if (focusedWindow && focusedWindow.id === closedId) {
            focusedWindow = null;
            focusedWindowTitle = "Desktop";
        }
    }

    function handleCastStartedOrChanged(cast) {
        if (!cast) {
            return;
        }

        const exists = casts.some(item => item.stream_id === cast.stream_id);
        casts = exists
            ? casts.map(item => item.stream_id === cast.stream_id ? cast : item)
            : casts.concat([cast]);
    }

    function handleCastStopped(streamId) {
        casts = casts.filter(item => item.stream_id !== streamId);
    }

    function handleEvent(line) {
        const trimmed = line.trim();
        if (trimmed.length === 0) {
            return;
        }

        let evt;
        try {
            evt = JSON.parse(trimmed);
        } catch (e) {
            return;
        }

        if (evt.WorkspacesChanged) {
            handleWorkspacesChanged(evt.WorkspacesChanged.workspaces);
        } else if (evt.WorkspaceActivated) {
            handleWorkspaceActivated(evt.WorkspaceActivated.id, evt.WorkspaceActivated.focused !== false);
        } else if (evt.WorkspaceUrgencyChanged) {
            handleWorkspaceUrgencyChanged(evt.WorkspaceUrgencyChanged.id, evt.WorkspaceUrgencyChanged.urgent);
        } else if (evt.WorkspaceActiveWindowChanged) {
            handleWorkspaceActiveWindowChanged(evt.WorkspaceActiveWindowChanged.workspace_id, evt.WorkspaceActiveWindowChanged.active_window_id);
        } else if (evt.WindowsChanged) {
            handleWindowsChanged(evt.WindowsChanged.windows);
        } else if (evt.WindowFocusChanged) {
            handleWindowFocusChanged(evt.WindowFocusChanged.id);
        } else if (evt.WindowOpenedOrChanged) {
            handleWindowOpenedOrChanged(evt.WindowOpenedOrChanged.window);
        } else if (evt.WindowClosed) {
            handleWindowClosed(evt.WindowClosed.id);
        } else if (evt.KeyboardLayoutsChanged && evt.KeyboardLayoutsChanged.keyboard_layouts) {
            const kb = evt.KeyboardLayoutsChanged.keyboard_layouts;
            keyboardLayouts = kb.names || [];
            activeLayoutIndex = kb.current_idx !== undefined ? kb.current_idx : 0;
            updateLayoutLabel();
        } else if (evt.KeyboardLayoutSwitched) {
            activeLayoutIndex = evt.KeyboardLayoutSwitched.idx !== undefined ? evt.KeyboardLayoutSwitched.idx : 0;
            updateLayoutLabel();
        } else if (evt.OverviewOpenedOrClosed) {
            overviewOpen = !!evt.OverviewOpenedOrClosed.is_open;
        } else if (evt.CastsChanged) {
            casts = evt.CastsChanged.casts || [];
        } else if (evt.CastStartedOrChanged) {
            handleCastStartedOrChanged(evt.CastStartedOrChanged.cast);
        } else if (evt.CastStopped) {
            handleCastStopped(evt.CastStopped.stream_id);
        }
    }

    Process {
        id: eventStreamProc

        running: true
        command: ["niri", "msg", "-j", "event-stream"]

        stdout: SplitParser {
            onRead: line => root.handleEvent(line)
        }

        onExited: restartTimer.restart()
    }

    Timer {
        id: restartTimer

        interval: 1000
        repeat: false

        onTriggered: eventStreamProc.running = true
    }

    Component {
        id: actionProcess

        Process {
            id: proc

            onExited: proc.destroy()
        }
    }
}
