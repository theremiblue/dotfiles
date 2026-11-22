import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.config as Config
import qs.services as Services

PanelWindow {
    id: root

    enum Size {
        Small,
        Normal,
        Large
    }

    enum Position {
        ScreenCenter,
        ScreenHorizontalCenter,
        AnchorCenter
    }

    default property alias content: contentHost.data

    signal drawerActivated
    signal drawerDeactivated
    signal dismissed

    property string drawerType: Services.Drawers.none
    property bool drawerOpen: false
    property bool renderVisible: false
    property int drawerSize: Drawer.Size.Normal
    property int drawerPosition: Drawer.Position.AnchorCenter
    property int customWidth: 0
    property int customHeight: 0
    property int animationDuration: Config.Theme.animationDurationNormal
    property int mouseLeaveTimeout: 3000
    property int contentPadding: Config.Theme.padding * 3
    property int edgeMargin: Config.Theme.padding * 2
    property int topOffset: Config.Theme.barHeight
    property real anchorCenterX: -1
    property color backgroundColor: Config.Theme.base01
    property color borderColor: Config.Theme.barBorder
    readonly property bool drawerActive: Services.Drawers.isActive(drawerType)
    readonly property int maxDrawerHeight: Math.max(0, screen.height - topOffset - edgeMargin)
    readonly property int maxContentHeight: Math.max(0, maxDrawerHeight - contentPadding * 2)
    readonly property int fittedContentHeight: {
        if (contentHost.children.length === 0) {
            return 0;
        }

        const firstChild = contentHost.children[0];
        if (firstChild.implicitHeight > 0) {
            return Math.ceil(firstChild.implicitHeight);
        }

        return Math.ceil(contentHost.childrenRect.height || 0);
    }

    function drawerFractionForSize(size) {
        if (size === Drawer.Size.Small) {
            return Config.Theme.drawerSizeSmall;
        }

        if (size === Drawer.Size.Large) {
            return Config.Theme.drawerSizeLarge;
        }

        return Config.Theme.drawerSizeNormal;
    }

    function drawerWidthForSize(size) {
        return Math.round(screen.width * drawerFractionForSize(size));
    }

    function clamp(value, minimum, maximum) {
        return Math.max(minimum, Math.min(maximum, value));
    }

    function frameLeftForPosition() {
        const minimum = edgeMargin;
        const maximum = Math.max(minimum, width - edgeMargin - frame.width);

        if (drawerPosition === Drawer.Position.ScreenCenter
                || drawerPosition === Drawer.Position.ScreenHorizontalCenter
                || anchorCenterX < 0) {
            return clamp((width - frame.width) / 2, minimum, maximum);
        }

        return clamp(anchorCenterX - frame.width / 2, minimum, maximum);
    }

    function frameTopForPosition() {
        if (drawerPosition === Drawer.Position.ScreenCenter) {
            return Math.max(edgeMargin, (height - frame.height) / 2);
        }

        return topOffset;
    }

    function hiddenTopForPosition() {
        if (drawerPosition === Drawer.Position.ScreenCenter) {
            return frameTopForPosition() - panelShadow.margin;
        }

        return -drawerHost.height;
    }

    function open() {
        closeTimer.stop();
        mouseLeaveTimer.stop();
        renderVisible = true;
        drawerOpen = true;
        Qt.callLater(() => {
            overlay.forceActiveFocus();
            updateMouseLeaveTimer();
        });
    }

    function close() {
        mouseLeaveTimer.stop();
        drawerOpen = false;
        closeTimer.restart();
    }

    function toggle() {
        if (drawerOpen) {
            dismiss();
            return;
        }

        open();
    }

    function dismiss() {
        if (!drawerOpen) {
            return;
        }

        close();
        dismissed();
    }

    function syncDrawerActive() {
        if (drawerActive) {
            drawerActivated();
            open();
            return;
        }

        close();
        drawerDeactivated();
    }

    function updateMouseLeaveTimer() {
        if (!drawerOpen) {
            mouseLeaveTimer.stop();
            return;
        }

        if (drawerHover.hovered) {
            mouseLeaveTimer.stop();
            return;
        }

        mouseLeaveTimer.restart();
    }

    visible: renderVisible
    implicitWidth: customWidth > 0 ? customWidth : drawerWidthForSize(drawerSize)
    implicitHeight: customHeight > 0 ? customHeight : Math.min(maxDrawerHeight, fittedContentHeight + contentPadding * 2)
    color: "transparent"
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: renderVisible

    WlrLayershell.namespace: "quickshell-bar-drawers"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: renderVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Component.onCompleted: syncDrawerActive()
    onDrawerActiveChanged: syncDrawerActive()
    onDismissed: {
        if (drawerType !== Services.Drawers.none) {
            Services.Drawers.hide(drawerType);
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Timer {
        id: closeTimer

        interval: root.animationDuration + 30

        onTriggered: {
            if (!root.drawerOpen) {
                root.renderVisible = false;
            }
        }
    }

    Timer {
        id: mouseLeaveTimer

        interval: root.mouseLeaveTimeout

        onTriggered: root.dismiss()
    }

    FocusScope {
        id: overlay

        anchors.fill: parent
        focus: root.renderVisible

        Keys.onEscapePressed: event => {
            event.accepted = true;
            root.dismiss();
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons

            onClicked: root.dismiss()
        }

        Item {
            id: drawerHost

            width: frame.width + panelShadow.margin * 2
            height: frame.height + panelShadow.margin * 2
            x: root.frameLeftForPosition() - panelShadow.margin
            y: root.drawerOpen ? root.frameTopForPosition() - panelShadow.margin : root.hiddenTopForPosition()
            opacity: root.drawerOpen ? 1 : 0

            Behavior on y {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            PanelShadow {
                id: panelShadow

                anchors.centerIn: frame

                sourceWidth: frame.width
                sourceHeight: frame.height
                sourceRadius: frame.radius
            }

            Rectangle {
                id: frame

                width: root.implicitWidth
                height: root.implicitHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: panelShadow.margin

                color: root.backgroundColor
                border.color: root.borderColor
                border.width: 1
                radius: 6

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                }

                HoverHandler {
                    id: drawerHover

                    onHoveredChanged: root.updateMouseLeaveTimer()
                }

                Item {
                    id: contentHost

                    anchors.fill: parent
                    anchors.margins: root.contentPadding
                }
            }
        }
    }
}
