import Quickshell

Scope {
    id: root

    required property ShellScreen screen

    ContentWindow {
        id: content
        targetScreen: root.screen
    }
}
