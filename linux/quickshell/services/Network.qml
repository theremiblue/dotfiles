pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root

    readonly property string typeNone: "none"
    readonly property string typeWifi: "wifi"
    readonly property string typeEthernet: "ethernet"

    property bool connected: false
    property bool ethernetConnected: false
    property bool wifiConnected: false
    property bool wifiEnabled: true
    property bool wifiScanning: false
    property string activeType: typeNone
    property string activeInterface: ""
    property string activeConnection: ""
    property string wifiInterface: ""
    property string wifiConnection: ""
    property string wifiState: ""
    property string wifiConnectingSsid: ""
    property string wifiError: ""
    property var wifiNetworks: []
    property string ethernetInterface: ""
    property string ethernetConnection: ""
    property string ethernetState: ""
    property string ethernetAddress: ""
    property string ethernetGateway: ""
    property string ethernetDns: ""
    property string ethernetMac: ""
    property string ethernetMtu: ""
    property string ethernetSpeed: ""

    function isConnectedState(state) {
        if (!state || state.length === 0) {
            return false;
        }

        return state === "connected" || state.startsWith("connected");
    }

    function splitNmcliLine(line) {
        const parts = [];
        let current = "";
        let escaped = false;

        for (let i = 0; i < line.length; i++) {
            const character = line[i];

            if (escaped) {
                current += character;
                escaped = false;
                continue;
            }

            if (character === "\\") {
                escaped = true;
                continue;
            }

            if (character === ":") {
                parts.push(current);
                current = "";
                continue;
            }

            current += character;
        }

        if (escaped) {
            current += "\\";
        }

        parts.push(current);
        return parts;
    }

    function parseDeviceStatus(output) {
        const lines = output.trim().split("\n");
        let ethernet = null;
        let wifi = null;

        for (const line of lines) {
            const parts = splitNmcliLine(line);
            if (parts.length < 4) {
                continue;
            }

            const item = {
                device: parts[0] || "",
                type: parts[1] || "",
                state: parts[2] || "",
                connection: parts.slice(3).join(":")
            };

            if (!isConnectedState(item.state)) {
                continue;
            }

            if (item.type === typeEthernet && ethernet === null) {
                ethernet = item;
            }

            if (item.type === typeWifi && wifi === null) {
                wifi = item;
            }
        }

        setWifiDevice(wifi);
        setEthernetDevice(ethernet);
        setActiveDevice(ethernet || wifi);
    }

    function clearEthernetDetails() {
        ethernetConnected = false;
        ethernetInterface = "";
        ethernetConnection = "";
        ethernetState = "";
        ethernetAddress = "";
        ethernetGateway = "";
        ethernetDns = "";
        ethernetMac = "";
        ethernetMtu = "";
        ethernetSpeed = "";
    }

    function setEthernetDevice(device) {
        if (device === null) {
            clearEthernetDetails();
            return;
        }

        ethernetConnected = true;
        ethernetInterface = device.device;
        ethernetConnection = device.connection;
        ethernetState = device.state;
        ethernetAddress = "";
        ethernetGateway = "";
        ethernetDns = "";
        ethernetMac = "";
        ethernetMtu = "";
        ethernetSpeed = "";
        refreshEthernetDetails(device.device);
    }

    function clearWifiDetails() {
        wifiConnected = false;
        wifiInterface = "";
        wifiConnection = "";
        wifiState = "";
    }

    function setWifiDevice(device) {
        if (device === null) {
            clearWifiDetails();
            return;
        }

        wifiConnected = true;
        wifiInterface = device.device;
        wifiConnection = device.connection;
        wifiState = device.state;
    }

    function setActiveDevice(device) {
        if (device === null) {
            connected = false;
            wifiConnected = false;
            activeType = typeNone;
            activeInterface = "";
            activeConnection = "";
            return;
        }

        connected = true;
        activeType = device.type;
        activeInterface = device.device;
        activeConnection = device.connection;
    }

    function valueAfterColon(line) {
        const parts = splitNmcliLine(line);

        if (parts.length < 2) {
            return "";
        }

        parts.shift();
        return parts.join(":");
    }

    function keyBeforeColon(line) {
        const parts = splitNmcliLine(line);

        if (parts.length === 0) {
            return line;
        }

        return parts[0];
    }

    function readableState(state) {
        const match = state.match(/\((.*)\)$/);

        if (match && match.length > 1) {
            return match[1];
        }

        return state;
    }

    function parseEthernetDetails(output, device) {
        const lines = output.trim().split("\n");
        const dns = [];
        let address = "";

        for (const line of lines) {
            if (line.length === 0) {
                continue;
            }

            const key = keyBeforeColon(line);
            const value = valueAfterColon(line);

            if (key === "GENERAL.DEVICE") {
                ethernetInterface = value;
            } else if (key === "GENERAL.CONNECTION") {
                ethernetConnection = value;
            } else if (key === "GENERAL.STATE") {
                ethernetState = readableState(value);
            } else if (key === "GENERAL.HWADDR") {
                ethernetMac = value;
            } else if (key === "GENERAL.MTU") {
                ethernetMtu = value;
            } else if (key === "GENERAL.SPEED" || key === "CAPABILITIES.SPEED") {
                ethernetSpeed = value;
            } else if (key.startsWith("IP4.ADDRESS") && address.length === 0) {
                address = value;
            } else if (key === "IP4.GATEWAY") {
                ethernetGateway = value;
            } else if (key.startsWith("IP4.DNS")) {
                dns.push(value);
            }
        }

        ethernetAddress = address;
        ethernetDns = dns.join(", ");
    }

    function refreshEthernetDetails(device) {
        if (!device || device.length === 0) {
            return;
        }

        run(["-t", "device", "show", device], result => {
            if (result.success && ethernetInterface === device) {
                parseEthernetDetails(result.output, device);
            }
        });
    }

    function refresh() {
        run(["-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device", "status"], result => {
            if (result.success) {
                parseDeviceStatus(result.output);
            } else {
                clearWifiDetails();
                clearEthernetDetails();
                setActiveDevice(null);
            }
        });

        run(["radio", "wifi"], result => {
            if (result.success) {
                wifiEnabled = result.output.trim() === "enabled";
            }
        });
    }

    function setWifiEnabled(enabled) {
        const state = enabled ? "on" : "off";
        run(["radio", "wifi", state], result => {
            refresh();

            if (enabled) {
                scanWifi();
            } else {
                wifiNetworks = [];
            }
        });
    }

    function toggleWifi() {
        setWifiEnabled(!wifiEnabled);
    }

    function parseWifiList(output) {
        const bySsid = {};
        const lines = output.trim().split("\n");

        for (const line of lines) {
            if (line.length === 0) {
                continue;
            }

            const parts = splitNmcliLine(line);
            if (parts.length < 4) {
                continue;
            }

            const ssid = parts[1] || "";
            if (ssid.length === 0) {
                continue;
            }

            const signal = Number(parts[2] || "0");
            const item = {
                inUse: (parts[0] || "") === "*",
                ssid,
                signal: Number.isNaN(signal) ? 0 : signal,
                security: parts.slice(3).join(":"),
            };

            const existing = bySsid[ssid];
            if (!existing || item.inUse || item.signal > existing.signal) {
                bySsid[ssid] = item;
            }
        }

        wifiNetworks = Object.values(bySsid).sort((left, right) => {
            if (left.inUse !== right.inUse) {
                return left.inUse ? -1 : 1;
            }

            return right.signal - left.signal;
        });
    }

    function scanWifi() {
        if (!wifiEnabled || wifiScanning) {
            return;
        }

        wifiScanning = true;
        wifiError = "";
        run(["-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "device", "wifi", "list", "--rescan", "yes"], result => {
            wifiScanning = false;

            if (result.success) {
                parseWifiList(result.output);
                return;
            }

            wifiError = "Could not scan Wi-Fi networks";
        });
    }

    function connectWifi(ssid, password) {
        if (!ssid || ssid.length === 0 || wifiConnectingSsid.length > 0) {
            return;
        }

        const args = ["device", "wifi", "connect", ssid];
        if (password && password.length > 0) {
            args.push("password", password);
        }

        wifiError = "";
        wifiConnectingSsid = ssid;
        run(args, result => {
            wifiConnectingSsid = "";

            if (!result.success) {
                wifiError = "Could not connect to " + ssid;
            }

            refresh();
            scanWifi();
        });
    }

    function disconnectWifi() {
        if (!wifiInterface || wifiInterface.length === 0) {
            return;
        }

        run(["device", "disconnect", wifiInterface], result => {
            refresh();
            scanWifi();
        });
    }

    function run(args, callback) {
        const proc = commandProcess.createObject(root);
        proc.callback = callback;
        proc.exec(["nmcli", ...args]);
    }

    Component.onCompleted: refresh()

    Process {
        id: monitor

        running: true
        command: ["nmcli", "monitor"]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })

        stdout: SplitParser {
            onRead: root.refresh()
        }
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
