import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.config as Config

MouseArea {
    id: root

    property string name: ""
    property string value: ""
    property string copyText: ""
    property string fallbackValue: "Unavailable"
    property int nameWidth: Config.Theme.detailLabelWidth

    property bool copied: false
    readonly property string effectiveCopyText: copyText.length > 0 ? copyText : value
    readonly property bool copyEnabled: effectiveCopyText.length > 0 && effectiveCopyText !== "--"

    function displayValue() {
        if (value && value.length > 0 && value !== "--") {
            return value;
        }

        return fallbackValue;
    }

    function copy() {
        if (!copyEnabled) {
            return;
        }

        Quickshell.clipboardText = effectiveCopyText;
        copied = true;
        copiedTimer.restart();
    }

    Layout.fillWidth: true
    implicitHeight: Math.max(label.implicitHeight, field.implicitHeight) + Config.Theme.padding
    hoverEnabled: true
    cursorShape: copyEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor

    onClicked: root.copy()

    Rectangle {
        anchors.fill: parent
        radius: Config.Theme.radius
        color: root.copyEnabled && root.containsMouse ? Config.Theme.base01 : "transparent"
    }

    RowLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        AppText {
            id: label

            Layout.preferredWidth: root.nameWidth

            text: root.name
            color: Config.Theme.barMuted
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
        }

        AppText {
            id: field

            Layout.fillWidth: true

            text: root.displayValue()
            color: root.copied ? Config.Theme.base0B : Config.Theme.barForeground
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
        }
    }

    Timer {
        id: copiedTimer

        interval: Config.Theme.notificationTimeout / 5

        onTriggered: root.copied = false
    }
}
