import QtQuick

import qs.config as Config

MouseArea {
    id: root

    property bool checked: false
    signal toggled(bool checked)

    implicitWidth: Config.Theme.switchWidth
    implicitHeight: Config.Theme.switchHeight
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        radius: height / 2
        color: root.checked ? Config.Theme.base0D : Config.Theme.base02
        border.color: root.checked ? Config.Theme.base0D : Config.Theme.barBorder
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animationDurationShort
            }
        }
    }

    Rectangle {
        width: root.height - 4
        height: root.height - 4
        radius: height / 2
        x: root.checked ? root.width - width - 2 : 2
        anchors.verticalCenter: parent.verticalCenter
        color: Config.Theme.base07

        Behavior on x {
            NumberAnimation {
                duration: Config.Theme.animationDurationShort
                easing.type: Easing.OutCubic
            }
        }
    }

    onClicked: root.toggled(!root.checked)
}
