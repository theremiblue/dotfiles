pragma Singleton

import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root

    readonly property string appListCommandPath: resolvedPath("../scripts/functions/lantern-apps")

    property bool visible: false
    property bool refreshing: false
    property var apps: []
    property string error: ""

    function resolvedPath(relativePath) {
        const url = String(Qt.resolvedUrl(relativePath));
        return decodeURIComponent(url.replace(/^file:\/\//, ""));
    }

    function cleanText(value) {
        return String(value || "").trim();
    }

    function fileUrl(path) {
        const cleanPath = cleanText(path);
        if (cleanPath.length === 0) {
            return "";
        }

        return "file://" + cleanPath.split("/").map(part => encodeURIComponent(part)).join("/");
    }

    function appSubtext(app) {
        if (app.generic.length > 0) {
            return app.generic;
        }

        return app.comment;
    }

    function appKey(value) {
        return cleanText(value)
            .toLowerCase()
            .replace(/\.desktop$/, "")
            .replace(/[^a-z0-9]+/g, "");
    }

    function appIconSourceForHints(hints) {
        const keys = [];

        for (const hint of hints || []) {
            const key = appKey(hint);

            if (key.length > 0 && !keys.includes(key)) {
                keys.push(key);
            }
        }

        if (keys.length === 0) {
            return "";
        }

        for (const app of apps) {
            if (app.iconSource.length === 0) {
                continue;
            }

            const appKeys = [
                appKey(app.name),
                appKey(app.iconName),
                appKey(app.path.split("/").pop())
            ];

            for (const key of keys) {
                if (appKeys.includes(key)) {
                    return app.iconSource;
                }
            }
        }

        for (const app of apps) {
            if (app.iconSource.length === 0) {
                continue;
            }

            const nameKey = appKey(app.name);

            for (const key of keys) {
                if (nameKey.length > 0 && key.length > 0 && nameKey.includes(key)) {
                    return app.iconSource;
                }
            }
        }

        return "";
    }

    function parseApps(output) {
        const parsed = [];
        const lines = output.trim().split("\n");

        for (const line of lines) {
            if (line.length === 0) {
                continue;
            }

            const parts = line.split("\u001f");
            if (parts.length < 2) {
                continue;
            }

            parsed.push({
                path: cleanText(parts[0]),
                name: cleanText(parts[1]),
                generic: cleanText(parts[2]),
                comment: cleanText(parts[3]),
                iconSource: fileUrl(parts[4]),
                iconName: cleanText(parts[5])
            });
        }

        apps = parsed;
    }

    function score(app, query) {
        const normalized = query.trim().toLowerCase();
        if (normalized.length === 0) {
            return 1;
        }

        const name = app.name.toLowerCase();
        const generic = app.generic.toLowerCase();
        const comment = app.comment.toLowerCase();

        if (name === normalized) {
            return 1000;
        }

        if (name.startsWith(normalized)) {
            return 800 - name.length;
        }

        if (name.includes(normalized)) {
            return 600 - name.indexOf(normalized);
        }

        if (generic.includes(normalized)) {
            return 400 - generic.indexOf(normalized);
        }

        if (comment.includes(normalized)) {
            return 200 - comment.indexOf(normalized);
        }

        return 0;
    }

    function search(query) {
        const matches = [];

        for (const app of apps) {
            const appScore = score(app, query);
            if (appScore <= 0) {
                continue;
            }

            matches.push({
                path: app.path,
                name: app.name,
                generic: app.generic,
                comment: app.comment,
                iconSource: app.iconSource,
                iconName: app.iconName,
                subtext: appSubtext(app),
                score: appScore
            });
        }

        matches.sort((left, right) => {
            if (left.score !== right.score) {
                return right.score - left.score;
            }

            return left.name.localeCompare(right.name);
        });

        return matches.slice(0, 10);
    }

    function show() {
        visible = true;
        refresh();
    }

    function hide() {
        visible = false;
    }

    function toggle() {
        if (visible) {
            hide();
            return;
        }

        show();
    }

    function launch(app) {
        if (!app || !app.path || app.path.length === 0) {
            return;
        }

        hide();
        Quickshell.execDetached(["gio", "launch", app.path]);
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
                error = "Could not read applications";
                return;
            }

            error = "";
            parseApps(result.output);
        };
        proc.exec([appListCommandPath]);
    }

    Component.onCompleted: refresh()

    IpcHandler {
        target: "lantern"

        function reveal() {
            root.show();
        }

        function dismiss() {
            root.hide();
        }

        function toggle() {
            root.toggle();
        }

        function refresh() {
            root.refresh();
        }
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
