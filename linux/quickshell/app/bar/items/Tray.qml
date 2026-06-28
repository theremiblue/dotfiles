import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.config as Config

Item {
    id: root

    function isBluetoothItem(item) {
        const text = (item.id + " " + item.title + " " + item.icon).toLowerCase();
        return text.includes("bluetooth") || text.includes("blueman") || text.includes("bluez");
    }

    function visibleItems() {
        return SystemTray.items.values.filter(item => !isBluetoothItem(item));
    }

    implicitWidth: trayLayout.implicitWidth
    implicitHeight: Config.Theme.barHeight
    visible: trayItems.count > 0

    RowLayout {
        id: trayLayout

        anchors.fill: parent
        spacing: Config.Theme.statusIconSpacing

        Repeater {
            id: trayItems

            model: ScriptModel {
                values: root.visibleItems()
            }

            TrayItem {
                required property SystemTrayItem modelData

                item: modelData
            }
        }
    }
}
