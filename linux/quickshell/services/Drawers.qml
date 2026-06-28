pragma Singleton

import Quickshell

Singleton {
    id: root

    property bool powerVisible: false
    property bool networkVisible: false
    property bool wifiVisible: false
    property bool notificationsVisible: false
    property bool mainVisible: false
    property real anchorCenterX: -1

    function setAnchorFromItem(item) {
        if (!item) {
            anchorCenterX = -1;
            return;
        }

        const point = item.mapToItem(null, item.width / 2, item.height / 2);
        anchorCenterX = point.x;
    }

    function showPower() {
        networkVisible = false;
        wifiVisible = false;
        notificationsVisible = false;
        mainVisible = false;
        powerVisible = true;
    }

    function hidePower() {
        powerVisible = false;
    }

    function togglePower() {
        if (powerVisible) {
            hidePower();
            return;
        }

        showPower();
    }

    function showNetwork(anchorItem) {
        setAnchorFromItem(anchorItem);
        powerVisible = false;
        wifiVisible = false;
        notificationsVisible = false;
        mainVisible = false;
        networkVisible = true;
    }

    function hideNetwork() {
        networkVisible = false;
    }

    function toggleNetwork(anchorItem) {
        if (networkVisible) {
            hideNetwork();
            return;
        }

        showNetwork(anchorItem);
    }

    function showWifi(anchorItem) {
        setAnchorFromItem(anchorItem);
        powerVisible = false;
        networkVisible = false;
        notificationsVisible = false;
        mainVisible = false;
        wifiVisible = true;
    }

    function hideWifi() {
        wifiVisible = false;
    }

    function toggleWifi(anchorItem) {
        if (wifiVisible) {
            hideWifi();
            return;
        }

        showWifi(anchorItem);
    }

    function showNotifications(anchorItem) {
        setAnchorFromItem(anchorItem);
        powerVisible = false;
        networkVisible = false;
        wifiVisible = false;
        mainVisible = false;
        notificationsVisible = true;
    }

    function hideNotifications() {
        notificationsVisible = false;
    }

    function toggleNotifications(anchorItem) {
        if (notificationsVisible) {
            hideNotifications();
            return;
        }

        showNotifications(anchorItem);
    }

    function showMain() {
        powerVisible = false;
        networkVisible = false;
        wifiVisible = false;
        notificationsVisible = false;
        mainVisible = true;
    }

    function hideMain() {
        mainVisible = false;
    }

    function toggleMain() {
        if (mainVisible) {
            hideMain();
            return;
        }

        showMain();
    }
}
