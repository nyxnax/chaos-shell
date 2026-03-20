import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
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
        running: false
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

        sourceComponent: PanelWindow {
            id: volumeOSD
            anchors.bottom: true
            exclusiveZone: 0
            implicitWidth: 325
            implicitHeight: 60
            color: "transparent"
            margins.bottom: 40

            Rectangle {
                id: background
                anchors.fill: parent
                color: Qt.alpha(Appearance.colors.m3background, 1)
                radius: 18

                StyledSliderThick {
                    id: osdSlider
                    from: 0; to: 1; stepSize: 0.125;
                    anchors.centerIn: parent
                    width: parent.width - 20
                    height: parent.height - 20
                    value: Audio.value
                    //enabled: false

                    onMoved: {
                        if (Audio.sink && Audio.sink.audio) {
                            // 2. Write directly to the sink's audio volume
                            Audio.sink.audio.volume = value;
                            root.triggerOsd();
                        }

                        console.log("OSD: Volume Changed to: " + value + "%");
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 0

                    MaterialSymbol {
                        text: {
                            if (Audio.sink?.audio?.muted || Audio.value === 0) return "volume_off";
                            if (Audio.value < 0.25) return "volume_mute";
                            if (Audio.value < 0.50) return "volume_down";
                            return "volume_up";
                        }
                        font.pixelSize: Appearance.font.pixelSize.huge
                        color: (osdSlider.visualPosition * osdSlider.width) > 40
                               ? Appearance.colors.m3onPrimary
                               : Qt.alpha(Appearance.colors.m3onSurfaceVariant, 0.6)
                        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                    }

                    Item { Layout.fillWidth: true }

                    StyledText {
                        visible: Config.options.osd.showPercent
                        text: Math.round(Audio.value * 100)
                        font.pixelSize: Appearance.font.pixelSize.large
                        font.weight: 700
                        color: (osdSlider.visualPosition * osdSlider.width) > (osdSlider.width - 20)
                               ? Qt.alpha (Appearance.colors.m3onPrimary, 0)
                               : Qt.alpha (Appearance.colors.m3onSurfaceVariant, 0.6)
                        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                        }
                    Rectangle {
                        visible: !Config.options.osd.showPercent
                        height: 6
                        width: height
                        radius: height / 2
                        color: (osdSlider.visualPosition * osdSlider.width) > (osdSlider.width - 20)
                               ? Qt.alpha (Appearance.colors.m3onPrimary, 0)
                               : Qt.alpha (Appearance.colors.m3onSurfaceVariant, 0.6)
                        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                    }
                }
            }
        }
    }
}
