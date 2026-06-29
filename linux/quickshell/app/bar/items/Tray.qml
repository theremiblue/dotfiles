import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.ui.primitives as UIPrimitives

Item {
    id: root

    property bool expanded: false
    property real revealedWidth: root.expanded ? trayItemsRow.implicitWidth : 0
    property int mouseLeaveTimeout: 3000

    readonly property int revealSpacing: root.revealedWidth > 0 ? Config.Theme.statusIconSpacing : 0

    function isBluetoothItem(item) {
        const text = (item.id + " " + item.title + " " + item.icon).toLowerCase();
        return text.includes("bluetooth") || text.includes("blueman") || text.includes("bluez");
    }

    function visibleItems() {
        return SystemTray.items.values.filter(item => !isBluetoothItem(item));
    }

    function collapse() {
        mouseLeaveTimer.stop();
        expanded = false;
    }

    function updateMouseLeaveTimer() {
        if (!expanded) {
            mouseLeaveTimer.stop();
            return;
        }

        if (trayHover.hovered) {
            mouseLeaveTimer.stop();
            return;
        }

        mouseLeaveTimer.restart();
    }

    implicitWidth: toggleButton.implicitWidth + root.revealSpacing + root.revealedWidth
    implicitHeight: Config.Theme.barHeight
    visible: trayItems.count > 0

    onExpandedChanged: updateMouseLeaveTimer()
    onVisibleChanged: {
        if (!visible) {
            collapse();
        }
    }

    Timer {
        id: mouseLeaveTimer

        interval: root.mouseLeaveTimeout

        onTriggered: root.collapse()
    }

    Behavior on revealedWidth {
        NumberAnimation {
            duration: Config.Theme.animationDurationShort
            easing.type: Easing.OutCubic
        }
    }

    HoverHandler {
        id: trayHover

        onHoveredChanged: root.updateMouseLeaveTimer()
    }

    RowLayout {
        id: trayLayout

        anchors.fill: parent
        spacing: Config.Theme.statusIconSpacing

        UIPrimitives.IconButton {
            id: toggleButton

            iconSource: Config.Theme.tablerIcon(root.expanded ? "chevron-right" : "chevron-left")
            underlineColor: Config.Theme.base0C

            onClicked: root.expanded = !root.expanded
        }

        Item {
            id: trayItemsClip

            Layout.preferredWidth: root.revealedWidth
            Layout.minimumWidth: 0
            Layout.maximumWidth: root.revealedWidth
            implicitHeight: Config.Theme.barHeight
            clip: true
            visible: root.revealedWidth > 0
            opacity: root.expanded ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.Theme.animationDurationShort
                }
            }

            RowLayout {
                id: trayItemsRow

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: Config.Theme.statusIconSpacing

                Repeater {
                    id: trayItems

                    model: ScriptModel {
                        values: root.visibleItems()
                    }

                    TrayItem {
                        required property SystemTrayItem modelData

                        item: modelData
                    }
                }
            }
        }
    }
}
