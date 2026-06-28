import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.ui.primitives as UIPrimitives

RowLayout {
    id: root

    property string name: ""
    property string value: ""
    property string fallbackValue: "Unavailable"
    property int nameWidth: 62

    function displayValue() {
        if (value && value.length > 0 && value !== "--") {
            return value;
        }

        return fallbackValue;
    }

    Layout.fillWidth: true
    spacing: Config.Theme.spacing * 2

    UIPrimitives.AppText {
        Layout.preferredWidth: root.nameWidth

        text: root.name
        color: Config.Theme.barMuted
        horizontalAlignment: Text.AlignLeft
    }

    UIPrimitives.AppText {
        Layout.fillWidth: true

        text: root.displayValue()
        color: Config.Theme.barForeground
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
    }
}
