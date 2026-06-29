pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string none: ""
    readonly property string power: "power"
    readonly property string network: "network"
    readonly property string vpn: "vpn"
    readonly property string wifi: "wifi"
    readonly property string bluetooth: "bluetooth"
    readonly property string sound: "sound"
    readonly property string notifications: "notifications"
    readonly property string main: "main"

    property string active: none
    function isDrawer(drawer) {
        return drawer === power
            || drawer === network
            || drawer === vpn
            || drawer === wifi
            || drawer === bluetooth
            || drawer === sound
            || drawer === notifications
            || drawer === main;
    }

    function isActive(drawer) {
        return active === drawer;
    }

    function show(drawer) {
        if (!isDrawer(drawer)) {
            active = none;
            return;
        }

        active = drawer;
    }

    function hide(drawer) {
        if (!drawer || active === drawer) {
            active = none;
        }
    }

    function toggle(drawer) {
        if (active === drawer) {
            hide(drawer);
            return;
        }

        show(drawer);
    }

    IpcHandler {
        target: "drawers"

        function show(drawer: string) {
            root.show(drawer);
        }

        function hide(drawer: string) {
            root.hide(drawer);
        }

        function toggle(drawer: string) {
            root.toggle(drawer);
        }
    }
}
