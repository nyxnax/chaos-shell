import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.common
import Qt5Compat.GraphicalEffects

// Material Design 3 style Slider

Slider {
    id: root

    property bool showDots: true
    property int segments
    property color backgroundColor: Appearance.colors.m3background
    property color trackColor: Appearance.colors.m3secondaryContainer

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
        Behavior on width {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
        Behavior on x {enabled: !root.pressed; animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

        Rectangle { // Handle border
            id: gapBorder
            anchors.centerIn: parent
            width: parent.width + 12
            height: parent.height + 4
            radius: 6
            color: root.backgroundColor
        }

        Rectangle { // Handle
            id: handlePill
            anchors.fill: parent
            radius: 1
            color: Appearance.colors.m3primary
        }
    }

    background: Rectangle { // Background track
        id: track
        x: root.leftPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        implicitHeight: root.pressed ? 38 : 34
        width: root.availableWidth
        height: implicitHeight
        radius: 8
        color: root.trackColor
        Behavior on implicitHeight {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

        readonly property int dotCount: (root.stepSize > 0) ? Math.round((root.to - root.from) / root.stepSize) + 1 : 0

        Item { // Progress fill
            id: fillContainer
            anchors.fill: parent
            visible: false
            Rectangle {
                id: fill
                height: parent.height
                width: Math.max(0, (root.visualPosition * parent.width) - 6)
                color: Appearance.colors.m3primary
                radius: 2
                Behavior on width {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            }
        }

        Rectangle {id: barMask; anchors.fill: parent; radius: track.radius; visible: false; layer.enabled: true}
        OpacityMask {anchors.fill: parent; source: fillContainer; maskSource: barMask}

        Repeater { // Stop indicators
            model: (root.stepSize > 0) ? Math.round((root.to - root.from) / root.stepSize) + 1 : 0
            delegate: Rectangle {
                x: (track.dotCount > 1) ? (index * (track.width / (track.dotCount - 1))) - (width / 2) : 0
                anchors.verticalCenter: parent.verticalCenter
                width: 4
                height: 4
                radius: 2
                visible: index > 0 && index < (track.dotCount - 1)
                color: (root.from + (index * root.stepSize)) <= (root.value + 0.001)
                       ? Appearance.colors.m3onPrimary
                       : Appearance.colors.m3onSurfaceVariant

                opacity: 0.6
                Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
            }
        }
    }
}
