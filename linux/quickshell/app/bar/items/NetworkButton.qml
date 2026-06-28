import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    readonly property color connectedTextColor: "#00c853"
    readonly property color disconnectedTextColor: Config.Theme.barMuted
    readonly property url connectedIcon: Config.Theme.tablerIcon("network-connected")
    readonly property url disconnectedIcon: Config.Theme.tablerIcon("network-disconnected")

    function currentIcon() {
        if (Services.Network.ethernetConnected) {
            return connectedIcon;
        }

        return disconnectedIcon;
    }

    function currentIconColor() {
        if (Services.Network.ethernetConnected) {
            return connectedTextColor;
        }

        return disconnectedTextColor;
    }

    iconSource: currentIcon()
    alternateIconSource: Services.Network.ethernetConnected ? disconnectedIcon : connectedIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: textColor
    iconSize: Config.Theme.statusIconSize

    onClicked: {
        Services.Network.refresh();
        Services.Drawers.toggleNetwork(root);
    }
}
