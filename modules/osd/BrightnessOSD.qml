import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.panels
import qs.services

Scope {
    id: root

    function triggerOsd() {
        Global.states.osdBrightnessOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 3000
        onTriggered: Global.states.osdBrightnessOpen = false
    }

    Connections {
        target: Brightness
        function onBrightnessChanged() { root.triggerOsd(); }
    }

    Loader {
        id: osdLoader
        active: Global.states.osdBrightnessOpen && Config.options.osd.enable && ! Global.states.settingsOpen

        sourceComponent: OSD {
            id: osdInstance
            icon: {
                if (value < 0.14) return "brightness_1";
                if (value < 0.28) return "brightness_2";
                if (value < 0.42) return "brightness_3";
                if (value < 0.56) return "brightness_4";
                if (value < 0.70) return "brightness_5";
                if (value < 0.84) return "brightness_6";
                return "brightness_7";
            }

            readonly property string target: osdInstance.window?.screen?.name || ""

            value: {
                if (!target) return 0;
                const info = ShellState.values.displayInfo[target];
                return (info?.brightness || 0) / 100;
            }

            onMoved: (newValue) => {
                if (target) {
                    Brightness.setBrightness(target, newValue * 100);
                    root.triggerOsd();
                }
            }
        }
    }
}
