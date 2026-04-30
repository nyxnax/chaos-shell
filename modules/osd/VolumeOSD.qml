import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.common.panels
import qs.services
import Qt5Compat.GraphicalEffects

Scope {
    id: root

    function triggerOsd() {
        Global.states.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 3000
        repeat: false
        onTriggered: {
            Global.states.osdVolumeOpen = false;
        }
    }

    Connections {
        // Listen to output changes
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready) return;
            root.triggerOsd();
        }
        function onMutedChanged() {
            if (!Audio.ready) return;
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: Global.states.osdVolumeOpen && Config.options.osd.enable

        sourceComponent: OSD {
            id: osdInstance
            icon: {
                if (Audio.sink?.audio?.muted || Audio.value === 0) return "volume_off";
                if (Audio.value < 0.25) return "volume_mute";
                if (Audio.value < 0.50) return "volume_down";
                return "volume_up";
            }

            value: Audio.value
            onMoved: {
                if (Audio.sink && Audio.sink.audio) {
                    Audio.sink.audio.volume = value;
                    root.triggerOsd();
                }
            }
        }
    }

}
