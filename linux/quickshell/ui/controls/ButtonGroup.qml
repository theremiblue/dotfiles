import QtQuick
import QtQuick.Layouts

import qs.config as Config

Item {
    id: root

    default property alias content: contentRow.data

    property int horizontalPadding: 1
    property int verticalMargin: 2
    property int spacing: Config.Theme.statusIconSpacing
    property color borderColor: Config.Theme.barBorder
    property color hoverBorderColor: Config.Theme.base03
    readonly property color currentBorderColor: groupHover.hovered ? hoverBorderColor : borderColor

    implicitWidth: contentRow.implicitWidth + horizontalPadding * 2
    implicitHeight: Config.Theme.barHeight

    RowLayout {
        id: contentRow

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.horizontalPadding
        height: parent.height
        spacing: root.spacing
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: root.verticalMargin
        anchors.bottomMargin: root.verticalMargin

        width: 1
        z: 1
        color: root.currentBorderColor

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animationDurationShort
            }
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: root.verticalMargin
        anchors.bottomMargin: root.verticalMargin

        width: 1
        z: 1
        color: root.currentBorderColor

        Behavior on color {
            ColorAnimation {
                duration: Config.Theme.animationDurationShort
            }
        }
    }

    HoverHandler {
        id: groupHover
    }
}
