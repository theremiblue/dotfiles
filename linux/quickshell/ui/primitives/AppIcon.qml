import Quickshell.Widgets
import QtQuick

import qs.config as Config

Item {
    id: root

    enum SourceMode {
        ImageSource,
        TraySource
    }

    property string source: ""
    property string label: ""
    property int iconSize: Config.Theme.statusIconSize
    property int sourceSize: Math.max(64, iconSize * 4)
    property int sourceMode: AppIcon.ImageSource
    property bool asynchronous: true
    property bool mipmap: true

    readonly property bool hasSource: source.length > 0

    implicitWidth: iconSize
    implicitHeight: iconSize

    Image {
        anchors.centerIn: parent

        visible: root.hasSource && root.sourceMode === AppIcon.ImageSource
        width: root.iconSize
        height: root.iconSize
        source: visible ? root.source : ""
        sourceSize.width: root.sourceSize
        sourceSize.height: root.sourceSize
        fillMode: Image.PreserveAspectFit
        asynchronous: root.asynchronous
        mipmap: root.mipmap
        smooth: true
    }

    IconImage {
        anchors.centerIn: parent

        visible: root.hasSource && root.sourceMode === AppIcon.TraySource
        implicitSize: root.iconSize
        source: visible ? root.source : ""
        asynchronous: root.asynchronous
        mipmap: root.mipmap
        backer.sourceSize.width: root.sourceSize
        backer.sourceSize.height: root.sourceSize
        backer.smooth: true
    }

    AppText {
        anchors.centerIn: parent

        visible: !root.hasSource
        text: root.label.length > 0 ? root.label[0].toUpperCase() : "?"
        color: Config.Theme.base0D
        font.pixelSize: root.iconSize
        font.family: Config.Theme.monospaceFontFamily
    }
}
