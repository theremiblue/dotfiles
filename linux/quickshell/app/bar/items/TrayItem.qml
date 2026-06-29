import Quickshell.Services.SystemTray
import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    required property SystemTrayItem item

    readonly property int trayIconSize: Config.Theme.statusIconSize
    readonly property int trayIconSourceSize: Math.max(64, trayIconSize * 4)
    readonly property string appIconSource: Services.Lantern.appIconSourceForHints([
        root.item.id,
        root.item.title,
        root.item.tooltipTitle
    ])

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: root.trayIconSize + Config.Theme.padding * 2
    underlineColor: Config.Theme.base04

    UIPrimitives.AppIcon {
        anchors.centerIn: parent

        iconSize: root.trayIconSize
        sourceSize: root.trayIconSourceSize
        source: root.appIconSource.length > 0 ? root.appIconSource : root.item.icon
        sourceMode: root.appIconSource.length > 0 ? UIPrimitives.AppIcon.ImageSource : UIPrimitives.AppIcon.TraySource
        label: root.item.title.length > 0 ? root.item.title : root.item.id
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            root.item.activate();
            return;
        }

        root.item.secondaryActivate();
    }
}
