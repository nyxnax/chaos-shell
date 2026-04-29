pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.common

Singleton {
    id: root

    Process {
        id: backlightProc
        property int val: 0
        command: ["brightnessctl", "set", val + "%"]
    }

    Process {
        id: ddcProc
        property int val: 0
        command: ["ddcutil", "setvcp", "10", val.toString()]
    }

    Timer { // Slight debounce for DDC monitors
        id: ddcDebounce
        interval: 200
        onTriggered: ddcProc.running = true
    }

    function setBrightness(screenName, value) {
        if (!screenName) return;

        let roundedVal = Math.round(value);
        let info = Display.displayInfo[screenName];
        if (!info) return;

        ShellState.setDisplayInfo(screenName, "brightness", roundedVal);

        if (info.backend === "backlight") { // Laptops and integrated displays
            backlightProc.val = roundedVal;
            if (backlightProc.running) backlightProc.terminate();
            backlightProc.running = true;
        } else if (info.backend === "ddc") { // Monitors and TVs
            ddcProc.val = roundedVal;
            ddcDebounce.restart();
        }
    }
}
