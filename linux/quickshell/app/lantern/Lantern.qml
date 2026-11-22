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
    readonly property int panelWidth: Math.min(Math.round(Config.Theme.fontSize * 38), Math.round(screen.width * 0.48))
    readonly property int panelTop: Math.round(screen.height * 0.16)
    readonly property int appIconSize: Math.round(Config.Theme.fontSize * 2)
    readonly property real dimOpacity: 0.45
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

        Rectangle {
            id: frame

            width: root.panelWidth
            height: Math.min(screen.height - root.panelTop - root.edgeMargin, content.implicitHeight)
            x: Math.round((screen.width - width) / 2)
            y: root.panelTop
            radius: Config.Theme.radius
            color: Config.Theme.base00
            border.color: Config.Theme.barBorder
            border.width: 1
            clip: true

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
            }

            ColumnLayout {
                id: content

                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(44, searchInput.implicitHeight + Config.Theme.padding * 4)

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Config.Theme.padding * 2.5
                        anchors.rightMargin: Config.Theme.padding * 2.5
                        spacing: Config.Theme.spacing * 1.5

                        UIPrimitives.Icon {
                            Layout.preferredWidth: Config.Theme.inlineIconSize
                            Layout.preferredHeight: Config.Theme.inlineIconSize

                            source: Config.Theme.tablerIcon("search")
                            implicitSize: Config.Theme.inlineIconSize
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            UIPrimitives.AppText {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                visible: searchInput.text.length === 0
                                text: "Search applications..."
                                color: Config.Theme.barMuted
                                font.pixelSize: Config.Theme.fontSize + 1
                                horizontalAlignment: Text.AlignLeft
                            }

                            TextInput {
                                id: searchInput

                                anchors.fill: parent

                                color: Config.Theme.base06
                                selectionColor: Config.Theme.base0D
                                selectedTextColor: Config.Theme.base00
                                font.family: Config.Theme.fontFamily
                                font.pixelSize: Config.Theme.fontSize + 1
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

                        UIPrimitives.AppText {
                            text: "ESC"
                            color: Config.Theme.barMuted
                            font.family: Config.Theme.monospaceFontFamily
                            font.pixelSize: Config.Theme.smallFontSize
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        height: 1
                        color: Config.Theme.barBorder
                    }
                }

                UIPrimitives.AppText {
                    Layout.fillWidth: true
                    Layout.margins: Config.Theme.padding * 2

                    visible: Services.Lantern.error.length > 0
                    text: Services.Lantern.error
                    color: Config.Theme.base08
                    horizontalAlignment: Text.AlignLeft
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: root.results.length === 0
                        ? emptyState.implicitHeight + Config.Theme.padding * 8
                        : resultsList.implicitHeight

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
                            spacing: 0

                            Repeater {
                                id: resultsRepeater

                                model: root.results

                                delegate: MouseArea {
                                    id: result

                                    required property int index
                                    required property var modelData

                                    readonly property bool selected: root.selectedIndex === result.index

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Math.max(root.appIconSize, resultTextColumn.implicitHeight) + Config.Theme.padding * 3
                                    implicitHeight: Layout.preferredHeight

                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: Services.Lantern.launch(modelData)

                                    Rectangle {
                                        anchors.fill: parent
                                        color: result.selected
                                            ? Config.Theme.base01
                                            : result.containsMouse ? "#232529" : "transparent"
                                    }

                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom

                                        visible: result.selected
                                        width: 2
                                        color: Config.Theme.base0D
                                    }

                                    Rectangle {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top

                                        visible: result.index > 0
                                        height: 1
                                        color: Config.Theme.hairlineSubtle
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Config.Theme.padding * 2.5
                                        anchors.rightMargin: Config.Theme.padding * 2.5
                                        anchors.topMargin: Config.Theme.padding * 1.5
                                        anchors.bottomMargin: Config.Theme.padding * 1.5
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
                                                color: result.selected ? Config.Theme.base07 : Config.Theme.barForeground
                                                font.pixelSize: Config.Theme.fontSize
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
