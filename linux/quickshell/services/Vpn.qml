pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

import qs.config as Config

Singleton {
    id: root

    property bool available: true
    property bool connected: false
    property bool refreshing: false
    property bool busy: false
    property string status: "Unknown"
    property string hostname: ""
    property string ip: ""
    property string country: ""
    property string city: ""
    property string technology: ""
    property string error: ""
    property string defaultCountry: "us"

    readonly property string providerName: Config.Programs.vpnProviderName
    readonly property string lastServer: props.lastServer

    function command(args) {
        return Config.Programs.vpnCliCommand.concat(args);
    }

    function clearDetails() {
        hostname = "";
        ip = "";
        country = "";
        city = "";
        technology = "";
    }

    function serverArgument(value) {
        return value.split(".")[0].trim();
    }

    function parseStatus(output) {
        const lines = output.trim().split("\n");
        let parsedStatus = "";

        clearDetails();

        for (const line of lines) {
            const index = line.indexOf(":");

            if (index < 0) {
                continue;
            }

            const key = line.slice(0, index).trim().toLowerCase();
            const value = line.slice(index + 1).trim();

            if (key === "status") {
                parsedStatus = value;
            } else if (key === "hostname" || key === "server") {
                hostname = value;
            } else if (key === "ip") {
                ip = value;
            } else if (key === "country") {
                country = value;
            } else if (key === "city") {
                city = value;
            } else if (key === "current technology" || key === "technology") {
                technology = value;
            }
        }

        status = parsedStatus.length > 0 ? parsedStatus : "Unknown";
        connected = status.toLowerCase() === "connected";

        if (connected && hostname.length > 0) {
            props.lastServer = serverArgument(hostname);
        }
    }

    function failureText(result, fallback) {
        const errorOutput = result.errorOutput.trim();
        const output = result.output.trim();

        if (errorOutput.length > 0) {
            return errorOutput;
        }

        if (output.length > 0) {
            return output;
        }

        return fallback;
    }

    function refresh() {
        if (refreshing) {
            return;
        }

        refreshing = true;
        run(["status"], result => {
            refreshing = false;

            if (!result.success) {
                available = false;
                connected = false;
                status = "Unavailable";
                clearDetails();
                error = failureText(result, "Could not read NordVPN status");
                return;
            }

            available = true;
            error = "";
            parseStatus(result.output);
        });
    }

    function setConnected(enabled) {
        if (busy) {
            return;
        }

        busy = true;

        const args = enabled
            ? ["connect", props.lastServer.length > 0 ? props.lastServer : defaultCountry]
            : ["disconnect"];

        run(args, result => {
            busy = false;

            if (!result.success) {
                error = failureText(result, "Could not " + (enabled ? "connect" : "disconnect") + " NordVPN");
            }

            refresh();
        });
    }

    function toggle() {
        setConnected(!connected);
    }

    function openApplication() {
        Quickshell.execDetached(Config.Programs.vpnApplicationCommand);
    }

    function run(args, callback) {
        const proc = commandProcess.createObject(root);
        proc.callback = callback;
        proc.exec(command(args));
    }

    Component.onCompleted: refresh()

    PersistentProperties {
        id: props

        property string lastServer: ""

        reloadableId: "vpn"
    }

    Timer {
        interval: 15000
        running: true
        repeat: true

        onTriggered: root.refresh()
    }

    Component {
        id: commandProcess

        Process {
            id: proc

            property var callback: null

            environment: ({
                LANG: "C.UTF-8",
                LC_ALL: "C.UTF-8"
            })

            stdout: StdioCollector {
                id: stdoutCollector
            }

            stderr: StdioCollector {
                id: stderrCollector
            }

            onExited: code => {
                if (proc.callback) {
                    proc.callback({
                        success: code === 0,
                        output: stdoutCollector.text,
                        errorOutput: stderrCollector.text
                    });
                }

                proc.destroy();
            }
        }
    }
}
