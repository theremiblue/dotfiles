pragma Singleton

import Quickshell
import Quickshell.Bluetooth as Bluez
import QtQml

import qs.config as Config

Singleton {
    id: root

    readonly property var adapter: Bluez.Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool enabled: available && adapter.enabled
    readonly property bool discovering: available && adapter.discovering
    readonly property bool discoverable: available && adapter.discoverable
    readonly property string adapterName: available ? adapter.name : ""
    readonly property string adapterState: available ? Bluez.BluetoothAdapterState.toString(adapter.state) : "Unavailable"
    readonly property var devices: sortedDevices()

    function sortedDevices() {
        if (!available) {
            return [];
        }

        return adapter.devices.values.slice().sort((left, right) => {
            if (left.connected !== right.connected) {
                return left.connected ? -1 : 1;
            }

            if (left.paired !== right.paired) {
                return left.paired ? -1 : 1;
            }

            return deviceName(left).localeCompare(deviceName(right));
        });
    }

    function connectedDevicesCount() {
        if (!available) {
            return 0;
        }

        return adapter.devices.values.filter(device => device.connected).length;
    }

    function statusText() {
        if (!available) {
            return "Unavailable";
        }

        if (!enabled) {
            return "Off";
        }

        const count = connectedDevicesCount();
        if (count === 1) {
            return "1 connected device";
        }

        if (count > 1) {
            return count + " connected devices";
        }

        return discovering ? "Scanning" : "On";
    }

    function deviceName(device) {
        if (!device) {
            return "Unknown device";
        }

        if (device.name && device.name.length > 0) {
            return device.name;
        }

        if (device.deviceName && device.deviceName.length > 0) {
            return device.deviceName;
        }

        if (device.address && device.address.length > 0) {
            return device.address;
        }

        return "Unknown device";
    }

    function deviceStateText(device) {
        if (!device) {
            return "Unavailable";
        }

        if (device.pairing) {
            return "Pairing";
        }

        const state = Bluez.BluetoothDeviceState.toString(device.state);
        if (state && state.length > 0 && state !== "Disconnected") {
            return state;
        }

        if (device.paired || device.bonded) {
            return "Paired";
        }

        return "Available";
    }

    function deviceDetailText(device) {
        const parts = [];

        if (device.paired || device.bonded) {
            parts.push("paired");
        }

        if (device.trusted) {
            parts.push("trusted");
        }

        if (device.blocked) {
            parts.push("blocked");
        }

        if (device.batteryAvailable) {
            const battery = device.battery > 1 ? device.battery : device.battery * 100;
            parts.push(Math.round(battery) + "%");
        }

        return parts.join(" / ");
    }

    function deviceActionLabel(device) {
        if (!device) {
            return "";
        }

        if (device.connected) {
            return "Disconnect";
        }

        if (device.pairing) {
            return "Pairing";
        }

        if (!device.paired && !device.bonded) {
            return "Pair";
        }

        return "Connect";
    }

    function setEnabled(enabled) {
        if (!available) {
            return;
        }

        adapter.enabled = enabled;

        if (enabled) {
            scan();
        }
    }

    function setDiscoverable(discoverable) {
        if (available && enabled) {
            adapter.discoverable = discoverable;
        }
    }

    function scan() {
        if (available && enabled) {
            adapter.discovering = true;
        }
    }

    function stopScan() {
        if (available) {
            adapter.discovering = false;
        }
    }

    function toggleScan() {
        if (discovering) {
            stopScan();
            return;
        }

        scan();
    }

    function toggleDevice(device) {
        if (!device || !enabled || device.pairing) {
            return;
        }

        if (device.connected) {
            device.disconnect();
            return;
        }

        if (!device.paired && !device.bonded) {
            device.pair();
            return;
        }

        device.connected = true;
    }

    function openApplication() {
        Quickshell.execDetached(Config.Programs.bluetoothApplicationCommand);
    }
}
