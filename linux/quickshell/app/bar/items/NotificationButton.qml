import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    readonly property int notificationCount: Services.Notifications.count
    readonly property bool active: Services.Drawers.isActive(Services.Drawers.notifications)

    iconSource: Config.Theme.tablerIcon(active || notificationCount > 0 ? "notifications-active" : "notifications")
    alternateIconSource: iconSource
    iconSize: Config.Theme.statusIconSize
    underlineVisible: containsMouse || active
    underlineColor: active ? Config.Theme.base0D : Config.Theme.base04

    Timer {
        id: clickTimer

        interval: 220
        repeat: false

        onTriggered: root.drawerLayer.toggle(Services.Drawers.notifications, root)
    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 1

        visible: root.notificationCount > 0
        width: Math.max(10, countText.implicitWidth + 4)
        height: 10
        radius: height / 2
        color: Config.Theme.base08

        UIPrimitives.AppText {
            id: countText

            anchors.centerIn: parent

            text: root.notificationCount > 9 ? "9+" : root.notificationCount.toString()
            color: Config.Theme.base07
            font.pixelSize: 7
        }
    }

    onClicked: clickTimer.restart()

    onDoubleClicked: event => {
        event.accepted = true;
        clickTimer.stop();
        Services.Notifications.clearAll();
    }
}
