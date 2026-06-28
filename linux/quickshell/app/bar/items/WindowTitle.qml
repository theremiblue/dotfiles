import Quickshell
import Quickshell.Hyprland
import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

MouseArea {
    id: root

    required property ShellScreen screen

    readonly property string title: {
        if (Hyprland.activeToplevel) {
            return Hyprland.activeToplevel.title
        }

        return "Desktop"
    }

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
        anchors.bottom: parent.bottom

        visible: root.containsMouse || Services.Drawers.mainVisible
        height: 2
        color: Services.Drawers.mainVisible ? Config.Theme.base0D : Config.Theme.base04
    }

    onClicked: Services.Drawers.toggleMain()
}
