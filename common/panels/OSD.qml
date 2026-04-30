import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property string icon: "question_mark"
    property real value: 0
    property alias window: osdWindow

    signal moved(real newValue)

    PanelWindow {
        id: osdWindow
        anchors.bottom: true
        exclusiveZone: 0
        implicitWidth: 325 * (Config.options.appearance.displayScale / 100)
        implicitHeight: 60 * (Config.options.appearance.displayScale / 100)
        color: "transparent"
        margins.bottom: 40

        Rectangle {
            id: background
            anchors.fill: parent
            color: Config.options.appearance.opacity <= 0 ? "transparent" :
                   Qt.alpha(Appearance.colors.m3background, Config.options.appearance.opacity / 100.0)
            radius: Appearance.rounding.normal

            StyledSlider {
                id: osdSlider
                from: 0; to: 1; segments: Config.options.osd.showDots ? 20 : 0;
                thick: true
                anchors.centerIn: parent
                width: parent.width - 25
                height: parent.height - 30
                value: root.value
                enabled: Config.options.osd.draggable
                onMoved: root.moved(value)
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 0

                MaterialSymbol {
                    text: root.icon
                    font.pixelSize: Appearance.font.pixelSize.huge
                    color: (osdSlider.visualPosition * osdSlider.width) > 40
                           ? Appearance.colors.m3onPrimary
                           : Qt.alpha(Appearance.colors.m3onSurfaceVariant, 0.6)
                    Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                }

                Item { Layout.fillWidth: true }

                StyledText {
                    visible: Config.options.osd.showPercent
                    text: Math.round(root.value * 100)
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.weight: 700
                    color: (osdSlider.visualPosition * osdSlider.width) > (osdSlider.width - 39)
                           ? Qt.alpha (Appearance.colors.m3onPrimary, 0)
                           : Qt.alpha (Appearance.colors.m3onSurfaceVariant, 1)
                    Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                }
                Rectangle {
                    visible: !Config.options.osd.showPercent
                    height: 6
                    width: height
                    radius: height / 2
                    color: (osdSlider.visualPosition * osdSlider.width) > (osdSlider.width - 20)
                           ? Qt.alpha (Appearance.colors.m3onPrimary, 0)
                           : Qt.alpha (Appearance.colors.m3onSurfaceVariant, 1)
                    Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                }
            }
        }
    }
}
