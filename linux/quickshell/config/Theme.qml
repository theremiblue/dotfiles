pragma Singleton

import QtQuick

QtObject {
    readonly property color base00: "#1d1f21"
    readonly property color base01: "#282a2e"
    readonly property color base02: "#373b41"
    readonly property color base03: "#969896"
    readonly property color base04: "#b4b7b4"
    readonly property color base05: "#c5c8c6"
    readonly property color base06: "#e0e0e0"
    readonly property color base07: "#ffffff"
    readonly property color base08: "#cc6666"
    readonly property color base09: "#de935f"
    readonly property color base0A: "#f0c674"
    readonly property color base0B: "#b5bd68"
    readonly property color base0C: "#8abeb7"
    readonly property color base0D: "#81a2be"
    readonly property color base0E: "#b294bb"
    readonly property color base0F: "#a3685a"

    readonly property color surfaceInset: "#191b1d"
    readonly property color hairlineSubtle: "#2d3035"
    readonly property color barBackground: base00
    readonly property color barForeground: base05
    readonly property color barMuted: base03
    readonly property color barBorder: base02
    readonly property color barActiveBackground: base02
    readonly property color barHoverBackground: base01
    readonly property color barAccent: base0D
    readonly property color barUrgent: base08
    readonly property color bluetoothAccent: "#0082fc"

    readonly property int barHeight: 34
    readonly property int fontSize: 17
    readonly property int smallFontSize: 15
    readonly property int padding: 7
    readonly property int spacing: 7
    readonly property int radius: 2
    readonly property int statusIconSize: 22
    readonly property int statusIconSpacing: 3
    readonly property int workspaceWidth: 30
    readonly property int notificationWidth: 420
    readonly property int controlHeight: Math.round(fontSize * 1.9)
    readonly property int inlineIconSize: Math.round(fontSize * 1.05)
    readonly property int drawerIconSize: Math.round(fontSize * 1.4)
    readonly property int detailLabelWidth: Math.round(fontSize * 6.5)
    readonly property int switchHeight: Math.round(fontSize * 1.25)
    readonly property int switchWidth: Math.round(switchHeight * 1.85)
    readonly property int notificationTimeout: 5000
    readonly property int animationDurationShort: 120
    readonly property int animationDurationNormal: 180
    readonly property int animationDurationLong: 300
    readonly property real drawerSizeSmall: 0.17
    readonly property real drawerSizeNormal: 0.32
    readonly property real drawerSizeLarge: 0.58

    readonly property string fontFamily: "sans-serif"
    readonly property string monospaceFontFamily: "monospace"

    function tablerIcon(name) {
        return Qt.resolvedUrl("../assets/icons/tabler/" + name + ".svg");
    }

    readonly property url archIcon: Qt.resolvedUrl("../assets/icons/arch/archlinux-logo.svg")
    readonly property url linuxPenguinIcon: Qt.resolvedUrl("../assets/icons/linux/tux.svg")
}
