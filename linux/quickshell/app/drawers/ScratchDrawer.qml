import Quickshell
import Quickshell.Wayland
import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

PanelWindow {
    id: root

    enum Size {
        Small,
        Normal,
        Large
    }

    enum Position {
        ScreenCenter
    }

    default property alias content: contentHost.data

    signal drawerActivated
    signal drawerDeactivated
    signal dismissed

    property string drawerType: Services.Drawers.none
    property int drawerSize: ScratchDrawer.Size.Normal
    property int drawerPosition: ScratchDrawer.Position.ScreenCenter
    property int contentPadding: Config.Theme.padding * 2
    property int mouseLeaveTimeout: 3000
    property color backgroundColor: Config.Theme.base01
    property color borderColor: Config.Theme.base0E
    readonly property bool drawerActive: Services.Drawers.isActive(drawerType)
    readonly property int maxDrawerHeight: Math.max(0, screen.height - Config.Theme.padding * 8)
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
        if (size === ScratchDrawer.Size.Small) {
            return Config.Theme.drawerSizeSmall;
        }

        if (size === ScratchDrawer.Size.Large) {
            return Config.Theme.drawerSizeLarge;
        }

        return Config.Theme.drawerSizeNormal;
    }

    function drawerWidthForSize(size) {
        return Math.round(screen.width * drawerFractionForSize(size));
    }

    function open() {
        visible = true;
    }

    function hide() {
        mouseLeaveTimer.stop();
        visible = false;
    }

    function toggle() {
        if (visible) {
            dismissed();
            return;
        }

        open();
    }

    function dismiss() {
        dismissed();
    }

    function syncDrawerActive() {
        if (drawerActive) {
            drawerActivated();
            open();
            return;
        }

        hide();
        drawerDeactivated();
    }

    function updateMouseLeaveTimer() {
        if (!visible) {
            mouseLeaveTimer.stop();
            return;
        }

        if (popupHover.hovered) {
            mouseLeaveTimer.stop();
            return;
        }

        mouseLeaveTimer.restart();
    }

    visible: false
    implicitWidth: drawerWidthForSize(drawerSize)
    implicitHeight: Math.min(maxDrawerHeight, fittedContentHeight + contentPadding * 2)
    color: "transparent"
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: visible

    WlrLayershell.namespace: "quickshell-drawers"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

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

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(() => {
                overlay.forceActiveFocus();
                updateMouseLeaveTimer();
            });
            return;
        }

        mouseLeaveTimer.stop();
    }

    Timer {
        id: mouseLeaveTimer

        interval: root.mouseLeaveTimeout

        onTriggered: root.dismiss()
    }

    FocusScope {
        id: overlay

        anchors.fill: parent
        focus: root.visible

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
            id: popupBounds

            width: frame.width + panelShadow.margin * 2
            height: frame.height + panelShadow.margin * 2
            anchors.centerIn: parent

            UIPrimitives.PanelShadow {
                id: panelShadow

                anchors.centerIn: parent

                sourceWidth: frame.width
                sourceHeight: frame.height
                sourceRadius: frame.radius
            }

            Rectangle {
                id: frame

                width: root.implicitWidth
                height: root.implicitHeight
                anchors.centerIn: parent

                color: root.backgroundColor
                border.color: root.borderColor
                border.width: 1
                radius: 8

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                }

                HoverHandler {
                    id: popupHover

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
