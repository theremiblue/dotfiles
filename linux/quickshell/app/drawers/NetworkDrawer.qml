import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    function valueOrFallback(value) {
        if (value && value.length > 0 && value !== "--") {
            return value;
        }

        return "Unavailable";
    }

    function statusText() {
        if (!Services.Network.ethernetConnected) {
            return "Disconnected";
        }

        return valueOrFallback(Services.Network.ethernetState);
    }

    function linkText() {
        const parts = [];

        if (Services.Network.ethernetSpeed && Services.Network.ethernetSpeed.length > 0) {
            parts.push(Services.Network.ethernetSpeed);
        }

        if (Services.Network.ethernetMtu && Services.Network.ethernetMtu.length > 0) {
            parts.push("MTU " + Services.Network.ethernetMtu);
        }

        return valueOrFallback(parts.join(" / "));
    }

    drawerSize: UIPrimitives.Drawer.Size.Small
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    anchorCenterX: Services.Drawers.anchorCenterX
    borderColor: Services.Network.ethernetConnected ? Config.Theme.base0B : Config.Theme.base08

    Component.onCompleted: {
        if (Services.Drawers.networkVisible) {
            Services.Network.refresh();
            root.open();
        }
    }

    onDismissed: Services.Drawers.hideNetwork()

    Connections {
        target: Services.Drawers

        function onNetworkVisibleChanged() {
            if (Services.Drawers.networkVisible) {
                Services.Network.refresh();
                root.open();
                return;
            }

            root.close();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.Icon {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26

                source: Services.Network.ethernetConnected ? Config.Theme.tablerIcon("network-popout-connected") : Config.Theme.tablerIcon("network-popout-disconnected")
                implicitSize: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Cable"
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: root.statusText()
                    color: Services.Network.ethernetConnected ? Config.Theme.base0B : Config.Theme.barMuted
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

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Controls.DetailRow {
                name: "Interface"
                value: Services.Network.ethernetInterface
            }

            Controls.DetailRow {
                name: "Profile"
                value: Services.Network.ethernetConnection
            }

            UIPrimitives.CopyableField {
                name: "IPv4"
                value: Services.Network.ethernetAddress
            }

            UIPrimitives.CopyableField {
                name: "Gateway"
                value: Services.Network.ethernetGateway
            }

            UIPrimitives.CopyableField {
                name: "DNS"
                value: Services.Network.ethernetDns
            }

            Controls.DetailRow {
                name: "Link"
                value: root.linkText()
            }

            UIPrimitives.CopyableField {
                name: "MAC"
                value: Services.Network.ethernetMac
            }
        }
    }
}
