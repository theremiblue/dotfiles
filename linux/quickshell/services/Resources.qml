pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root

    readonly property string metricsCommandPath: resolvedPath("../scripts/functions/resource-metrics")

    property bool refreshing: false
    property real cpuPercent: 0
    property real memoryPercent: 0
    property real diskPercent: 0
    property string cpuText: "0%"
    property string memoryText: "0%"
    property string memoryDetail: "Unavailable"
    property string networkDownValue: "0"
    property string networkDownUnit: "B/s"
    property string networkUpValue: "0"
    property string networkUpUnit: "B/s"
    property string networkDownTotalValue: "0"
    property string networkDownTotalUnit: "B"
    property string networkUpTotalValue: "0"
    property string networkUpTotalUnit: "B"
    property string diskText: "0%"
    property string diskDetail: "Unavailable"
    property string error: ""

    property real previousCpuTotal: -1
    property real previousCpuIdle: -1
    property real previousNetworkRx: -1
    property real previousNetworkTx: -1
    property real previousNetworkTime: -1

    function clampPercent(value) {
        return Math.max(0, Math.min(100, value));
    }

    function percentText(value) {
        return Math.round(clampPercent(value)) + "%";
    }

    function formatBytes(bytes) {
        const units = ["B", "KiB", "MiB", "GiB", "TiB"];
        let value = Math.max(0, Number(bytes) || 0);
        let unit = 0;

        while (value >= 1024 && unit < units.length - 1) {
            value /= 1024;
            unit += 1;
        }

        const precision = unit === 0 || value >= 10 ? 0 : 1;
        return value.toFixed(precision) + " " + units[unit];
    }

    function formatBytesParts(bytes, suffix) {
        const units = ["B", "KiB", "MiB", "GiB", "TiB"];
        let value = Math.max(0, Number(bytes) || 0);
        let unit = 0;

        while (value >= 1024 && unit < units.length - 1) {
            value /= 1024;
            unit += 1;
        }

        const precision = unit === 0 || value >= 10 ? 0 : 1;
        return {
            value: value.toFixed(precision),
            unit: units[unit] + suffix
        };
    }

    function setNetworkRate(direction, bytes) {
        const parts = formatBytesParts(bytes, "/s");

        if (direction === "down") {
            networkDownValue = parts.value;
            networkDownUnit = parts.unit;
            return;
        }

        networkUpValue = parts.value;
        networkUpUnit = parts.unit;
    }

    function setNetworkTotal(direction, bytes) {
        const parts = formatBytesParts(bytes, "");

        if (direction === "down") {
            networkDownTotalValue = parts.value;
            networkDownTotalUnit = parts.unit;
            return;
        }

        networkUpTotalValue = parts.value;
        networkUpTotalUnit = parts.unit;
    }

    function resolvedPath(relativePath) {
        const url = String(Qt.resolvedUrl(relativePath));
        return decodeURIComponent(url.replace(/^file:\/\//, ""));
    }

    function parseMetrics(output) {
        const lines = output.trim().split("\n");
        const now = Date.now();

        for (const line of lines) {
            const parts = line.trim().split(/\s+/);
            if (parts.length < 2) {
                continue;
            }

            if (parts[0] === "cpu" && parts.length >= 3) {
                const total = Number(parts[1]);
                const idle = Number(parts[2]);

                if (previousCpuTotal >= 0 && total > previousCpuTotal) {
                    const totalDelta = total - previousCpuTotal;
                    const idleDelta = idle - previousCpuIdle;
                    cpuPercent = clampPercent((1 - idleDelta / totalDelta) * 100);
                    cpuText = percentText(cpuPercent);
                }

                previousCpuTotal = total;
                previousCpuIdle = idle;
            } else if (parts[0] === "mem" && parts.length >= 3) {
                const totalBytes = Number(parts[1]) * 1024;
                const availableBytes = Number(parts[2]) * 1024;
                const usedBytes = Math.max(0, totalBytes - availableBytes);

                if (totalBytes > 0) {
                    memoryPercent = clampPercent(usedBytes / totalBytes * 100);
                    memoryText = percentText(memoryPercent);
                    memoryDetail = formatBytes(usedBytes) + " / " + formatBytes(totalBytes);
                }
            } else if (parts[0] === "net" && parts.length >= 3) {
                const rx = Number(parts[1]);
                const tx = Number(parts[2]);

                if (previousNetworkTime > 0 && now > previousNetworkTime) {
                    const seconds = (now - previousNetworkTime) / 1000;
                    const rxRate = Math.max(0, (rx - previousNetworkRx) / seconds);
                    const txRate = Math.max(0, (tx - previousNetworkTx) / seconds);
                    setNetworkRate("down", rxRate);
                    setNetworkRate("up", txRate);
                }

                setNetworkTotal("down", rx);
                setNetworkTotal("up", tx);
                previousNetworkRx = rx;
                previousNetworkTx = tx;
                previousNetworkTime = now;
            } else if (parts[0] === "disk" && parts.length >= 4) {
                const percent = Number(parts[1]);
                const usedBytes = Number(parts[2]) * 1024;
                const totalBytes = Number(parts[3]) * 1024;

                diskPercent = clampPercent(percent);
                diskText = percentText(diskPercent);
                diskDetail = formatBytes(usedBytes) + " / " + formatBytes(totalBytes) + " on /";
            }
        }
    }

    function refresh() {
        if (refreshing) {
            return;
        }

        refreshing = true;
        const proc = commandProcess.createObject(root);
        proc.callback = result => {
            refreshing = false;

            if (!result.success) {
                error = "Could not read resource usage";
                return;
            }

            error = "";
            parseMetrics(result.output);
        };
        proc.exec([metricsCommandPath]);
    }

    Component.onCompleted: refresh()

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: root.refresh()
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
