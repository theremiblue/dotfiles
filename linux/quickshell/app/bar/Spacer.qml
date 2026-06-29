import QtQuick

import qs.config as Config

Item {
    property int size: Config.Theme.spacing

    implicitWidth: size
    implicitHeight: size
}
