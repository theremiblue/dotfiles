import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    function bodyHeight() {
        if (!Services.Bluetooth.available) {
            return adapterUnavailableText.implicitHeight;
        }

        if (!Services.Bluetooth.enabled) {
            return bluetoothOffText.implicitHeight;
        }

        if (Services.Bluetooth.devices.length === 0 && !Services.Bluetooth.discovering) {
            return noDevicesText.implicitHeight;
        }

        return Math.min(deviceList.implicitHeight, root.maxContentHeight);
    }

    drawerType: Services.Drawers.bluetooth
    drawerSize: UIPrimitives.Drawer.Size.Small
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    borderColor: Config.Theme.bluetoothAccent

    onDrawerActivated: Services.Bluetooth.scan()
    onDrawerDeactivated: Services.Bluetooth.stopScan()

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.Icon {
                Layout.preferredWidth: Config.Theme.drawerIconSize
                Layout.preferredHeight: Config.Theme.drawerIconSize

                source: Config.Theme.tablerIcon(Services.Bluetooth.enabled ? "bluetooth-enabled" : "bluetooth-disabled")
                implicitSize: Config.Theme.drawerIconSize
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Bluetooth"
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: Services.Bluetooth.statusText()
                    color: Services.Bluetooth.enabled ? Config.Theme.barForeground : Config.Theme.barMuted
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
            }

            UIPrimitives.Switch {
                checked: Services.Bluetooth.enabled

                onToggled: checked => Services.Bluetooth.setEnabled(checked)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            Controls.UtilityButton {
                enabled: Services.Bluetooth.enabled
                opacity: enabled ? 1 : 0.45
                label: Services.Bluetooth.discovering ? "Stop" : "Scan"
                accentColor: Config.Theme.base0D

                onClicked: Services.Bluetooth.toggleScan()
            }

            UIPrimitives.AppText {
                Layout.fillWidth: true

                text: Services.Bluetooth.adapterName
                color: Config.Theme.barMuted
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.AppText {
                text: "Discoverable"
                color: Config.Theme.barForeground
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                Layout.fillWidth: true
            }

            UIPrimitives.Switch {
                checked: Services.Bluetooth.discoverable
                enabled: Services.Bluetooth.enabled
                opacity: enabled ? 1 : 0.45

                onToggled: checked => Services.Bluetooth.setDiscoverable(checked)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        Item {
            id: bluetoothBody

            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: root.bodyHeight()

            UIPrimitives.AppText {
                id: adapterUnavailableText

                anchors.centerIn: parent

                visible: !Services.Bluetooth.available
                text: "No adapter"
                color: Config.Theme.barMuted
            }

            UIPrimitives.AppText {
                id: bluetoothOffText

                anchors.centerIn: parent

                visible: Services.Bluetooth.available && !Services.Bluetooth.enabled
                text: "Bluetooth is off"
                color: Config.Theme.barMuted
            }

            UIPrimitives.AppText {
                id: noDevicesText

                anchors.centerIn: parent

                visible: Services.Bluetooth.available && Services.Bluetooth.enabled && Services.Bluetooth.devices.length === 0 && !Services.Bluetooth.discovering
                text: "No devices found"
                color: Config.Theme.barMuted
            }

            Flickable {
                anchors.fill: parent

                visible: Services.Bluetooth.enabled && Services.Bluetooth.devices.length > 0
                clip: true
                contentWidth: width
                contentHeight: deviceList.implicitHeight

                ColumnLayout {
                    id: deviceList

                    width: parent.width
                    spacing: Config.Theme.spacing

                    Repeater {
                        model: ScriptModel {
                            values: Services.Bluetooth.devices
                        }

                        Rectangle {
                            id: deviceRow

                            required property var modelData

                            property var device: modelData
                            readonly property bool active: device.connected || device.pairing

                            Layout.fillWidth: true
                            implicitHeight: deviceContent.implicitHeight + Config.Theme.padding * 3
                            radius: 6
                            color: active ? Config.Theme.base02 : Config.Theme.base00
                            border.color: device.connected ? Config.Theme.base0D : Config.Theme.barBorder
                            border.width: 1

                            ColumnLayout {
                                id: deviceContent

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: Config.Theme.padding * 1.5
                                spacing: Config.Theme.spacing

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: Config.Theme.spacing

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 1

                                        UIPrimitives.AppText {
                                            Layout.fillWidth: true

                                            text: Services.Bluetooth.deviceName(deviceRow.device)
                                            color: Config.Theme.barForeground
                                            horizontalAlignment: Text.AlignLeft
                                            elide: Text.ElideRight
                                        }

                                        UIPrimitives.AppText {
                                            Layout.fillWidth: true

                                            text: Services.Bluetooth.deviceStateText(deviceRow.device)
                                            color: deviceRow.device.connected ? Config.Theme.base0D : Config.Theme.barMuted
                                            font.pixelSize: Config.Theme.smallFontSize
                                            horizontalAlignment: Text.AlignLeft
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Controls.UtilityButton {
                                        label: Services.Bluetooth.deviceActionLabel(deviceRow.device)
                                        accentColor: deviceRow.device.connected ? Config.Theme.base08 : Config.Theme.base0D
                                        enabled: Services.Bluetooth.enabled && !deviceRow.device.pairing
                                        opacity: enabled ? 1 : 0.45

                                        onClicked: Services.Bluetooth.toggleDevice(deviceRow.device)
                                    }
                                }

                                UIPrimitives.AppText {
                                    Layout.fillWidth: true

                                    visible: Services.Bluetooth.deviceDetailText(deviceRow.device).length > 0
                                    text: Services.Bluetooth.deviceDetailText(deviceRow.device)
                                    color: Config.Theme.barMuted
                                    font.pixelSize: Config.Theme.smallFontSize
                                    horizontalAlignment: Text.AlignLeft
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
