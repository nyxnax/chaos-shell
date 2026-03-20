import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

// Material Design 3 style settings row and slider

ItemDelegate {
    id: root

    property bool liveUpdate: true
    property real defaultValue: 100
    property string buttonIcon
    property string description
    property alias iconSize: iconWidget.iconSize
    property real value
    property real from
    property real to
    property real stepSize
    signal moved(real newValue)

    Layout.fillWidth: true
    implicitHeight: contentItem.implicitHeight + 12 * 2
    font.pixelSize: Appearance.font.pixelSize.large

    property int position: 0 // 0: mid, 1: top, 2: bottom, 3: both
    property int smallRadius: 4
    property int outerRadius: 14
    background: Rectangle {
        id: background
        topLeftRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        topRightRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        bottomLeftRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius
        bottomRightRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius

        color: {
            if (root.down) return Appearance.colors.m3surfaceVariant;
            if (root.hovered) return Appearance.colors.m3surfaceContainerHighest;
            return Appearance.colors.m3surfaceContainerHigh;
        }

        border.color: root.hovered ? Qt.alpha(Appearance.colors.m3primary, 0.35) : "transparent"
        border.width: 3
        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
    }

    contentItem: RowLayout {
        spacing: 16

        Item {} // margin
        MaterialSymbol { // Icon
            id: iconWidget
            text: root.buttonIcon
            Layout.alignment: Qt.AlignVCenter
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.m3onSecondaryContainer
            visible: root.buttonIcon !== ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            StyledText { // Title
                id: labelWidget
                Layout.fillWidth: true
                text: root.text
                font: root.font
                color: Appearance.colors.m3onSecondaryContainer
            }

            StyledText { // Description
                id: descriptionWidget
                Layout.fillWidth: true
                text: root.description
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.m3onSurfaceVariant
                opacity: 0.7
                wrapMode: Text.WordWrap
                visible: root.description !== ""
            }
        }

        StyledSlider { // Slider
            id: switchWidget
            scale: 1
            from: root.from
            to: root.to
            stepSize: root.stepSize
            value: root.value
            trackColor: Appearance.colors.m3secondaryContainer
            backgroundColor: background.color
            Layout.alignment: Qt.AlignVCenter

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

        StyledText { text: root.value + "%"; opacity: 0.7}

        MaterialSymbol {
            text: "restart_alt"
            iconSize: Appearance.font.pixelSize.large
            color: Appearance.colors.m3onSurfaceVariant
            opacity: root.value !== root.defaultValue ? 0.8 : 0.3
            visible: root.value !== root.defaultValue

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                onClicked: root.moved(root.defaultValue)
                PointingHand {}
            }

            Behavior on opacity { NumberAnimation { duration: 200 } }
        }

        Item {} // margin
    }
}
