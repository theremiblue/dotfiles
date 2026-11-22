import QtQuick
import QtQuick.Layouts

import qs.config as Config

Item {
    id: root

    default property alias content: contentHost.data
    property alias rightContent: rightContentLayout.data

    property var tabs: []
    property int currentIndex: 0

    implicitWidth: tabsLayout.implicitWidth
    implicitHeight: tabsLayout.implicitHeight

    ColumnLayout {
        id: tabsLayout

        width: root.width
        spacing: Config.Theme.spacing * 2

        RowLayout {
            Layout.fillWidth: true
            spacing: Config.Theme.spacing

            Repeater {
                model: root.tabs

                MouseArea {
                    id: tabButton

                    required property int index
                    required property string modelData

                    readonly property bool active: root.currentIndex === index

                    Layout.preferredWidth: tabText.implicitWidth + Config.Theme.padding * 3
                    Layout.preferredHeight: Math.max(Config.Theme.controlHeight, tabText.implicitHeight + Config.Theme.padding * 2)
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    Rectangle {
                        anchors.fill: parent

                        radius: Config.Theme.radius
                        color: tabButton.containsMouse ? Config.Theme.base01 : "transparent"

                        Behavior on color {
                            ColorAnimation {
                                duration: Config.Theme.animationDurationShort
                            }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        visible: tabButton.active
                        height: 2
                        color: Config.Theme.base0D
                    }

                    AppText {
                        id: tabText

                        anchors.centerIn: parent

                        text: tabButton.modelData
                        color: tabButton.active ? Config.Theme.base06 : Config.Theme.barMuted
                        font.pixelSize: Config.Theme.fontSize
                        font.weight: tabButton.active ? Font.Medium : Font.Normal
                    }

                    onClicked: root.currentIndex = index
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                id: rightContentLayout

                Layout.preferredHeight: Config.Theme.controlHeight
                Layout.alignment: Qt.AlignVCenter
                spacing: Config.Theme.spacing
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1

            color: Config.Theme.barBorder
        }

        Item {
            id: contentHost

            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(0, childrenRect.height)
            implicitHeight: Layout.preferredHeight
        }
    }
}
