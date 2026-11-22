import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    required property var drawerLayer

    readonly property bool active: Services.Drawers.isActive(Services.Drawers.power)

    iconSource: Config.Theme.archIcon
    alternateIconSource: iconSource
    iconSize: Config.Theme.statusIconSize
    underlineVisible: containsMouse || active
    underlineColor: Config.Theme.base0D

    onClicked: drawerLayer.toggle(Services.Drawers.power, root)
}
