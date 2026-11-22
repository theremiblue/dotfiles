import Quickshell
import QtQuick

import qs.app.bar as Bar

PanelWindow {
    id: root

    required property ShellScreen targetScreen
    required property var drawerLayer

    property alias bar: statusBar

    screen: targetScreen

    anchors {
        left: true
        right: true
        top: true
    }

    implicitHeight: statusBar.implicitHeight
    exclusiveZone: statusBar.exclusiveZone
    aboveWindows: true
    focusable: false
    color: "transparent"

    mask: Region {
        x: 0
        y: 0
        width: root.width
        height: statusBar.implicitSize
    }

    Bar.Bar {
        id: statusBar

        anchors.fill: parent
        screen: root.screen
        drawerLayer: root.drawerLayer
    }
}
