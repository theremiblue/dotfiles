import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    property bool suppressNextClick: false

    readonly property color connectedTextColor: Config.Theme.base0B
    readonly property color disconnectedTextColor: Config.Theme.barMuted
    readonly property url connectedIcon: Config.Theme.tablerIcon("vpn-connected")
    readonly property url disconnectedIcon: Config.Theme.tablerIcon("vpn-disconnected")

    function currentIcon() {
        if (Services.Vpn.connected) {
            return connectedIcon;
        }

        return disconnectedIcon;
    }

    function currentIconColor() {
        if (Services.Vpn.connected) {
            return connectedTextColor;
        }

        return disconnectedTextColor;
    }

    iconSource: currentIcon()
    alternateIconSource: Services.Vpn.connected ? disconnectedIcon : connectedIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: Services.Drawers.isActive(Services.Drawers.vpn) ? Config.Theme.base0D : textColor
    underlineVisible: containsMouse || Services.Drawers.isActive(Services.Drawers.vpn)
    iconSize: Config.Theme.statusIconSize

    Timer {
        id: singleClickTimer

        interval: 400

        onTriggered: {
            Services.Vpn.refresh();
            root.drawerLayer.toggle(Services.Drawers.vpn, root);
        }
    }

    onClicked: event => {
        event.accepted = true;

        if (suppressNextClick) {
            suppressNextClick = false;
            return;
        }

        singleClickTimer.restart();
    }

    onDoubleClicked: event => {
        event.accepted = true;
        suppressNextClick = true;
        singleClickTimer.stop();
        Services.Vpn.openApplication();
    }
}
