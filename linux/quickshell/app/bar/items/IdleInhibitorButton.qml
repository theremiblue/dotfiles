import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    readonly property color enabledTextColor: Config.Theme.base09
    readonly property color disabledTextColor: Config.Theme.barMuted
    readonly property url enabledIcon: Config.Theme.tablerIcon("idle-enabled")
    readonly property url disabledIcon: Config.Theme.tablerIcon("idle-disabled")

    function currentIcon() {
        if (Services.IdleInhibitor.enabled) {
            return enabledIcon;
        }

        return disabledIcon;
    }

    function currentIconColor() {
        if (Services.IdleInhibitor.enabled) {
            return enabledTextColor;
        }

        return disabledTextColor;
    }

    iconSource: currentIcon()
    alternateIconSource: Services.IdleInhibitor.enabled ? disabledIcon : enabledIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: textColor
    iconSize: Config.Theme.statusIconSize

    onClicked: Services.IdleInhibitor.toggle()
}
