//@ pragma DefaultEnv QS_NO_RELOAD_POPUP=1
//@ pragma DefaultEnv QS_DROP_EXPENSIVE_FONTS=1
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded
//@ pragma DefaultEnv QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import QtQuick

import qs.app.shell as AppShell
import qs.app.notifications as Notifications
import qs.app.drawers as Drawers
import qs.app.lantern as Lantern

ShellRoot {
    settings.watchFiles: true

    Variants {
        model: Quickshell.screens

        delegate: AppShell.ScreenShell {
            required property ShellScreen modelData
            screen: modelData
        }
    }

    Drawers.Drawers {}
    Lantern.Lantern {}
    Notifications.NotificationDaemon {}
}
