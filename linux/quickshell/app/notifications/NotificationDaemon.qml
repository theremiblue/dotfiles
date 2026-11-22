import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services

PanelWindow {
    id: root

    readonly property int edgeMargin: Config.Theme.padding * 2
    readonly property int topMargin: Config.Theme.barHeight + edgeMargin
    readonly property int toastWidth: Config.Theme.notificationWidth

    visible: Services.Notifications.popupNotifications.length > 0
    implicitWidth: toastWidth + edgeMargin * 2
    implicitHeight: Math.min(Math.round(screen.height * 0.6), notificationColumn.implicitHeight + topMargin + edgeMargin)
    color: "transparent"
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: false

    WlrLayershell.namespace: "quickshell-notifications"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    Item {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            id: notificationColumn

            anchors.top: parent.top
            anchors.topMargin: root.topMargin
            anchors.right: parent.right
            anchors.rightMargin: root.edgeMargin
            width: root.toastWidth
            spacing: Config.Theme.spacing * 2

            Repeater {
                id: notificationRepeater

                model: ScriptModel {
                    values: Services.Notifications.popupNotifications
                }

                NotificationToast {
                    required property Notification modelData

                    Layout.fillWidth: true
                    notification: modelData
                    autoHide: true
                    showProgress: true
                    slideOnHide: true
                }
            }
        }
    }
}
