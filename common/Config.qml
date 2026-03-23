pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.functions

Singleton {
    id: root

    property string filePath: Directories.shellConfigPath
    property alias options: configOptionsJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50 // milliseconds
    property bool blockWrites: false

    function setNestedValue(nestedKey, value) {
        let keys = nestedKey.split(".");
        let obj = root.options;
        let parents = [obj];

        // Traverse and collect parent objects
        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            if (!obj) {
                console.warn("Config.updateKey: failed to resolve", keys[i])
                return
            }
            parents.push(obj);
        }

        // Convert value to correct type using JSON.parse when safe
        let convertedValue = value;
        if (typeof value === "string") {
            let trimmed = value.trim();
            if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
                try {
                    convertedValue = JSON.parse(trimmed);
                } catch (e) {
                    convertedValue = value;
                }
            }
        }

        obj[keys[keys.length - 1]] = convertedValue;
    }

    Timer { id: fileReloadTimer; interval: root.readWriteDelay; repeat: false; onTriggered: configFileView.reload() }
    Timer {id: fileWriteTimer; interval: root.readWriteDelay; repeat: false; onTriggered: configFileView.writeAdapter() }

    FileView {
        id: configFileView
        path: root.filePath
        watchChanges: true
        blockWrites: root.blockWrites
        onFileChanged: fileReloadTimer.restart()
        onAdapterUpdated: fileWriteTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter

            property JsonObject appearance: JsonObject {
                property bool light: false
                property string scheme: "scheme-tonal-spot"
                property string wallpaper: ""
                property int fontScale : 100
                property int displayScale : 100

                property JsonObject fonts: JsonObject {
                    property string main: "Google Sans Flex"
                    property string numbers: "Google Sans Flex"
                    property string title: "Google Sans Flex"
                    property string iconNerd: "JetBrains Mono NF"
                    property string monospace: "JetBrains Mono NF"
                    property string reading: "Readex Pro"
                    property string expressive: "Space Grotesk"
                }
            }

            property JsonObject osd: JsonObject {
                property bool enable: true
                property bool showPercent: false
                property bool showDots: false
                property bool draggable: false
            }

            property JsonObject bar: JsonObject {
                property bool bottom: true
                property bool autoHide: false
                property bool showDate: true
                property bool showTime: true
                property bool showWindowTitle: true
                property bool showWindowIcon: true
                property bool workspaceIcons: true
                property bool showCoverArt: false
                property bool showArtist: true
                property bool showMedia: true
                property bool showMediaText: true
                property bool showMediaControl: true
                property bool showBackground: true
                property bool showBatteryPercentage: true
            }

            property JsonObject battery: JsonObject {
                property bool automaticSuspend: true
                property bool sounds: true
                property int low: 20
                property int critical: 10
                property int full: 101
                property int suspend: 3
            }
            property JsonObject sounds: JsonObject {
                property string theme: "freedesktop"
            }
            property JsonObject audio: JsonObject {
                property JsonObject protection: JsonObject {
                    property bool enable: false
                    property real maxAllowedIncrease: 10
                    property real maxAllowed: 99
                }
            }
        }
    }
}
