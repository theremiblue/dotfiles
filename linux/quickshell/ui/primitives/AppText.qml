import QtQuick
import qs.config as Config

Text {
    color: Config.Theme.barForeground
    font.family: Config.Theme.fontFamily
    font.pixelSize: Config.Theme.fontSize
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
