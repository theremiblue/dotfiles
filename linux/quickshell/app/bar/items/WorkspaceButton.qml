import QtQuick
import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    required property int wsId
    required property int activeWsId
    required property bool occupied

    readonly property bool active: activeWsId === wsId

    readonly property color defaultBackgroundColor: "transparent"
    readonly property color activeBackgroundColor: defaultBackgroundColor
    readonly property color workspaceHoverBackgroundColor: Config.Theme.barHoverBackground

    readonly property color activeTextColor: Config.Theme.base0E
    readonly property color occupiedTextColor: Config.Theme.barForeground
    readonly property color emptyTextColor: Config.Theme.barMuted

    readonly property color activeUnderlineColor: Config.Theme.base0E
    readonly property color hoverUnderlineColor: Config.Theme.base04

    function workspaceBackgroundColor() {
        if (active) {
            return activeBackgroundColor;
        }

        return defaultBackgroundColor;
    }

    function workspaceTextColor() {
        if (active) {
            return activeTextColor;
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

        return hoverUnderlineColor;
    }

    function focusWorkspace() {
        Services.Niri.focusWorkspace(root.wsId);
    }

    implicitWidth: Config.Theme.workspaceWidth
    text: wsId
    textColor: workspaceTextColor()
    hoverTextColor: textColor
    backgroundColor: workspaceBackgroundColor()
    hoverBackgroundColor: root.workspaceHoverBackgroundColor
    underlineVisible: active || containsMouse
    underlineColor: workspaceUnderlineColor()
    underlineHeight: 2
    fontPixelSize: Config.Theme.smallFontSize
    horizontalPadding: 0

    onClicked: focusWorkspace()
}
