import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

MouseArea {
    id: root

    property url iconSource: ""
    property string label: ""
    property color accentColor: Config.Theme.barAccent
    property color backgroundColor: Config.Theme.base00
    property color hoverBackgroundColor: Config.Theme.base02

    signal triggered

    implicitWidth: Math.max(Math.round(Config.Theme.fontSize * 6), contentColumn.implicitWidth + Config.Theme.padding * 4)
    implicitHeight: contentColumn.implicitHeight + Config.Theme.padding * 4
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        color: root.containsMouse ? root.hoverBackgroundColor : root.backgroundColor
        border.color: root.containsMouse ? root.accentColor : Config.Theme.barBorder
        border.width: 1
        radius: 6

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animationDurationShort
            }
        }
    }

    Column {
        id: contentColumn

        anchors.centerIn: parent
        spacing: Config.Theme.spacing

        UIPrimitives.Icon {
            anchors.horizontalCenter: parent.horizontalCenter

            source: root.iconSource
            implicitSize: Config.Theme.drawerIconSize
        }

        UIPrimitives.AppText {
            anchors.horizontalCenter: parent.horizontalCenter

            text: root.label
            color: Config.Theme.barForeground
            font.pixelSize: Config.Theme.smallFontSize
        }
    }

    onClicked: root.triggered()
}
