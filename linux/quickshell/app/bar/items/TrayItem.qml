import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    required property SystemTrayItem item

    readonly property int trayIconSize: Config.Theme.statusIconSize

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: root.trayIconSize + Config.Theme.padding * 2
    underlineColor: Config.Theme.base04

    IconImage {
        anchors.centerIn: parent

        implicitSize: root.trayIconSize
        source: root.item.icon
        asynchronous: true
        mipmap: true
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            root.item.activate();
            return;
        }

        root.item.secondaryActivate();
    }
}
