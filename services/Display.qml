pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    property var activeScreens: []
    property var displayInfo: ({})
    property int _count: Quickshell.screens.length

    Connections {
        target: Quickshell
        function onScreensChanged() {
            console.info("Display Service: Hardware signal received.");
            root.scan();
        }
    }

    Process {
        id: ddcProbe
        command: ["ddcutil", "detect", "--terse"]
        stdout: StdioCollector {
            onStreamFinished: {
                parseDdcOutput(text);
            }
        }
    }

    function scan() {
        let names = [];
        let screenData = {};
        let hasChanges = false;

        for (let i = 0; i < Quickshell.screens.length; i++) {
            let screen = Quickshell.screens[i];
            if (screen && screen.name) {
                let sName = String(screen.name);
                names.push(sName);

                let type = "ddc"; // Backlight Backend
                if (sName.startsWith("eDP") || sName.startsWith("LVDS")) {
                    type = "backlight";
                }
                screenData[sName] = {
                    name: sName,
                    backend: type,
                    model: screen.model || "Unknown"
                };

                if (activeScreens.indexOf(sName) === -1) {
                    hasChanges = true;
                }
                root.registerDisplay(sName);
            }
        }
        ddcProbe.running = true;
        root.activeScreens = names;
        root.displayInfo = screenData;
        console.info("Display Service: Hardware detected: " + activeScreens.join(", "));
    }

    function registerDisplay(screenName) {
        let name = String(screenName);
        if (!name || name === "undefined") return;

        if (!ShellState.ready) {
            let capturedName = name;
            Qt.callLater(function() { root.registerDisplay(capturedName); });
            return;
        }

        const barData = ShellState.values.bar || {};

        if (barData[name] === undefined) {
            console.info("Display Service: Registering " + name + " for the first time.");
            let defaultPos = Config.options?.bar?.position ?? "top";
            BarService.setPosition(name, defaultPos)
        } else {
            console.log("Display Service: " + name + " is already in state.");
        }
    }

    function parseDdcOutput(output) {
        console.info("Display Service: DDC Probe complete.");
    }

    on_CountChanged: {
        root._count = Quickshell.screens.length;
        root.scan();
    }
}
