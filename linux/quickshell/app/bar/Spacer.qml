import QtQuick

import qs.config as Config

Item {
    property int size: Config.Theme.spacing * 2 + 1

    implicitWidth: size
    implicitHeight: Config.Theme.barHeight

    Rectangle {
        anchors.centerIn: parent

        width: 1
        height: Math.round(Config.Theme.barHeight * 0.45)
        color: Config.Theme.barBorder
    }
}
