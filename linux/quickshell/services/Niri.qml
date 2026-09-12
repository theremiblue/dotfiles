pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root

    property var workspaces: []
    property int activeWorkspaceId: 1
    property var windows: []
    property var focusedWindow: null
    property string focusedWindowTitle: "Desktop"
    property var keyboardLayouts: []
    property int activeLayoutIndex: 0
    property string activeLayoutName: ""
    property string layoutLabel: "??"

    function compactLabel(value) {
        const text = String(value || "").trim();
        if (text.length === 0) return "??";
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

    function isWorkspaceOccupied(wsNum) {
        let wsId = null;
        for (let i = 0; i < workspaces.length; i++) {
            const ws = workspaces[i];
            const num = parseInt(ws.name) || ws.idx || ws.id;
            if (num === wsNum) {
                wsId = ws.id;
                break;
            }
        }
        if (wsId === null) return false;
        for (let i = 0; i < windows.length; i++) {
            if (windows[i].workspace_id === wsId) {
                return true;
            }
        }
        return false;
    }

    function focusWorkspace(wsNum) {
        runAction(["focus-workspace", wsNum.toString()]);
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

    function handleEvent(line) {
        const trimmed = line.trim();
        if (trimmed.length === 0) return;

        try {
            const evt = JSON.parse(trimmed);

            if (evt.WorkspacesChanged) {
                workspaces = evt.WorkspacesChanged.workspaces || [];
                for (let i = 0; i < workspaces.length; i++) {
                    const ws = workspaces[i];
                    if (ws.is_active || ws.is_focused) {
                        activeWorkspaceId = parseInt(ws.name) || ws.idx || ws.id;
                        break;
                    }
                }
            } else if (evt.WorkspaceActivated) {
                const id = evt.WorkspaceActivated.id;
                for (let i = 0; i < workspaces.length; i++) {
                    const ws = workspaces[i];
                    if (ws.id === id) {
                        activeWorkspaceId = parseInt(ws.name) || ws.idx || ws.id;
                        break;
                    }
                }
            } else if (evt.WindowsChanged) {
                windows = evt.WindowsChanged.windows || [];
                let foundFocus = false;
                for (let i = 0; i < windows.length; i++) {
                    const w = windows[i];
                    if (w.is_focused) {
                        focusedWindow = w;
                        focusedWindowTitle = w.title || "Desktop";
                        foundFocus = true;
                        break;
                    }
                }
                if (!foundFocus && windows.length === 0) {
                    focusedWindow = null;
                    focusedWindowTitle = "Desktop";
                }
            } else if (evt.WindowFocusChanged) {
                const id = evt.WindowFocusChanged.id;
                if (id === null || id === undefined) {
                    focusedWindow = null;
                    focusedWindowTitle = "Desktop";
                } else {
                    for (let i = 0; i < windows.length; i++) {
                        const w = windows[i];
                        if (w.id === id) {
                            focusedWindow = w;
                            focusedWindowTitle = w.title || "Desktop";
                            break;
                        }
                    }
                }
            } else if (evt.WindowOpenedOrChanged) {
                const win = evt.WindowOpenedOrChanged.window;
                if (win) {
                    let found = false;
                    const newWins = [];
                    for (let i = 0; i < windows.length; i++) {
                        if (windows[i].id === win.id) {
                            newWins.push(win);
                            found = true;
                        } else {
                            newWins.push(windows[i]);
                        }
                    }
                    if (!found) newWins.push(win);
                    windows = newWins;

                    if (win.is_focused) {
                        focusedWindow = win;
                        focusedWindowTitle = win.title || "Desktop";
                    }
                }
            } else if (evt.WindowClosed) {
                const closedId = evt.WindowClosed.id;
                windows = windows.filter(w => w.id !== closedId);
                if (focusedWindow && focusedWindow.id === closedId) {
                    focusedWindow = null;
                    focusedWindowTitle = "Desktop";
                }
            } else if (evt.KeyboardLayoutsChanged) {
                const kb = evt.KeyboardLayoutsChanged.keyboard_layouts;
                if (kb) {
                    keyboardLayouts = kb.names || [];
                    activeLayoutIndex = kb.current_idx !== undefined ? kb.current_idx : 0;
                    updateLayoutLabel();
                }
            } else if (evt.KeyboardLayoutSwitched) {
                activeLayoutIndex = evt.KeyboardLayoutSwitched.idx !== undefined ? evt.KeyboardLayoutSwitched.idx : 0;
                updateLayoutLabel();
            }
        } catch (e) {
            // Ignore parse errors on partial lines
        }
    }

    Process {
        id: eventStreamProc

        running: true
        command: ["niri", "msg", "-j", "event-stream"]

        stdout: SplitParser {
            onRead: line => root.handleEvent(line)
        }

        onExited: {
            restartTimer.restart();
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        repeat: false
        onTriggered: {
            eventStreamProc.running = true;
        }
    }

    Component {
        id: actionProcess

        Process {
            id: proc
            onExited: proc.destroy()
        }
    }
}
