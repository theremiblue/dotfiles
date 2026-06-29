import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

MouseArea {
    id: root

    required property var drawerLayer

    readonly property color highlightColor: Qt.rgba(0.09, 0.58, 0.82, 0.85)
    readonly property bool hovered: containsMouse

    function toggleDrawer() {
        drawerLayer.toggle(Services.Drawers.power, root);
    }

    implicitWidth: Config.Theme.barHeight + Config.Theme.padding
    implicitHeight: Config.Theme.barHeight
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    UIPrimitives.Icon {
        id: icon

        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.containsMouse ? -1 : 0

        source: Config.Theme.archIcon
        implicitSize: Config.Theme.statusIconSize

        Behavior on anchors.verticalCenterOffset {
            NumberAnimation {
                duration: Config.Theme.animationDurationLong
            }
        }
    }

    onClicked: toggleDrawer()
}
