import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    function locationText() {
        const parts = [];

        if (Services.Vpn.city.length > 0) {
            parts.push(Services.Vpn.city);
        }

        if (Services.Vpn.country.length > 0) {
            parts.push(Services.Vpn.country);
        }

        return parts.join(", ");
    }

    drawerType: Services.Drawers.vpn
    drawerSize: UIPrimitives.Drawer.Size.Small
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    borderColor: Config.Theme.barBorder

    onDrawerActivated: Services.Vpn.refresh()

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.Icon {
                Layout.preferredWidth: Config.Theme.drawerIconSize
                Layout.preferredHeight: Config.Theme.drawerIconSize

                source: Config.Theme.tablerIcon(Services.Vpn.connected ? "vpn-connected" : "vpn-disconnected")
                implicitSize: Config.Theme.drawerIconSize
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: Services.Vpn.providerName
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: Services.Vpn.busy ? "Updating" : Services.Vpn.status
                    color: Services.Vpn.connected ? Config.Theme.base0B : Config.Theme.barMuted
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.AppText {
                text: "Connected"
                color: Config.Theme.barForeground
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                Layout.fillWidth: true
            }

            UIPrimitives.Switch {
                checked: Services.Vpn.connected
                enabled: Services.Vpn.available && !Services.Vpn.busy
                opacity: enabled ? 1 : 0.45

                onToggled: checked => Services.Vpn.setConnected(checked)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            Controls.DetailRow {
                name: "Server"
                value: Services.Vpn.hostname
            }

            Controls.DetailRow {
                name: "Last"
                value: Services.Vpn.lastServer
            }

            Controls.DetailRow {
                name: "Location"
                value: root.locationText()
            }

            UIPrimitives.CopyableField {
                name: "IP"
                value: Services.Vpn.ip
            }

            Controls.DetailRow {
                name: "Tech"
                value: Services.Vpn.technology
            }

            Controls.DetailRow {
                visible: Services.Vpn.error.length > 0
                name: "Error"
                value: Services.Vpn.error
            }
        }
    }
}
