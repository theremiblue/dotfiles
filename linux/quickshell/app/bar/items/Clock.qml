import Quickshell
import QtQuick

import qs.config as Config
import qs.ui.primitives as UIPrimitives

Item {
    id: root

    readonly property string datePart:   Qt.formatDateTime(clock.date, "yyyy-MM-dd")
    readonly property string timePart:   Qt.formatDateTime(clock.date, "HH:mm")

    readonly property string plainText: datePart + " " + timePart

    readonly property color dateColor: Config.Theme.barMuted
    readonly property color timeColor: Config.Theme.base06

    implicitWidth: metrics.advanceWidth + Config.Theme.padding * 2
    implicitHeight: Config.Theme.barHeight

    UIPrimitives.AppText {
        id: clockText

        anchors.fill: parent

        text: '<span style="color: ' + root.dateColor + '">' + root.datePart + '</span>'
            + '<span style="color: ' + root.timeColor + '"> ' + root.timePart + '</span>'

        textFormat: Text.RichText
        font.family: Config.Theme.monospaceFontFamily
        font.pixelSize: Config.Theme.smallFontSize + 1
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }

    TextMetrics {
        id: metrics

        text: root.plainText
        font: clockText.font
    }
}
