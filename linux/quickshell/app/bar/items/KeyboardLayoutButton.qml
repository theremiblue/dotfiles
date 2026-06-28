import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives
import qs.services as Services

UIPrimitives.IconButton {
    id: root

    readonly property color layoutTextColor: Config.Theme.base0B

    text: Services.KeyboardLayout.label
    textColor: layoutTextColor
    hoverTextColor: textColor
    underlineColor: textColor
    fontFamily: Config.Theme.monospaceFontFamily
    fontPixelSize: Config.Theme.smallFontSize

    onClicked: Services.KeyboardLayout.switchNext()
}
