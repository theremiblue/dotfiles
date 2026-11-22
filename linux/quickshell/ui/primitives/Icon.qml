import QtQuick

Item {
    id: root

    property url source: ""
    property int implicitSize: 16
    property bool asynchronous: true

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    Image {
        anchors.fill: parent
        source: root.source
        sourceSize.width: Math.max(1, Math.round(root.width > 0 ? root.width : root.implicitSize))
        sourceSize.height: Math.max(1, Math.round(root.height > 0 ? root.height : root.implicitSize))
        fillMode: Image.PreserveAspectFit
        asynchronous: root.asynchronous
        mipmap: false
        smooth: true
    }
}
