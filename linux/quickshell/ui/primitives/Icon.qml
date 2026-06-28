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
        sourceSize.width: root.width
        sourceSize.height: root.height
        fillMode: Image.PreserveAspectFit
        asynchronous: root.asynchronous
        mipmap: false
        smooth: true
    }
}
