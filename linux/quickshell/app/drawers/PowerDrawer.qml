import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.config as Config
import qs.services as Services
import qs.ui.controls as Controls

ScratchDrawer {
    id: root

    function hideAndRun(command) {
        root.dismiss();
        Quickshell.execDetached(command);
    }

    function logout() {
        root.dismiss();
        Services.Niri.logout();
    }

    drawerType: Services.Drawers.power
    drawerSize: ScratchDrawer.Size.Small
    drawerPosition: ScratchDrawer.Position.ScreenCenter
    backgroundColor: Config.Theme.base01
    borderColor: Config.Theme.base0E

    RowLayout {
        anchors.fill: parent
        spacing: Config.Theme.spacing

        Controls.ActionTile {
            iconSource: Config.Theme.tablerIcon("logout")
            label: "Logout"
            accentColor: Config.Theme.base0A

            onTriggered: root.logout()
        }

        Controls.ActionTile {
            iconSource: Config.Theme.tablerIcon("reboot")
            label: "Reboot"
            accentColor: Config.Theme.base09

            onTriggered: root.hideAndRun(["systemctl", "reboot"])
        }

        Controls.ActionTile {
            iconSource: Config.Theme.tablerIcon("power")
            label: "Turn Off"
            accentColor: Config.Theme.base08

            onTriggered: root.hideAndRun(["systemctl", "poweroff"])
        }
    }
}
