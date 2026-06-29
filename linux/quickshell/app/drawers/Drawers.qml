import QtQuick

import qs.app.notifications as Notifications
import qs.services as Services

Item {
    id: root

    property var drawerAnchorCenterXs: ({})

    function setAnchor(drawer, item) {
        if (!Services.Drawers.isDrawer(drawer) || !item) {
            return;
        }

        const point = item.mapToItem(null, item.width / 2, item.height / 2);
        const anchors = {};

        for (const key in drawerAnchorCenterXs) {
            anchors[key] = drawerAnchorCenterXs[key];
        }

        anchors[drawer] = point.x;
        drawerAnchorCenterXs = anchors;
    }

    function anchorCenterXFor(drawer) {
        if (!drawer || drawerAnchorCenterXs[drawer] === undefined) {
            return -1;
        }

        return drawerAnchorCenterXs[drawer];
    }

    function show(drawer, anchorItem) {
        setAnchor(drawer, anchorItem);
        Services.Drawers.show(drawer);
    }

    function hide(drawer) {
        Services.Drawers.hide(drawer);
    }

    function toggle(drawer, anchorItem) {
        setAnchor(drawer, anchorItem);
        Services.Drawers.toggle(drawer);
    }

    PowerDrawer {}
    MainDrawer {}

    NetworkDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.network)
    }

    VpnDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.vpn)
    }

    WifiDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.wifi)
    }

    BluetoothDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.bluetooth)
    }

    SoundDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.sound)
    }

    Notifications.NotificationListDrawer {
        anchorCenterX: root.anchorCenterXFor(Services.Drawers.notifications)
    }
}
