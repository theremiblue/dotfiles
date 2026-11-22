import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services

Item {
    id: root

    required property ShellScreen screen

    readonly property var screenWorkspaces: Services.Niri.workspacesForOutput(root.screen.name)

    function workspaceLabel(ws) {
        if (ws.name && ws.name.length > 0) {
            return ws.name;
        }

        return ws.idx.toString();
    }

    function workspaceOccupied(ws) {
        return ws.active_window_id !== null || Services.Niri.isWorkspaceOccupiedById(ws.id);
    }

    implicitWidth: workspaceLayout.implicitWidth
    implicitHeight: Config.Theme.barHeight

    RowLayout {
        id: workspaceLayout

        anchors.fill: parent
        spacing: 2

        Repeater {
            model: root.screenWorkspaces

            WorkspaceButton {
                required property var modelData

                wsIdx: modelData.idx
                wsLabel: root.workspaceLabel(modelData)
                active: !!modelData.is_active || !!modelData.is_focused
                occupied: root.workspaceOccupied(modelData)
                urgent: !!modelData.is_urgent
            }
        }
    }
}
