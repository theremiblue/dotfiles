import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

Rectangle {
    id: root

    required property Notification notification

    property bool autoHide: true
    property bool showProgress: autoHide
    property bool slideOnHide: autoHide
    property bool hidden: false
    property bool closing: false
    property bool dismissAfterHide: false
    property real expiryProgress: 0

    readonly property int bodyLineLimit: autoHide ? 4 : 8
    readonly property color accentColor: notification.urgency === NotificationUrgency.Critical
        ? Config.Theme.base08
        : notification.urgency === NotificationUrgency.Low ? Config.Theme.barMuted : Config.Theme.base0D
    readonly property bool hasIcon: iconSource().length > 0
    readonly property int actionCount: notification.actions ? notification.actions.length : 0

    function imageSource(value) {
        if (!value || value.length === 0) {
            return "";
        }

        if (value.startsWith("/")) {
            return "file://" + value;
        }

        if (value.startsWith("file:") || value.startsWith("qrc:") || value.startsWith("image:")) {
            return value;
        }

        return "";
    }

    function iconSource() {
        const image = imageSource(notification.image);

        if (image.length > 0) {
            return image;
        }

        return imageSource(notification.appIcon);
    }

    function timeoutInterval() {
        if (!autoHide || notification.resident || notification.urgency === NotificationUrgency.Critical) {
            return 0;
        }

        return Config.Theme.notificationTimeout;
    }

    function startExpiry() {
        expiryTimer.stop();
        progressAnimation.stop();
        expiryProgress = 0;

        const interval = timeoutInterval();

        if (interval <= 0 || hidden || closing) {
            return;
        }

        expiryTimer.interval = interval;
        progressAnimation.duration = interval;
        progressAnimation.restart();
        expiryTimer.restart();
    }

    function beginHide(dismissNotification) {
        if (hidden || closing) {
            return;
        }

        dismissAfterHide = dismissNotification;
        expiryTimer.stop();
        progressAnimation.stop();
        closing = true;
        hideTimer.restart();
    }

    function dismissNotification() {
        beginHide(true);
    }

    function timeoutNotification() {
        beginHide(false);
    }

    function finishHide() {
        hidden = true;
        closing = false;

        if (dismissAfterHide) {
            Services.Notifications.dismiss(notification);
            return;
        }

        Services.Notifications.removePopup(notification);
    }

    function invokeAction(action) {
        action.invoke();
    }

    visible: !hidden
    implicitHeight: content.implicitHeight + Config.Theme.padding * 4 + (showProgress ? 2 : 0)
    Layout.preferredHeight: visible ? implicitHeight : 0
    opacity: closing ? 0 : 1
    radius: 6
    color: Config.Theme.base01
    border.color: accentColor
    border.width: 1
    clip: true
    transform: Translate {
        y: root.closing && root.slideOnHide ? -Config.Theme.barHeight * 1.5 : 0

        Behavior on y {
            NumberAnimation {
                duration: Config.Theme.animationDurationNormal
                easing.type: Easing.InCubic
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Config.Theme.animationDurationNormal
            easing.type: Easing.InCubic
        }
    }

    Component.onCompleted: startExpiry()

    Connections {
        target: root.notification

        function onClosed(reason) {
            root.hidden = true;
            Services.Notifications.removePopup(root.notification);
        }

        function onResidentChanged() {
            root.startExpiry();
        }

        function onUrgencyChanged() {
            root.startExpiry();
        }
    }

    Timer {
        id: expiryTimer

        onTriggered: root.timeoutNotification()
    }

    Timer {
        id: hideTimer

        interval: Config.Theme.animationDurationNormal

        onTriggered: root.finishHide()
    }

    NumberAnimation {
        id: progressAnimation

        target: root
        property: "expiryProgress"
        from: 0
        to: 1
        easing.type: Easing.Linear
    }

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: root.dismissNotification()
    }

    RowLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Config.Theme.padding * 2
        spacing: Config.Theme.spacing * 2

        IconImage {
            Layout.preferredWidth: visible ? Config.Theme.drawerIconSize : 0
            Layout.preferredHeight: visible ? Config.Theme.drawerIconSize : 0
            Layout.alignment: Qt.AlignTop

            visible: root.hasIcon
            implicitSize: Config.Theme.drawerIconSize
            source: root.iconSource()
            asynchronous: true
            mipmap: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Theme.spacing

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: root.notification.summary || root.notification.appName || "Notification"
                    color: Config.Theme.barForeground
                    font.pixelSize: Config.Theme.fontSize + 1
                    font.bold: true
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.maximumWidth: Math.round(root.width * 0.35)

                    text: root.notification.appName
                    visible: root.notification.appName.length > 0
                    color: Config.Theme.barMuted
                    font.pixelSize: Config.Theme.smallFontSize
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                }
            }

            UIPrimitives.AppText {
                Layout.fillWidth: true

                visible: root.notification.body.length > 0
                text: root.notification.body
                color: Config.Theme.base04
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
                maximumLineCount: root.bodyLineLimit
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            RowLayout {
                Layout.fillWidth: true

                visible: root.actionCount > 0
                spacing: Config.Theme.spacing

                Repeater {
                    model: root.notification.actions || []

                    MouseArea {
                        required property NotificationAction modelData

                        implicitWidth: actionLabel.implicitWidth + Config.Theme.padding * 3
                        implicitHeight: Math.max(Config.Theme.controlHeight, actionLabel.implicitHeight + Config.Theme.padding * 1.5)
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        Rectangle {
                            anchors.fill: parent

                            radius: 4
                            color: parent.containsMouse ? Config.Theme.base02 : Config.Theme.base00
                            border.color: Config.Theme.barBorder
                            border.width: 1
                        }

                        UIPrimitives.AppText {
                            id: actionLabel

                            anchors.centerIn: parent

                            text: parent.modelData.text
                            color: parent.containsMouse ? root.accentColor : Config.Theme.barForeground
                            font.pixelSize: Config.Theme.smallFontSize
                        }

                        onClicked: event => {
                            event.accepted = true;
                            root.invokeAction(modelData);
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: progressTrack

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: root.radius
        anchors.rightMargin: root.radius
        anchors.bottomMargin: root.border.width

        visible: root.showProgress
        height: 2
        color: "transparent"
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: progressTrack.width * root.expiryProgress
            radius: height / 2
            color: root.accentColor
        }
    }
}
