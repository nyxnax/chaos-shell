import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import Qt5Compat.GraphicalEffects

// Material Design 3 style Slider
Slider {
    id: root

    property bool thick: false
    property bool showDots: true
    property bool hideFilledDots: false
    property bool hideFirstDots: false
    property int segments
    property color backgroundColor: Appearance.colors.m3background
    property color trackColor: Appearance.colors.m3secondaryContainer
    property color fillColor: Appearance.colors.m3primary
    property int gapSize: 6

    from: 0
    to: 1
    stepSize: (showDots && root.segments > 0) ? (1.0 / root.segments) : 0
    snapMode: Slider.SnapAlways
    implicitWidth: 300
    implicitHeight: 44

    PointingHand {}

    handle: Item {
        id: handleContainer
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + (root.availableHeight - height) / 2
        width: root.pressed ? 2 : 4
        height: 44
        Behavior on width {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

        Rectangle { // Handle
            id: handlePill
            anchors.fill: parent
            radius: 2
            color: root.fillColor
        }
    }

    background: Item {
        id: trackContainer
        anchors.verticalCenter: parent.verticalCenter
        width: root.width
        implicitHeight: root.thick ? (root.pressed ? 40 : 34) : (root.pressed ? 24 : 16)
        height: implicitHeight

        Behavior on implicitHeight {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

        readonly property int dotCount: (root.stepSize > 0) ? Math.round((root.to - root.from) / root.stepSize) + 1 : 0
        readonly property real midPointX: handleContainer.x + (handleContainer.width / 2)

        Rectangle { // Filled Track Segment
            id: leftFillTrack
            x: 0
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0, trackContainer.midPointX - root.gapSize)
            height: parent.height
            color: root.fillColor

            topLeftRadius: 8
            topRightRadius: 2
            bottomLeftRadius: 8
            bottomRightRadius: 2
        }

        Rectangle { // Background / Empty Track Segment
            id: rightEmptyTrack
            x: trackContainer.midPointX + root.gapSize
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(0, parent.width - x)
            height: parent.height
            color: root.trackColor

            topLeftRadius: 2
            topRightRadius: 8
            bottomRightRadius: 8
            bottomLeftRadius: 2
        }

        Repeater { // Stop indicators
            model: trackContainer.dotCount
            delegate: Rectangle {
                x: (trackContainer.dotCount > 1) ? (root.leftPadding + (index * (root.availableWidth / (trackContainer.dotCount - 1)))) - (width / 2) : 0
                anchors.verticalCenter: parent.verticalCenter
                width: 4
                height: 4
                radius: 2
                visible: index > (root.hideFirstDots ? 3 : 0) && index < (trackContainer.dotCount - 1)

                readonly property bool isFilled: (root.from + (index * root.stepSize)) <= (root.value + 0.001)

                color: isFilled
                       ? (root.hideFilledDots ? "transparent" : Appearance.colors.m3onPrimary)
                       : Appearance.colors.m3onSecondaryContainer
            }
        }
    }
}
