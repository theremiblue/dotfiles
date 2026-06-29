import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    readonly property bool active: Services.Drawers.isActive(Services.Drawers.sound)

    iconSource: Config.Theme.tablerIcon(Services.Sound.iconName())
    alternateIconSource: iconSource
    iconSize: Config.Theme.statusIconSize
    underlineVisible: containsMouse || active
    underlineColor: active ? Config.Theme.base0D : Services.Sound.outputMuted ? Config.Theme.barMuted : Config.Theme.base0C

    onClicked: drawerLayer.toggle(Services.Drawers.sound, root)

    onWheel: event => {
        event.accepted = true;

        if (event.angleDelta.y > 0) {
            Services.Sound.stepOutputVolume(5);
        } else if (event.angleDelta.y < 0) {
            Services.Sound.stepOutputVolume(-5);
        }
    }
}
