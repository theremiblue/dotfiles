import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    function statusText() {
        if (!Services.Network.wifiEnabled) {
            return "Off";
        }

        if (Services.Network.wifiConnected) {
            return Services.Network.wifiConnection;
        }

        return "Not connected";
    }

    function securityText(network) {
        if (!isSecured(network)) {
            return "Open";
        }

        return network.security;
    }

    function isSecured(network) {
        return network.security && network.security.length > 0 && network.security !== "--";
    }

    function connectLabel(network, expanded) {
        if (Services.Network.wifiConnectingSsid === network.ssid) {
            return "Connecting";
        }

        if (network.inUse) {
            return "Connected";
        }

        if (isSecured(network) && !expanded) {
            return "Password";
        }

        return "Connect";
    }

    function connectOrExpand(network, delegate) {
        if (network.inUse || Services.Network.wifiConnectingSsid.length > 0) {
            return;
        }

        if (isSecured(network) && !delegate.expanded) {
            delegate.expanded = true;
            return;
        }

        Services.Network.connectWifi(network.ssid, delegate.password);
    }

    drawerType: Services.Drawers.wifi
    drawerSize: UIPrimitives.Drawer.Size.Small
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    borderColor: Config.Theme.barBorder

    onDrawerActivated: {
        Services.Network.refresh();
        Services.Network.scanWifi();
    }

    Connections {
        target: Services.Network

        function onWifiEnabledChanged() {
            if (root.drawerActive && Services.Network.wifiEnabled) {
                Services.Network.scanWifi();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.Icon {
                Layout.preferredWidth: Config.Theme.drawerIconSize
                Layout.preferredHeight: Config.Theme.drawerIconSize

                source: Config.Theme.tablerIcon(Services.Network.wifiEnabled ? "wifi-enabled" : "wifi-disabled")
                implicitSize: Config.Theme.drawerIconSize
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Wi-Fi"
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: root.statusText()
                    color: Services.Network.wifiEnabled ? Config.Theme.barForeground : Config.Theme.barMuted
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
            }

            UIPrimitives.Switch {
                checked: Services.Network.wifiEnabled

                onToggled: checked => Services.Network.setWifiEnabled(checked)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            Controls.UtilityButton {
                label: Services.Network.wifiScanning ? "Scanning" : "Scan"
                accentColor: Config.Theme.base0D

                onClicked: Services.Network.scanWifi()
            }

            Controls.UtilityButton {
                visible: Services.Network.wifiConnected
                label: "Disconnect"
                accentColor: Config.Theme.base08

                onClicked: Services.Network.disconnectWifi()
            }

        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        UIPrimitives.AppText {
            Layout.fillWidth: true

            visible: Services.Network.wifiError.length > 0
            text: Services.Network.wifiError
            color: Config.Theme.base08
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
        }

        Item {
            id: networkBody

            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: {
                if (!Services.Network.wifiEnabled) {
                    return wifiOffText.implicitHeight;
                }

                if (Services.Network.wifiNetworks.length === 0 && !Services.Network.wifiScanning) {
                    return noNetworksText.implicitHeight;
                }

                return Math.min(networkList.implicitHeight, root.maxContentHeight);
            }

            UIPrimitives.AppText {
                id: wifiOffText

                anchors.centerIn: parent

                visible: !Services.Network.wifiEnabled
                text: "Wi-Fi is off"
                color: Config.Theme.barMuted
            }

            UIPrimitives.AppText {
                id: noNetworksText

                anchors.centerIn: parent

                visible: Services.Network.wifiEnabled && Services.Network.wifiNetworks.length === 0 && !Services.Network.wifiScanning
                text: "No networks found"
                color: Config.Theme.barMuted
            }

            Flickable {
                anchors.fill: parent

                visible: Services.Network.wifiEnabled && Services.Network.wifiNetworks.length > 0
                clip: true
                contentWidth: width
                contentHeight: networkList.implicitHeight

                ColumnLayout {
                    id: networkList

                    width: parent.width
                    spacing: Config.Theme.spacing

                    Repeater {
                        model: ScriptModel {
                            values: Services.Network.wifiNetworks
                        }

                        Rectangle {
                            id: networkRow

                            required property var modelData

                            property var network: modelData
                            property bool expanded: false
                            property string password: ""

                            Layout.fillWidth: true
                            implicitHeight: networkContent.implicitHeight + Config.Theme.padding * 3
                            radius: Config.Theme.radius
                            color: network.inUse ? Config.Theme.base01 : Config.Theme.surfaceInset
                            border.color: network.inUse ? Config.Theme.base0D : Config.Theme.hairlineSubtle
                            border.width: 1

                            ColumnLayout {
                                id: networkContent

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

                                            text: networkRow.network.ssid
                                            color: Config.Theme.barForeground
                                            horizontalAlignment: Text.AlignLeft
                                            elide: Text.ElideRight
                                        }

                                        UIPrimitives.AppText {
                                            Layout.fillWidth: true

                                            text: root.securityText(networkRow.network) + " / " + networkRow.network.signal + "%"
                                            color: networkRow.network.inUse ? Config.Theme.base0D : Config.Theme.barMuted
                                            font.pixelSize: Config.Theme.smallFontSize
                                            horizontalAlignment: Text.AlignLeft
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Rectangle {
                                        Layout.preferredWidth: Math.round(Config.Theme.fontSize * 2.5)
                                        Layout.preferredHeight: Math.max(6, Math.round(Config.Theme.spacing * 0.75))

                                        radius: height / 2
                                        color: Config.Theme.base02
                                        clip: true

                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.bottom: parent.bottom

                                            width: parent.width * Math.max(0, Math.min(100, networkRow.network.signal)) / 100
                                            color: networkRow.network.signal >= 65 ? Config.Theme.base0B : networkRow.network.signal >= 35 ? Config.Theme.base0A : Config.Theme.base08
                                        }
                                    }

                                    Controls.UtilityButton {
                                        visible: !networkRow.network.inUse
                                        label: root.connectLabel(networkRow.network, networkRow.expanded)
                                        accentColor: Config.Theme.base0D

                                        onClicked: root.connectOrExpand(networkRow.network, networkRow)
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: networkRow.expanded ? Math.max(Config.Theme.controlHeight, passwordInput.implicitHeight + Config.Theme.padding * 2) : 0

                                    visible: networkRow.expanded
                                    radius: Config.Theme.radius
                                    color: Config.Theme.base00
                                    border.color: Config.Theme.barBorder
                                    border.width: 1

                                    TextInput {
                                        id: passwordInput
                                        anchors.fill: parent
                                        anchors.leftMargin: Config.Theme.padding * 2
                                        anchors.rightMargin: Config.Theme.padding * 2

                                        color: Config.Theme.barForeground
                                        selectedTextColor: Config.Theme.base00
                                        selectionColor: Config.Theme.base0D
                                        font.family: Config.Theme.fontFamily
                                        font.pixelSize: Config.Theme.fontSize
                                        echoMode: TextInput.Password
                                        verticalAlignment: TextInput.AlignVCenter
                                        clip: true
                                        focus: networkRow.expanded
                                        text: networkRow.password

                                        onTextChanged: networkRow.password = text
                                        onAccepted: Services.Network.connectWifi(networkRow.network.ssid, text)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
