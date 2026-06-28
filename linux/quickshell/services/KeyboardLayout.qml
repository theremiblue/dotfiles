pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQml

Singleton {
    id: root

    property var layouts: []
    property int activeIndex: -1
    property string activeName: ""
    property string label: "??"

    function compactLabel(value) {
        const text = value.trim();

        if (text.length === 0) {
            return "??";
        }

        const region = text.match(/\(([^)]+)\)/);
        if (region && region[1]) {
            return region[1].slice(0, 2).toUpperCase();
        }

        return text.slice(0, 2).toUpperCase();
    }

    function layoutTokenLabel(token) {
        return compactLabel(token.replace(/\(.*\)$/, ""));
    }

    function updateLabel() {
        if (activeIndex >= 0 && activeIndex < layouts.length) {
            label = layoutTokenLabel(layouts[activeIndex]);
            return;
        }

        label = compactLabel(activeName);
    }

    function setLayouts(raw) {
        const parts = raw.split(",").map(part => part.trim()).filter(part => part.length > 0);
        layouts = parts;
        updateLabel();
    }

    function mainKeyboard(devices) {
        const keyboards = devices.keyboards || [];

        if (keyboards.length === 0) {
            return null;
        }

        for (const keyboard of keyboards) {
            if (keyboard.main) {
                return keyboard;
            }
        }

        return keyboards[0];
    }

    function refresh() {
        run(["-j", "getoption", "input:kb_layout"], result => {
            if (!result.success) {
                return;
            }

            try {
                const option = JSON.parse(result.output);
                const raw = (option.str || option.value || "").toString().trim();
                if (raw.length > 0) {
                    setLayouts(raw);
                }
            } catch (error) {}
        });

        refreshActive();
    }

    function refreshActive() {
        run(["-j", "devices"], result => {
            if (!result.success) {
                return;
            }

            try {
                const devices = JSON.parse(result.output);
                const keyboard = mainKeyboard(devices);

                if (keyboard === null) {
                    activeIndex = -1;
                    activeName = "";
                } else {
                    activeIndex = keyboard.active_layout_index === undefined ? -1 : keyboard.active_layout_index;
                    activeName = keyboard.active_keymap || "";

                    if (layouts.length === 0 && keyboard.layout) {
                        setLayouts(keyboard.layout);
                    }
                }

                updateLabel();
            } catch (error) {
                activeIndex = -1;
                activeName = "";
                updateLabel();
            }
        });
    }

    function switchNext() {
        run(["switchxkblayout", "all", "next"], result => {
            refreshActive();
        });
    }

    function run(args, callback) {
        const proc = commandProcess.createObject(root);
        proc.callback = callback;
        proc.exec(["hyprctl", ...args]);
    }

    Component.onCompleted: refresh()

    Connections {
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                root.refreshActive();
            }

            if (event.name === "configreloaded") {
                root.refresh();
            }
        }

        target: Hyprland
    }

    Component {
        id: commandProcess

        Process {
            id: proc

            property var callback: null

            stdout: StdioCollector {
                id: stdoutCollector
            }

            stderr: StdioCollector {}

            onExited: code => {
                if (proc.callback) {
                    proc.callback({
                        success: code === 0,
                        output: stdoutCollector.text
                    });
                }

                proc.destroy();
            }
        }
    }
}
