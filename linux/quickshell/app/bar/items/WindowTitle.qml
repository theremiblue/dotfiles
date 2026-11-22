import Quickshell
import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

MouseArea {
    id: root

    required property ShellScreen screen
    required property var drawerLayer

    readonly property string title: Services.Niri.focusedWindowTitle || "Desktop"

    implicitHeight: Config.Theme.barHeight
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        color: root.containsMouse ? Config.Theme.barHoverBackground : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animationDurationShort
            }
        }
    }

    UIPrimitives.AppText {
        anchors.fill: parent
        anchors.leftMargin: Config.Theme.padding
        anchors.rightMargin: Config.Theme.padding

        text: root.title
        elide: Text.ElideRight
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Config.Theme.padding * 2
        anchors.rightMargin: Config.Theme.padding * 2
        anchors.bottom: parent.bottom

        visible: root.containsMouse || Services.Drawers.isActive(Services.Drawers.main)
        height: 2
        color: Services.Drawers.isActive(Services.Drawers.main) ? Config.Theme.base0D : Config.Theme.base04
    }

    onClicked: drawerLayer.toggle(Services.Drawers.main, root)
}
