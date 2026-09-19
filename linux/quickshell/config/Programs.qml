pragma Singleton

import QtQml

QtObject {
    readonly property string vpnProviderName: "NordVPN"
    readonly property var vpnCliCommand: ["nordvpn"]
    readonly property var vpnApplicationCommand: ["nordvpn-gui"]
    readonly property var bluetoothApplicationCommand: ["blueman-manager"]
}
