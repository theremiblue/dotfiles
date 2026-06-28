import Quickshell
import QtQuick

import qs.app.bar as Bar

PanelWindow {
    id: root

    required property ShellScreen targetScreen

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
    focusable: true
    color: "transparent"

    Bar.Bar {
        id: statusBar

        anchors.fill: parent
        screen: root.screen
    }
}
