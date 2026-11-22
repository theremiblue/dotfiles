import QtQuick

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.IconButton {
    id: root

    readonly property bool active: Services.Niri.overviewOpen

    iconSource: Config.Theme.tablerIcon(active ? "overview-active" : "overview")
    alternateIconSource: Config.Theme.tablerIcon(active ? "overview" : "overview-active")
    iconSize: Config.Theme.statusIconSize
    underlineVisible: containsMouse || active
    underlineColor: active ? Config.Theme.base0D : Config.Theme.base04

    onClicked: Services.Niri.toggleOverview()
}
