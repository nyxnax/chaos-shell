import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

ItemDelegate {
    id: root

    property string buttonIcon
    property string description
    property alias iconSize: iconWidget.iconSize
    property alias control: controlContainer.data
    property alias bottomControl: bottomControlContainer.data

    property int position: 3 // 0: mid, 1: top, 2: bottom, 3: both
    property bool isFocused: true
    property bool isMainToggle: false
    property int smallRadius: Appearance.rounding.unsharpen
    property int outerRadius: Appearance.rounding.normal
    property bool shouldShow: true

    states: [
        State {
            name: "visible"
            when: root.shouldShow
            PropertyChanges { target: root; opacity: 1.0 }
            PropertyChanges { target: root; Layout.preferredHeight: root.implicitHeight }
        },
        State {
            name: "hidden"
            when: !root.shouldShow
            PropertyChanges { target: root; opacity: 0.0 }
            PropertyChanges { target: root; Layout.preferredHeight: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "hidden"; to: "visible"

            NumberAnimation {
                properties: "Layout.preferredHeight"
                duration: Appearance.animation.elementResize.duration
                easing.type: Appearance.animation.elementResize.type
                easing.bezierCurve: Appearance.animation.elementResize.bezierCurve
            }

            NumberAnimation {
                properties: "opacity"
                duration: Appearance.animation.elementMoveEnter.duration
                easing.type: Appearance.animation.elementMoveEnter.type
                easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
            }
        },
        Transition {
            from: "visible"; to: "hidden"

            NumberAnimation {
                properties: "Layout.preferredHeight"
                duration: Appearance.animation.elementResize.duration
                easing.type: Appearance.animation.elementResize.type
                easing.bezierCurve: Appearance.animation.elementResize.bezierCurve
            }
            NumberAnimation {
                properties: "opacity"
                duration: Appearance.animation.elementMoveExit.duration
                easing.type: Appearance.animation.elementMoveExit.type
                easing.bezierCurve: Appearance.animation.elementMoveExit.bezierCurve
            }
        }
    ]

    Layout.fillWidth: true
    topPadding: 16 + (isMainToggle ? 6 : 0)
    bottomPadding: 16 + (isMainToggle ? 6 : 0)
    leftPadding: 20; rightPadding: 20;
    implicitHeight: contentLayout.implicitHeight + topPadding + bottomPadding
    font.pixelSize: Appearance.font.pixelSize.large
    opacity: isFocused ? 1 : 0.6

    Behavior on opacity {animation: Appearance.animation.elementMove.numberAnimation.createObject(root)}

    background: Rectangle {
        topLeftRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        topRightRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        bottomLeftRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius
        bottomRightRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius

        color: {(root.down) ? Appearance.colors.m3surfaceVariant
               : (root.hovered)
               ? Appearance.colors.m3surfaceContainerHighest
               : (isMainToggle)
               ? Qt.darker(Appearance.colors.m3primaryContainer, 1.2)
               : Appearance.colors.m3surfaceContainerHigh;
        }

        border.color: root.hovered ? Qt.alpha(Appearance.colors.m3primary, 0.35) : "transparent"
        border.width: 3

        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        Behavior on topLeftRadius {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
        Behavior on bottomLeftRadius {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
        Behavior on topRightRadius {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
        Behavior on bottomRightRadius {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
    }

    contentItem: ColumnLayout {
        id: contentLayout
        spacing: 16

        RowLayout {
            id: topRow
            spacing: 16

            MaterialSymbol { // Icon
                id: iconWidget
                text: root.buttonIcon
                Layout.alignment: Qt.AlignVCenter
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.m3onSecondaryContainer
                visible: root.buttonIcon !== ""
                fill: root.hovered ? 1 : 0
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

            RowLayout { // Widget Placeholder
                id: controlContainer
                spacing: 12
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ColumnLayout { // Bottom Widget Placeholder
            id: bottomControlContainer
            spacing: 16
            visible: childrenRect.height > 0
        }
    }
}
