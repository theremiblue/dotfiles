import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    drawerType: Services.Drawers.sound
    drawerSize: UIPrimitives.Drawer.Size.Small
    drawerPosition: UIPrimitives.Drawer.Position.AnchorCenter
    borderColor: Services.Sound.outputMuted ? Config.Theme.barMuted : Config.Theme.base0C

    component VolumeSlider: MouseArea {
        id: slider

        property int value: 0
        signal moved(int value)

        function valueForX(x) {
            if (width <= 0) {
                return 0;
            }

            return Math.round(Math.max(0, Math.min(1, x / width)) * 100);
        }

        Layout.fillWidth: true
        Layout.preferredHeight: 28
        enabled: Services.Sound.outputReady
        opacity: enabled ? 1 : 0.45
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            height: 4
            radius: height / 2
            color: Config.Theme.base02
        }

        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            width: Math.round(parent.width * slider.value / 100)
            height: 4
            radius: height / 2
            color: Services.Sound.outputMuted ? Config.Theme.barMuted : Config.Theme.base0C

            Behavior on width {
                NumberAnimation {
                    duration: Config.Theme.animationDurationShort
                    easing.type: Easing.OutCubic
                }
            }
        }

        Rectangle {
            width: 12
            height: 12
            radius: height / 2
            x: Math.round((slider.width - width) * slider.value / 100)
            anchors.verticalCenter: parent.verticalCenter
            color: Config.Theme.base07
            border.color: Services.Sound.outputMuted ? Config.Theme.barMuted : Config.Theme.base0C
            border.width: 1

            Behavior on x {
                NumberAnimation {
                    duration: Config.Theme.animationDurationShort
                    easing.type: Easing.OutCubic
                }
            }
        }

        onClicked: event => slider.moved(slider.valueForX(event.x))
        onPositionChanged: event => {
            if (pressed) {
                slider.moved(slider.valueForX(event.x));
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.Icon {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26

                source: Config.Theme.tablerIcon(Services.Sound.iconName())
                implicitSize: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Sound"
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: Services.Sound.outputStatus()
                    color: Services.Sound.outputMuted ? Config.Theme.barMuted : Config.Theme.base0C
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing * 2

            UIPrimitives.AppText {
                text: "Muted"
                color: Config.Theme.barForeground
                horizontalAlignment: Text.AlignLeft
            }

            Item {
                Layout.fillWidth: true
            }

            UIPrimitives.Switch {
                checked: Services.Sound.outputMuted
                enabled: Services.Sound.outputReady
                opacity: enabled ? 1 : 0.45
                onToggled: checked => Services.Sound.setOutputMuted(checked)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            RowLayout {
                Layout.fillWidth: true

                UIPrimitives.AppText {
                    text: "Volume"
                    color: Config.Theme.barForeground
                    horizontalAlignment: Text.AlignLeft
                }

                Item {
                    Layout.fillWidth: true
                }

                UIPrimitives.AppText {
                    text: Services.Sound.outputVolumePercent + "%"
                    color: Config.Theme.barMuted
                    font.family: Config.Theme.monospaceFontFamily
                    horizontalAlignment: Text.AlignRight
                }
            }

            VolumeSlider {
                value: Services.Sound.outputVolumePercent
                onMoved: value => Services.Sound.setOutputVolume(value)
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Controls.DetailRow {
                name: "Output"
                value: Services.Sound.outputName
            }

            Controls.DetailRow {
                name: "Input"
                value: Services.Sound.inputName
            }
        }
    }
}
