import Quickshell.Bluetooth
import Quickshell
import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    readonly property color enabledTextColor: "#0082fc"
    readonly property color disabledTextColor: Config.Theme.barMuted
    readonly property url enabledIcon: Config.Theme.tablerIcon("bluetooth-enabled")
    readonly property url disabledIcon: Config.Theme.tablerIcon("bluetooth-disabled")

    function bluetoothEnabled() {
        const adapter = Bluetooth.defaultAdapter;

        if (adapter) {
            return adapter.enabled;
        }

        return false;
    }

    function currentIcon() {
        if (bluetoothEnabled()) {
            return enabledIcon;
        }

        return disabledIcon;
    }

    function currentIconColor() {
        if (bluetoothEnabled()) {
            return enabledTextColor;
        }

        return disabledTextColor;
    }

    function launchBluetoothManager() {
        Quickshell.execDetached(["uwsm", "app", "--", "blueman-manager"]);
    }

    iconSource: currentIcon()
    alternateIconSource: bluetoothEnabled() ? disabledIcon : enabledIcon
    textColor: currentIconColor()
    hoverTextColor: textColor
    underlineColor: textColor
    iconSize: Config.Theme.statusIconSize

    onPressed: event => {
        event.accepted = true;
        launchBluetoothManager();
    }
}
