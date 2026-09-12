pragma Singleton

import Quickshell
import QtQml
import qs.services as Services

Singleton {
    id: root

    readonly property string label: Services.Niri.layoutLabel

    function switchNext() {
        Services.Niri.switchLayout();
    }
}
