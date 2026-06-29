import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    property bool suppressNextClick: false

    readonly property color enabledTextColor: Config.Theme.bluetoothAccent
    readonly property color disabledTextColor: Config.Theme.barMuted
    readonly property url enabledIcon: Config.Theme.tablerIcon("bluetooth-enabled")
    readonly property url disabledIcon: Config.Theme.tablerIcon("bluetooth-disabled")

    function currentIcon() {
        if (Services.Bluetooth.enabled) {
            return enabledIcon;
        }

        return disabledIcon;
    }

    function currentIconColor() {
        if (Services.Bluetooth.enabled) {
            return enabledTextColor;
        }

        return disabledTextColor;
    }

    iconSource: currentIcon()
    alternateIconSource: Services.Bluetooth.enabled ? disabledIcon : enabledIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: Services.Drawers.isActive(Services.Drawers.bluetooth) ? Config.Theme.base0D : textColor
    underlineVisible: containsMouse || Services.Drawers.isActive(Services.Drawers.bluetooth)
    iconSize: Config.Theme.statusIconSize

    Timer {
        id: singleClickTimer

        interval: 400

        onTriggered: root.drawerLayer.toggle(Services.Drawers.bluetooth, root)
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
        Services.Bluetooth.openApplication();
    }
}
