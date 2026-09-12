import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.config as Config
import qs.services as Services

Item {
    id: root

    required property ShellScreen screen

    readonly property int activeWsId: Services.Niri.activeWorkspaceId
    readonly property var workspaceIds: visibleWorkspaceIds()

    function visibleWorkspaceIds() {
        const ids = [1, 2, 3, 4];
        const workspaces = Services.Niri.workspaces;

        for (let i = 0; i < workspaces.length; i++) {
            const ws = workspaces[i];
            const num = ws.idx !== undefined ? ws.idx : ws.id;
            if (num > Config.Theme.minWorkspaceCount
             && (Services.Niri.isWorkspaceOccupied(num) || num === activeWsId)) {
                if (!ids.includes(num)) {
                    ids.push(num);
                }
            }
        }

        return ids.sort((a, b) => a - b);
    }

    function workspaceOccupied(id) {
        return Services.Niri.isWorkspaceOccupied(id);
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
