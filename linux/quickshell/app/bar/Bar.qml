import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.app.bar as Bar
import qs.app.bar.items as Items
import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls

Item {
    id: statusBar

    required property ShellScreen screen
    required property var drawerLayer

    readonly property int position: Bar.BarConfig.position
    readonly property int implicitSize: Bar.BarConfig.size
    readonly property int archHoverGlowHeight: 28

    readonly property bool vertical: Bar.BarConfig.isVertical(position)
    readonly property bool horizontal: !vertical

    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function registerDrawerAnchors() {
        if (!drawerLayer) {
            return;
        }

        drawerLayer.setAnchor(Services.Drawers.power, archIcon);
        drawerLayer.setAnchor(Services.Drawers.main, windowTitle);
        drawerLayer.setAnchor(Services.Drawers.sound, soundButton);
        drawerLayer.setAnchor(Services.Drawers.wifi, wifiButton);
        drawerLayer.setAnchor(Services.Drawers.bluetooth, bluetoothButton);
        drawerLayer.setAnchor(Services.Drawers.network, networkButton);
        drawerLayer.setAnchor(Services.Drawers.vpn, vpnButton);
        drawerLayer.setAnchor(Services.Drawers.notifications, notificationButton);
    }

    implicitHeight: implicitSize + archHoverGlowHeight

    readonly property int exclusiveZone: Bar.BarConfig.reserveSpace ? implicitSize : 0

    // Backwards-compatible name for code that still reads reservedSize.
    readonly property int reservedSize: exclusiveZone

    Rectangle {
        id: barSurface

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: statusBar.implicitSize
        color: Config.Theme.barBackground

        onWidthChanged: Qt.callLater(statusBar.registerDrawerAnchors)

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 1
            color: Config.Theme.barBorder
        }

        RowLayout {
            id: leftGroup

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: Config.Theme.spacing

            onWidthChanged: Qt.callLater(statusBar.registerDrawerAnchors)

            Item {
                implicitWidth: Config.Theme.padding
            }

            Items.ArchButton {
                id: archIcon

                drawerLayer: statusBar.drawerLayer
            }

            Spacer {}

            Items.Workspaces {
                screen: statusBar.screen
            }
        }

        Items.WindowTitle {
            id: windowTitle

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.max(0, parent.width - Math.max(leftGroup.implicitWidth, rightGroup.implicitWidth) * 2 - Config.Theme.spacing * 2)
            screen: statusBar.screen
            drawerLayer: statusBar.drawerLayer
        }

        RowLayout {
            id: rightGroup

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: Config.Theme.spacing

            onWidthChanged: Qt.callLater(statusBar.registerDrawerAnchors)

            Items.Tray {}

            Items.SoundButton {
                id: soundButton

                drawerLayer: statusBar.drawerLayer
            }

            Spacer {}

            Controls.ButtonGroup {
                id: networkingButtonGroup

                spacing: Config.Theme.statusIconSpacing

                Items.WifiButton {
                    id: wifiButton

                    drawerLayer: statusBar.drawerLayer
                }

                Items.BluetoothButton {
                    id: bluetoothButton

                    drawerLayer: statusBar.drawerLayer
                }

                Items.NetworkButton {
                    id: networkButton

                    drawerLayer: statusBar.drawerLayer
                }

                Items.VpnButton {
                    id: vpnButton

                    drawerLayer: statusBar.drawerLayer
                }
            }

            Spacer {}

            Items.Clock {}

            Items.KeyboardLayoutButton {}

            Items.IdleInhibitorButton {}

            Items.NotificationButton {
                id: notificationButton

                drawerLayer: statusBar.drawerLayer
            }

            Item {
                implicitWidth: Config.Theme.padding
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 2
            opacity: archIcon.hovered ? 1 : 0
            color: archIcon.highlightColor

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.Theme.animationDurationLong
                }
            }
        }
    }

    Component.onCompleted: registerDrawerAnchors()
    onDrawerLayerChanged: registerDrawerAnchors()

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: barSurface.bottom

        height: statusBar.archHoverGlowHeight
        clip: true
        opacity: archIcon.hovered ? 1 : 0

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            height: archIcon.hovered ? parent.height : 0
            gradient: Gradient {
                orientation: Gradient.Vertical

                GradientStop {
                    position: 0
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0.42)
                }

                GradientStop {
                    position: 0.65
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0.12)
                }

                GradientStop {
                    position: 1
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0)
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: Config.Theme.animationDurationNormal
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Config.Theme.animationDurationNormal
                easing.type: Easing.OutCubic
            }
        }
    }
}
