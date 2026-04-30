import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

// Material Design 3 style settings tile and slider

ConfigTile {
    id: root

    property real value: 50
    property real from: 0
    property real to: 100
    property real stepSize: 0
    property real defaultValue: 100
    property string valueSuffix: "%"
    property bool liveUpdate: true
    signal moved(real newValue)

    control: RowLayout {
        spacing: 16

        StyledSlider { // Slider
            id: sliderWidget
            implicitWidth: 225
            value: root.value
            from: root.from
            to: root.to
            stepSize: root.stepSize

            trackColor: Appearance.colors.m3secondaryContainer
            backgroundColor: "transparent"


            onMoved: {
                if (root.liveUpdate) {
                    root.moved(value);
                }
            }

            onPressedChanged: {
                if (!pressed && !root.liveUpdate) {
                    root.moved(value);
                }
            }
        }

        StyledText { // Suffix
            text: value + valueSuffix
            opacity: 0.7
        }

        MaterialSymbol {
            text: "restart_alt"
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.m3onSurfaceVariant
            opacity: (root.value !== root.defaultValue && !sliderWidget.pressed) ? 0.8 : 0.2
            //visible: opacity > 0

            MouseArea {
                anchors.fill: parent
                //hoverEnabled: true
                //preventStealing: true
                onClicked: root.moved(root.defaultValue)
                cursorShape: Qt.PointingHandCursor
                //PointingHand {}
            }

            Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        }
    }
}
