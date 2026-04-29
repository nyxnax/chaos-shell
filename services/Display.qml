pragma Singleton
import QtQuick
import Quickshell
import qs.common

Singleton {
    id: root

    property var activeScreens: []
    property int _count: Quickshell.screens.length

    Connections {
        target: Quickshell
        function onScreensChanged() {
            console.info("Display Service: Hardware signal received.");
            root.scan();
        }
    }

    function scan() {
        let names = [];
        let hasChanges = false;
        for (let i = 0; i < Quickshell.screens.length; i++) {
            let screen = Quickshell.screens[i];
            if (screen && screen.name) {
                let sName = String(screen.name);
                names.push(sName);
                if (activeScreens.indexOf(sName) === -1) {
                    hasChanges = true;
                }
                root.registerDisplay(sName);
            }
        }
        activeScreens = names;
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
            let defaultPos = (Config.options && Config.options.bar) ? Config.options.bar.position : "top";
            ShellState.setDisplayValue(name, "position", defaultPos);
        } else {
            console.log("Display Service: " + name + " is already in state.");
        }
    }

    on_CountChanged: {
        root._count = Quickshell.screens.length;
        root.scan();
    }
}
