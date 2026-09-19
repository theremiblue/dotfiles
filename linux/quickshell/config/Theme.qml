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

    readonly property color barBackground: base00
    readonly property color barForeground: base05
    readonly property color barMuted: base03
    readonly property color barBorder: base02
    readonly property color barActiveBackground: base02
    readonly property color barHoverBackground: base01
    readonly property color barAccent: base0D
    readonly property color barUrgent: base08
    readonly property color bluetoothAccent: "#0082fc"

    readonly property int barHeight: 36
    readonly property int fontSize: 20
    readonly property int smallFontSize: 18
    readonly property int padding: 8
    readonly property int spacing: 8
    readonly property int statusIconSize: 28
    readonly property int statusIconSpacing: 4
    readonly property int workspaceWidth: 32
    readonly property int notificationWidth: 512
    readonly property int notificationTimeout: 5000
    readonly property int animationDurationShort: 120
    readonly property int animationDurationNormal: 180
    readonly property int animationDurationLong: 300
    readonly property int panelShadowSize: 28
    readonly property color panelShadowColor: "#000000"
    readonly property real panelShadowOuterOpacity: 0.08
    readonly property real panelShadowMiddleOpacity: 0.12
    readonly property real panelShadowInnerOpacity: 0.16
    readonly property real drawerSizeSmall: 0.2
    readonly property real drawerSizeNormal: 0.4
    readonly property real drawerSizeLarge: 0.8

    readonly property string fontFamily: "sans-serif"
    readonly property string monospaceFontFamily: "monospace"

    function tablerIcon(name) {
        return Qt.resolvedUrl("../assets/icons/tabler/" + name + ".svg");
    }

    readonly property url archIcon: Qt.resolvedUrl("../assets/icons/arch/archlinux-logo.svg")
    readonly property url linuxPenguinIcon: Qt.resolvedUrl("../assets/icons/linux/tux.svg")

    readonly property int minWorkspaceCount: 4
}
