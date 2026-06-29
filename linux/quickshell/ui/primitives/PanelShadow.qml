import QtQuick

import qs.config as Config

Item {
    id: root

    property real sourceWidth: 0
    property real sourceHeight: 0
    property real sourceRadius: 0
    readonly property int margin: Config.Theme.panelShadowSize

    function shadowColor(opacity) {
        return Qt.rgba(Config.Theme.panelShadowColor.r, Config.Theme.panelShadowColor.g, Config.Theme.panelShadowColor.b, opacity);
    }

    width: sourceWidth + margin * 2
    height: sourceHeight + margin * 2

    Rectangle {
        anchors.centerIn: parent

        width: root.sourceWidth + root.margin * 2
        height: root.sourceHeight + root.margin * 2
        radius: root.sourceRadius + root.margin
        color: root.shadowColor(Config.Theme.panelShadowOuterOpacity)
    }

    Rectangle {
        anchors.centerIn: parent

        width: root.sourceWidth + root.margin
        height: root.sourceHeight + root.margin
        radius: root.sourceRadius + root.margin / 2
        color: root.shadowColor(Config.Theme.panelShadowMiddleOpacity)
    }

    Rectangle {
        anchors.centerIn: parent

        width: root.sourceWidth + Config.Theme.padding * 2
        height: root.sourceHeight + Config.Theme.padding * 2
        radius: root.sourceRadius + Config.Theme.padding
        color: root.shadowColor(Config.Theme.panelShadowInnerOpacity)
    }
}
