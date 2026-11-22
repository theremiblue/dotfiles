import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

MouseArea {
    id: root

    property url iconSource: ""
    property string label: ""
    property color accentColor: Config.Theme.barAccent
    property color backgroundColor: Config.Theme.surfaceInset
    property color hoverBackgroundColor: Config.Theme.base01

    signal triggered

    implicitWidth: Math.max(Math.round(Config.Theme.fontSize * 7), contentColumn.implicitWidth + Config.Theme.padding * 4)
    implicitHeight: contentColumn.implicitHeight + Config.Theme.padding * 5
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        color: root.containsMouse ? root.hoverBackgroundColor : root.backgroundColor
        border.color: root.containsMouse ? root.accentColor : Config.Theme.hairlineSubtle
        border.width: 1
        radius: Config.Theme.radius

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
