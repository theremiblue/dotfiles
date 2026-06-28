import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

UIPrimitives.Drawer {
    id: root

    drawerSize: UIPrimitives.Drawer.Size.Large
    drawerPosition: UIPrimitives.Drawer.Position.ScreenHorizontalCenter
    borderColor: Config.Theme.base0D

    component MetricCard: Rectangle {
        id: card

        property string title: ""
        property string value: ""
        property string detail: ""
        property real progress: 0
        property color accentColor: Config.Theme.base0D
        property bool showProgress: true

        Layout.fillWidth: true
        Layout.preferredHeight: 86
        implicitHeight: 86
        radius: 6
        color: Config.Theme.base00
        border.color: Config.Theme.barBorder
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.Theme.padding * 2
            spacing: Config.Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Theme.spacing

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: card.title
                    color: Config.Theme.barMuted
                    font.pixelSize: Config.Theme.smallFontSize
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }

                UIPrimitives.AppText {
                    text: card.value
                    color: card.accentColor
                    font.family: Config.Theme.monospaceFontFamily
                    horizontalAlignment: Text.AlignRight
                }
            }

            UIPrimitives.AppText {
                Layout.fillWidth: true

                text: card.detail
                color: Config.Theme.barForeground
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 6

                visible: card.showProgress
                radius: height / 2
                color: Config.Theme.base02
                clip: true

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    width: parent.width * Math.max(0, Math.min(1, card.progress))
                    color: card.accentColor
                }
            }
        }
    }

    component NetworkValue: Item {
        id: networkValue

        property url iconSource: ""
        property string value: "0"
        property string unit: "B/s"
        property color valueColor: Config.Theme.base0C

        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: Math.max(icon.implicitHeight, label.implicitHeight)

        RowLayout {
            anchors.centerIn: parent
            spacing: Config.Theme.spacing

            UIPrimitives.Icon {
                id: icon

                Layout.preferredWidth: 16
                Layout.preferredHeight: 16

                source: networkValue.iconSource
                implicitSize: 16
            }

            UIPrimitives.AppText {
                id: label

                Layout.preferredWidth: stableNumberWidth.advanceWidth

                text: networkValue.value
                color: networkValue.valueColor
                font.family: Config.Theme.monospaceFontFamily
                horizontalAlignment: Text.AlignRight
            }

            UIPrimitives.AppText {
                id: unitLabel

                Layout.preferredWidth: stableUnitWidth.advanceWidth

                text: networkValue.unit
                color: networkValue.valueColor
                font.family: Config.Theme.monospaceFontFamily
                horizontalAlignment: Text.AlignLeft
            }
        }

        TextMetrics {
            id: stableNumberWidth

            font: label.font
            text: "1023"
        }

        TextMetrics {
            id: stableUnitWidth

            font: unitLabel.font
            text: "TiB/s"
        }
    }

    component NetworkCard: Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 86
        implicitHeight: 86
        radius: 6
        color: Config.Theme.base00
        border.color: Config.Theme.barBorder
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.Theme.padding * 2
            spacing: Config.Theme.spacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Theme.spacing

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Network"
                    color: Config.Theme.barMuted
                    font.pixelSize: Config.Theme.smallFontSize
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }

                UIPrimitives.AppText {
                    text: "I/O"
                    color: Config.Theme.base0C
                    font.family: Config.Theme.monospaceFontFamily
                    horizontalAlignment: Text.AlignRight
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Config.Theme.spacing * 2

                NetworkValue {
                    iconSource: Config.Theme.tablerIcon("arrow-down")
                    value: Services.Resources.networkDownValue
                    unit: Services.Resources.networkDownUnit
                    valueColor: Config.Theme.base0C
                }

                NetworkValue {
                    iconSource: Config.Theme.tablerIcon("arrow-up")
                    value: Services.Resources.networkUpValue
                    unit: Services.Resources.networkUpUnit
                    valueColor: Config.Theme.base0A
                }
            }
        }
    }

    Component.onCompleted: {
        Services.Resources.refresh();

        if (Services.Drawers.mainVisible) {
            root.open();
        }
    }

    onDismissed: Services.Drawers.hideMain()

    Connections {
        target: Services.Drawers

        function onMainVisibleChanged() {
            if (Services.Drawers.mainVisible) {
                root.open();
                return;
            }

            root.close();
        }
    }

    UIPrimitives.Tabs {
        width: parent.width
        tabs: ["Resource monitor"]

        ColumnLayout {
            width: parent.width
            spacing: Config.Theme.spacing * 2

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Theme.spacing

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    text: "Resource monitor"
                    color: Config.Theme.base06
                    font.pixelSize: Config.Theme.fontSize + 2
                    horizontalAlignment: Text.AlignLeft
                }
            }

            UIPrimitives.AppText {
                Layout.fillWidth: true

                visible: Services.Resources.error.length > 0
                text: Services.Resources.error
                color: Config.Theme.base08
                horizontalAlignment: Text.AlignLeft
            }

            GridLayout {
                Layout.fillWidth: true
                columns: root.implicitWidth >= 900 ? 4 : root.implicitWidth >= 520 ? 2 : 1
                columnSpacing: Config.Theme.spacing * 2
                rowSpacing: Config.Theme.spacing * 2

                MetricCard {
                    title: "CPU"
                    value: Services.Resources.cpuText
                    detail: "Processor usage"
                    progress: Services.Resources.cpuPercent / 100
                    accentColor: Config.Theme.base0B
                }

                MetricCard {
                    title: "RAM"
                    value: Services.Resources.memoryText
                    detail: Services.Resources.memoryDetail
                    progress: Services.Resources.memoryPercent / 100
                    accentColor: Config.Theme.base0A
                }

                NetworkCard {}

                MetricCard {
                    title: "Disk"
                    value: Services.Resources.diskText
                    detail: Services.Resources.diskDetail
                    progress: Services.Resources.diskPercent / 100
                    accentColor: Config.Theme.base0D
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Theme.spacing * 2

                NetworkValue {
                    iconSource: Config.Theme.tablerIcon("arrow-down")
                    value: Services.Resources.networkDownTotalValue
                    unit: Services.Resources.networkDownTotalUnit
                    valueColor: Config.Theme.barMuted
                }

                NetworkValue {
                    iconSource: Config.Theme.tablerIcon("arrow-up")
                    value: Services.Resources.networkUpTotalValue
                    unit: Services.Resources.networkUpTotalUnit
                    valueColor: Config.Theme.barMuted
                }
            }
        }
    }
}
