import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.Drawer {
    id: root

    drawerType: Services.Drawers.notifications
    drawerSize: UIPrimitives.Drawer.Size.Normal
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    customWidth: Config.Theme.notificationWidth + contentPadding * 2
    borderColor: Config.Theme.barBorder

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            UIPrimitives.AppText {
                Layout.fillWidth: true

                text: "Notifications"
                color: Config.Theme.barForeground
                font.pixelSize: Config.Theme.fontSize + 2
                horizontalAlignment: Text.AlignLeft
            }

            UIPrimitives.AppText {
                text: Services.Notifications.count.toString()
                color: Config.Theme.barMuted
                horizontalAlignment: Text.AlignRight
            }

            Controls.UtilityButton {
                visible: Services.Notifications.count > 0
                label: "Clear"
                accentColor: Config.Theme.base0D

                onClicked: Services.Notifications.clearAll()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        Item {
            id: notificationBody

            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: Services.Notifications.count === 0
                ? emptyText.implicitHeight
                : Math.min(notificationList.implicitHeight, root.maxContentHeight)

            UIPrimitives.AppText {
                id: emptyText

                anchors.centerIn: parent

                visible: Services.Notifications.count === 0
                text: "No notifications"
                color: Config.Theme.barMuted
            }

            Flickable {
                anchors.fill: parent

                visible: Services.Notifications.count > 0
                clip: true
                contentWidth: width
                contentHeight: notificationList.implicitHeight

                ColumnLayout {
                    id: notificationList

                    width: parent.width
                    spacing: Config.Theme.spacing * 2

                    Repeater {
                        model: Services.Notifications.trackedNotifications

                        NotificationToast {
                            required property Notification modelData

                            Layout.fillWidth: true
                            notification: modelData
                            autoHide: false
                            showProgress: false
                            slideOnHide: false
                        }
                    }
                }
            }
        }
    }
}
