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
            icon: Audio.sinkMaterialSymbol

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
