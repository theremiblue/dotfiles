import QtQuick
import qs.config as Config

MouseArea {
    id: root

    property string text: ""
    property string alternateText: ""
    property url iconSource: ""
    property url alternateIconSource: ""

    property color textColor: Config.Theme.barForeground
    property color hoverTextColor: textColor
    property color backgroundColor: "transparent"
    property color hoverBackgroundColor: Config.Theme.barHoverBackground
    property color underlineColor: Config.Theme.base04
    property color pressedOverlayColor: Qt.rgba(0, 0, 0, 0.28)

    property string fontFamily: Config.Theme.fontFamily
    property int fontPixelSize: Config.Theme.fontSize
    property int iconSize: Config.Theme.statusIconSize

    property int horizontalPadding: Config.Theme.padding

    property bool pressedInsetEnabled: true

    property int underlineHeight: 2
    property bool underlineVisible: containsMouse

    function currentBackgroundColor() {
        if (containsMouse) {
            return hoverBackgroundColor;
        }

        return backgroundColor;
    }

    function currentTextColor() {
        if (containsMouse) {
            return hoverTextColor;
        }

        return textColor;
    }

    function contentOffset() {
        if (pressedInsetEnabled && pressed) {
            return 1;
        }

        return 0;
    }

    function contentWidth() {
        if (hasIcon()) {
            return iconSize;
        }

        return Math.max(textMetrics.advanceWidth, alternateTextMetrics.advanceWidth);
    }

    function hasIcon() {
        return iconSource.toString().length > 0 || alternateIconSource.toString().length > 0;
    }

    implicitWidth: Math.ceil(contentWidth()) + horizontalPadding * 2
    implicitHeight: Config.Theme.barHeight
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        anchors.fill: parent

        color: root.currentBackgroundColor()
    }

    Rectangle {
        anchors.fill: parent

        visible: root.pressedInsetEnabled && root.pressed
        color: root.pressedOverlayColor

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            height: 1
            color: Qt.rgba(0, 0, 0, 0.45)
        }
    }

    AppText {
        id: label

        visible: !root.hasIcon()
        anchors.fill: parent
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.horizontalPadding
        anchors.topMargin: root.contentOffset()
        anchors.bottomMargin: -root.contentOffset()

        text: root.text
        color: root.currentTextColor()
        font.family: root.fontFamily
        font.pixelSize: root.fontPixelSize
    }

    Icon {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.contentOffset()

        visible: root.hasIcon()
        source: root.iconSource
        implicitSize: root.iconSize
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.bottom: parent.bottom

        visible: root.underlineVisible
        height: root.underlineHeight
        color: root.underlineColor
    }

    TextMetrics {
        id: textMetrics

        text: root.text
        font: label.font
    }

    TextMetrics {
        id: alternateTextMetrics

        text: root.alternateText
        font: label.font
    }
}
