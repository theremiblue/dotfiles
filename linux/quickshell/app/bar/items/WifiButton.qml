import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    readonly property color enabledTextColor: "#00aaff"
    readonly property color disabledTextColor: Config.Theme.barMuted
    readonly property url enabledIcon: Config.Theme.tablerIcon("wifi-enabled")
    readonly property url disabledIcon: Config.Theme.tablerIcon("wifi-disabled")

    function currentIcon() {
        if (Services.Network.wifiEnabled) {
            return enabledIcon;
        }

        return disabledIcon;
    }

    function currentIconColor() {
        if (Services.Network.wifiEnabled) {
            return enabledTextColor;
        }

        return disabledTextColor;
    }

    iconSource: currentIcon()
    alternateIconSource: Services.Network.wifiEnabled ? disabledIcon : enabledIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: Services.Drawers.isActive(Services.Drawers.wifi) ? Config.Theme.base0D : textColor
    underlineVisible: containsMouse || Services.Drawers.isActive(Services.Drawers.wifi)
    iconSize: Config.Theme.statusIconSize

    onClicked: drawerLayer.toggle(Services.Drawers.wifi, root)
}
