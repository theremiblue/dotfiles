pragma Singleton

import Quickshell
import Quickshell.Services.Notifications as NotificationService

Singleton {
    id: root

    property alias trackedNotifications: server.trackedNotifications
    property var popupNotifications: []

    readonly property int count: server.trackedNotifications.values.length

    function addPopup(notification) {
        const withoutCurrent = popupNotifications.filter(item => item !== notification);
        popupNotifications = [notification].concat(withoutCurrent);
    }

    function removePopup(notification) {
        popupNotifications = popupNotifications.filter(item => item !== notification);
    }

    function dismiss(notification) {
        removePopup(notification);
        notification.tracked = false;
    }

    function clearAll() {
        const notifications = server.trackedNotifications.values.slice();

        for (const notification of notifications) {
            dismiss(notification);
        }
    }

    NotificationService.NotificationServer {
        id: server

        keepOnReload: false
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        actionsSupported: true
        actionIconsSupported: false
        imageSupported: true
        inlineReplySupported: false

        onNotification: notification => {
            notification.tracked = true;
            root.addPopup(notification);
        }
    }
}
