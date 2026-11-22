import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.app.bar as Bar
import qs.app.bar.items as Items
import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

Item {
    id: statusBar

    required property ShellScreen screen
    required property var drawerLayer

    readonly property int position: Bar.BarConfig.position
    readonly property int implicitSize: Bar.BarConfig.size

    readonly property bool vertical: Bar.BarConfig.isVertical(position)
    readonly property bool horizontal: !vertical

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

    implicitHeight: implicitSize

    readonly property int exclusiveZone: Bar.BarConfig.reserveSpace ? implicitSize : 0
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

            Items.OverviewButton {}

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

            MouseArea {
                id: castIndicator

                visible: Services.Niri.isCasting
                implicitWidth: castRow.implicitWidth + Config.Theme.padding * 2
                implicitHeight: Config.Theme.barHeight
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                Rectangle {
                    anchors.fill: parent
                    color: castIndicator.containsMouse ? Config.Theme.barHoverBackground : "transparent"
                }

                RowLayout {
                    id: castRow

                    anchors.centerIn: parent
                    spacing: Config.Theme.spacing

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: Config.Theme.barUrgent
                    }

                    UIPrimitives.AppText {
                        text: "CAST"
                        color: Config.Theme.barUrgent
                        font.family: Config.Theme.monospaceFontFamily
                        font.pixelSize: Config.Theme.smallFontSize
                    }
                }

                onClicked: Services.Niri.clearDynamicCastTarget()
            }

            Items.Tray {}

            Items.SoundButton {
                id: soundButton

                drawerLayer: statusBar.drawerLayer
            }

            Spacer {}

            RowLayout {
                id: networkingButtonGroup

                Layout.fillHeight: true
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
    }

    Component.onCompleted: registerDrawerAnchors()
    onDrawerLayerChanged: registerDrawerAnchors()
}
