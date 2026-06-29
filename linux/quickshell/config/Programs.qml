pragma Singleton

import QtQml

QtObject {
    readonly property string vpnProviderName: "NordVPN"
    readonly property var vpnCliCommand: ["nordvpn"]
    readonly property var vpnApplicationCommand: ["uwsm", "app", "--", "nordvpn-gui"]
    readonly property var bluetoothApplicationCommand: ["uwsm", "app", "--", "blueman-manager"]
}
