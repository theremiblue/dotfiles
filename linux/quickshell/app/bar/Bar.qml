import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.app.bar as Bar
import qs.app.bar.items as Items
import qs.config as Config
import qs.ui.controls as Controls

Item {
    id: statusBar

    required property ShellScreen screen

    readonly property int position: Bar.BarConfig.position
    readonly property int implicitSize: Bar.BarConfig.size
    readonly property int archHoverShadowHeight: 14

    readonly property bool vertical: Bar.BarConfig.isVertical(position)
    readonly property bool horizontal: !vertical

    function colorWithAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    implicitHeight: implicitSize + archHoverShadowHeight

    readonly property int exclusiveZone: Bar.BarConfig.reserveSpace ? implicitSize : 0

    // Backwards-compatible name for code that still reads reservedSize.
    readonly property int reservedSize: exclusiveZone

    Rectangle {
        id: barSurface

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: statusBar.implicitSize
        color: Config.Theme.barBackground

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 1
            color: Config.Theme.barBorder
        }

        RowLayout {
            id: leftGroup

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: Config.Theme.spacing

            Item {
                implicitWidth: Config.Theme.padding
            }

            Items.ArchButton {
                id: archIcon
            }

            Item {
                implicitWidth: Config.Theme.spacing
            }

            Items.Workspaces {
                screen: statusBar.screen
            }
        }

        Items.WindowTitle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            width: Math.max(0, parent.width - Math.max(leftGroup.implicitWidth, rightGroup.implicitWidth) * 2 - Config.Theme.spacing * 2)
            screen: statusBar.screen
        }

        RowLayout {
            id: rightGroup

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: Config.Theme.spacing

            Items.Tray {}

            Item {
                implicitWidth: Config.Theme.spacing
            }

            Controls.ButtonGroup {
                spacing: Config.Theme.statusIconSpacing

                Items.WifiButton {}

                Items.BluetoothButton {}

                Items.NetworkButton {}
            }

            Item {
                implicitWidth: Config.Theme.spacing
            }

            Items.Clock {}

            Items.KeyboardLayoutButton {}

            Items.IdleInhibitorButton {}

            Items.NotificationButton {}

            Item {
                implicitWidth: Config.Theme.padding
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 2
            opacity: archIcon.hovered ? 1 : 0
            color: archIcon.highlightColor

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.Theme.animationDurationLong
                }
            }
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: barSurface.bottom

        height: statusBar.archHoverShadowHeight
        clip: true
        opacity: archIcon.hovered ? 1 : 0

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            height: archIcon.hovered ? parent.height : 0
            gradient: Gradient {
                orientation: Gradient.Vertical

                GradientStop {
                    position: 0
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0.42)
                }

                GradientStop {
                    position: 0.65
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0.12)
                }

                GradientStop {
                    position: 1
                    color: statusBar.colorWithAlpha(archIcon.highlightColor, 0)
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: Config.Theme.animationDurationNormal
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Config.Theme.animationDurationNormal
                easing.type: Easing.OutCubic
            }
        }
    }
}
