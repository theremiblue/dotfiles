import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

MouseArea {
    id: root

    property string label: ""
    property color accentColor: Config.Theme.base0D

    implicitWidth: buttonText.implicitWidth + Config.Theme.padding * 3
    implicitHeight: Math.max(Config.Theme.controlHeight, buttonText.implicitHeight + Config.Theme.padding * 1.5)
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        radius: Config.Theme.radius
        color: root.containsMouse ? Config.Theme.base01 : Config.Theme.surfaceInset
        border.color: root.containsMouse ? root.accentColor : Config.Theme.barBorder
        border.width: 1
    }

    UIPrimitives.AppText {
        id: buttonText

        anchors.centerIn: parent

        text: root.label
        color: root.containsMouse ? root.accentColor : Config.Theme.barForeground
        font.pixelSize: Config.Theme.smallFontSize
    }
}
