pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var output: Pipewire.defaultAudioSink
    readonly property var input: Pipewire.defaultAudioSource
    readonly property var trackedNodes: {
        const nodes = [];

        if (output) {
            nodes.push(output);
        }

        if (input) {
            nodes.push(input);
        }

        return nodes;
    }
    readonly property bool outputReady: Pipewire.ready && !!output && output.ready && !!output.audio
    readonly property bool inputReady: Pipewire.ready && !!input && input.ready && !!input.audio
    readonly property real outputVolume: outputReady ? output.audio.volume : 0
    readonly property int outputVolumePercent: Math.round(outputVolume * 100)
    readonly property bool outputMuted: outputReady && !!output.audio.muted
    readonly property string outputName: nodeName(output)
    readonly property string inputName: nodeName(input)

    PwObjectTracker {
        objects: root.trackedNodes
    }

    function nodeName(node) {
        if (!node) {
            return "Unavailable";
        }

        const description = node.description || "";
        const nickname = node.nickname || "";
        const name = node.name || "";

        if (description.length > 0) {
            return description;
        }

        if (nickname.length > 0) {
            return nickname;
        }

        if (name.length > 0) {
            return name;
        }

        return "Unavailable";
    }

    function clamp(value, minimum, maximum) {
        return Math.max(minimum, Math.min(maximum, value));
    }

    function setOutputMuted(muted) {
        if (!outputReady) {
            return;
        }

        output.audio.muted = muted;
    }

    function toggleOutputMuted() {
        setOutputMuted(!outputMuted);
    }

    function setOutputVolume(percent) {
        if (!outputReady) {
            return;
        }

        const normalized = clamp(percent, 0, 100) / 100;
        output.audio.volume = normalized;

        if (normalized > 0 && outputMuted) {
            output.audio.muted = false;
        }
    }

    function stepOutputVolume(delta) {
        setOutputVolume(outputVolumePercent + delta);
    }

    function outputStatus() {
        if (!outputReady) {
            return "No output";
        }

        if (outputMuted) {
            return "Muted";
        }

        return outputVolumePercent + "%";
    }

    function iconName() {
        if (!outputReady || outputVolumePercent <= 0) {
            return "volume-off";
        }

        if (outputMuted) {
            return "volume-3";
        }

        if (outputVolumePercent < 50) {
            return "volume-2";
        }

        return "volume";
    }
}
