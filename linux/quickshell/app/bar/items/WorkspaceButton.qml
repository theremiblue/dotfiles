import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    required property int wsIdx
    required property string wsLabel
    required property bool active
    required property bool occupied
    required property bool urgent

    readonly property color activeTextColor: Config.Theme.base06
    readonly property color occupiedTextColor: Config.Theme.barForeground
    readonly property color emptyTextColor: Config.Theme.barMuted
    readonly property color urgentTextColor: Config.Theme.barUrgent

    readonly property color activeUnderlineColor: Config.Theme.base0E
    readonly property color hoverUnderlineColor: Config.Theme.base04
    readonly property color urgentUnderlineColor: Config.Theme.barUrgent

    function workspaceTextColor() {
        if (active) {
            return activeTextColor;
        }

        if (urgent) {
            return urgentTextColor;
        }

        if (occupied) {
            return occupiedTextColor;
        }

        return emptyTextColor;
    }

    function workspaceUnderlineColor() {
        if (active) {
            return activeUnderlineColor;
        }

        if (urgent) {
            return urgentUnderlineColor;
        }

        return hoverUnderlineColor;
    }

    implicitWidth: Math.max(Config.Theme.workspaceWidth, Math.ceil(contentWidth()) + Config.Theme.padding * 2)
    text: wsLabel
    textColor: workspaceTextColor()
    hoverTextColor: textColor
    backgroundColor: "transparent"
    hoverBackgroundColor: Config.Theme.barHoverBackground
    underlineVisible: active || urgent || containsMouse
    underlineColor: workspaceUnderlineColor()
    underlineHeight: 2
    fontPixelSize: Config.Theme.smallFontSize
    horizontalPadding: 0

    onClicked: Services.Niri.focusWorkspace(root.wsIdx)

    onWheel: event => {
        event.accepted = true;
        if (event.angleDelta.y > 0) {
            Services.Niri.focusWorkspaceUp();
        } else if (event.angleDelta.y < 0) {
            Services.Niri.focusWorkspaceDown();
        }
    }
}
