import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.primitives as UIPrimitives

PanelWindow {
    id: root

    readonly property int edgeMargin: Config.Theme.padding * 4
    readonly property int panelWidth: Math.min(Math.round(Config.Theme.fontSize * 40), Math.round(screen.width * 0.48))
    readonly property int panelTop: Math.round(screen.height * 0.16)
    readonly property int appIconSize: Math.round(Config.Theme.fontSize * 2)
    readonly property real dimOpacity: 0.42
    readonly property var results: Services.Lantern.search(searchInput.text)

    function ensureSelectionVisible() {
        const item = resultsRepeater.itemAt(selectedIndex);
        if (!item || resultsFlickable.height <= 0) {
            return;
        }

        if (item.y < resultsFlickable.contentY) {
            resultsFlickable.contentY = item.y;
            return;
        }

        const itemBottom = item.y + item.height;
        const viewBottom = resultsFlickable.contentY + resultsFlickable.height;
        if (itemBottom > viewBottom) {
            resultsFlickable.contentY = itemBottom - resultsFlickable.height;
        }
    }

    function clampSelection() {
        selectedIndex = Math.max(0, Math.min(selectedIndex, results.length - 1));
    }

    function moveSelection(delta) {
        if (results.length === 0) {
            selectedIndex = 0;
            return;
        }

        selectedIndex = (selectedIndex + delta + results.length) % results.length;
    }

    function activateSelection() {
        if (results.length === 0) {
            return;
        }

        Services.Lantern.launch(results[selectedIndex]);
    }

    property int selectedIndex: 0

    visible: Services.Lantern.visible
    implicitWidth: screen.width
    implicitHeight: screen.height
    color: "transparent"
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    focusable: visible

    WlrLayershell.namespace: "quickshell-lantern"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    onVisibleChanged: {
        if (!visible) {
            searchInput.text = "";
            selectedIndex = 0;
            resultsFlickable.contentY = 0;
            return;
        }

        Qt.callLater(() => {
            overlay.forceActiveFocus();
            searchInput.forceActiveFocus();
            searchInput.selectAll();
        });
    }

    onResultsChanged: clampSelection()
    onSelectedIndexChanged: Qt.callLater(ensureSelectionVisible)

    FocusScope {
        id: overlay

        anchors.fill: parent
        focus: root.visible

        Keys.onEscapePressed: event => {
            event.accepted = true;
            Services.Lantern.hide();
        }

        Rectangle {
            id: scrim

            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, root.dimOpacity)
        }

        MouseArea {
            anchors.fill: parent

            onClicked: Services.Lantern.hide()
        }

        UIPrimitives.PanelShadow {
            id: frameShadow

            sourceWidth: frame.width
            sourceHeight: frame.height
            sourceRadius: frame.radius
            x: frame.x - margin
            y: frame.y - margin
        }

        Rectangle {
            id: frame

            width: root.panelWidth
            height: Math.min(screen.height - root.panelTop - root.edgeMargin, content.implicitHeight + Config.Theme.padding * 4)
            x: Math.round((screen.width - width) / 2)
            y: root.panelTop
            radius: 8
            color: Config.Theme.base01
            border.color: Config.Theme.base0D
            border.width: 1
            clip: true

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
            }

            ColumnLayout {
                id: content

                anchors.fill: parent
                anchors.margins: Config.Theme.padding * 2
                spacing: Config.Theme.spacing * 2

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(Config.Theme.controlHeight + Config.Theme.padding, searchInput.implicitHeight + Config.Theme.padding * 2)

                    radius: 6
                    color: Config.Theme.base00
                    border.color: searchInput.activeFocus ? Config.Theme.base0D : Config.Theme.barBorder
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Config.Theme.padding * 3
                        anchors.rightMargin: Config.Theme.padding * 3
                        spacing: Config.Theme.spacing * 2

                        UIPrimitives.Icon {
                            Layout.preferredWidth: Config.Theme.inlineIconSize
                            Layout.preferredHeight: Config.Theme.inlineIconSize

                            source: Config.Theme.tablerIcon("search")
                            implicitSize: Config.Theme.inlineIconSize
                        }

                        TextInput {
                            id: searchInput

                            Layout.fillWidth: true

                            color: Config.Theme.barForeground
                            selectionColor: Config.Theme.base0D
                            selectedTextColor: Config.Theme.base00
                            font.family: Config.Theme.fontFamily
                            font.pixelSize: Config.Theme.fontSize + 6
                            clip: true
                            focus: root.visible
                            verticalAlignment: TextInput.AlignVCenter

                            Keys.onPressed: event => {
                                if (event.key === Qt.Key_Down) {
                                    event.accepted = true;
                                    root.moveSelection(1);
                                } else if (event.key === Qt.Key_Up) {
                                    event.accepted = true;
                                    root.moveSelection(-1);
                                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    event.accepted = true;
                                    root.activateSelection();
                                }
                            }
                        }
                    }
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true

                    visible: Services.Lantern.error.length > 0
                    text: Services.Lantern.error
                    color: Config.Theme.base08
                    horizontalAlignment: Text.AlignLeft
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: Math.max(emptyState.implicitHeight, resultsList.implicitHeight)

                    UIPrimitives.AppText {
                        id: emptyState

                        anchors.centerIn: parent

                        visible: root.results.length === 0 && Services.Lantern.error.length === 0
                        text: Services.Lantern.refreshing ? "Indexing applications" : "No matches"
                        color: Config.Theme.barMuted
                    }

                    Flickable {
                        id: resultsFlickable

                        anchors.fill: parent
                        visible: root.results.length > 0
                        clip: true
                        contentWidth: width
                        contentHeight: resultsList.implicitHeight
                        interactive: contentHeight > height

                        ColumnLayout {
                            id: resultsList

                            width: parent.width
                            spacing: Config.Theme.spacing

                            Repeater {
                                id: resultsRepeater

                                model: root.results

                                delegate: MouseArea {
                                    id: result

                                    required property int index
                                    required property var modelData

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Math.max(root.appIconSize, resultTextColumn.implicitHeight) + Config.Theme.padding * 2
                                    implicitHeight: Layout.preferredHeight

                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: Services.Lantern.launch(modelData)

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 6
                                        color: root.selectedIndex === result.index ? Config.Theme.base02 : "transparent"
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Config.Theme.padding * 3
                                        anchors.rightMargin: Config.Theme.padding * 3
                                        anchors.topMargin: Config.Theme.padding
                                        anchors.bottomMargin: Config.Theme.padding
                                        spacing: Config.Theme.spacing * 2

                                        UIPrimitives.AppIcon {
                                            Layout.preferredWidth: root.appIconSize
                                            Layout.preferredHeight: root.appIconSize
                                            Layout.alignment: Qt.AlignVCenter

                                            iconSize: root.appIconSize
                                            source: result.modelData.iconSource
                                            label: result.modelData.name
                                        }

                                        ColumnLayout {
                                            id: resultTextColumn

                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                            spacing: 2

                                            UIPrimitives.AppText {
                                                Layout.fillWidth: true

                                                text: result.modelData.name
                                                color: root.selectedIndex === result.index ? Config.Theme.base06 : Config.Theme.barForeground
                                                font.pixelSize: Config.Theme.fontSize + 2
                                                horizontalAlignment: Text.AlignLeft
                                                elide: Text.ElideRight
                                            }

                                            UIPrimitives.AppText {
                                                Layout.fillWidth: true

                                                visible: result.modelData.subtext.length > 0
                                                text: result.modelData.subtext
                                                color: Config.Theme.barMuted
                                                font.pixelSize: Config.Theme.smallFontSize
                                                horizontalAlignment: Text.AlignLeft
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: Config.Theme.animationDurationNormal
                    easing.type: Easing.OutCubic
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
}
