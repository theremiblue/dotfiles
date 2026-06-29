import Quickshell

Scope {
    id: root

    required property ShellScreen screen
    required property var drawerLayer

    ContentWindow {
        id: content

        targetScreen: root.screen
        drawerLayer: root.drawerLayer
    }
}
