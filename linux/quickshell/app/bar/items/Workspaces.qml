import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.config as Config

Item {
    id: root

    required property ShellScreen screen

    readonly property int activeWsId: currentWorkspaceId()
    readonly property var workspaceIds: visibleWorkspaceIds()

    function currentWorkspaceId() {
        const monitor = Hyprland.monitorFor(screen);

        if (monitor && monitor.activeWorkspace) {
            return monitor.activeWorkspace.id;
        }

        if (Hyprland.focusedWorkspace) {
            return Hyprland.focusedWorkspace.id;
        }

        return 1;
    }

    function visibleWorkspaceIds() {
        const ids = [1, 2, 3, 4];
        const workspaces = Hyprland.workspaces.values;

        for (const workspace of workspaces) {
            if (workspace.id > Config.Theme.minWorkspaceCount
             && (workspaceWindowCount(workspace) > 0 || workspace.id === activeWsId)) {
                ids.push(workspace.id);
            }
        }

        return ids.sort((a, b) => a - b);
    }

    function workspaceWindowCount(workspace) {
        if (workspace.lastIpcObject && workspace.lastIpcObject.windows) {
            return workspace.lastIpcObject.windows;
        }

        return 0;
    }

    function workspaceOccupied(id) {
        const workspaces = Hyprland.workspaces.values;

        for (const workspace of workspaces) {
            if (workspace.id === id) {
                return workspaceWindowCount(workspace) > 0;
            }
        }

        return false;
    }

    implicitWidth: workspaceLayout.implicitWidth
    implicitHeight: Config.Theme.barHeight

    RowLayout {
        id: workspaceLayout

        anchors.fill: parent
        spacing: 2

        Repeater {
            model: root.workspaceIds

            WorkspaceButton {
                required property int modelData

                wsId: modelData
                activeWsId: root.activeWsId
                occupied: root.workspaceOccupied(modelData)
            }
        }
    }
}
