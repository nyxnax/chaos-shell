import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.common

TextField {
    id: control

    property bool outlined: false
    property string label: ""
    property string icon: ""
    property bool showClearButton: true

    implicitHeight: 56
    implicitWidth: 140
    Layout.fillWidth: true
    Layout.maximumWidth: 300
    leftPadding: icon !== "" ? 44 : 16
    rightPadding: (showClearButton && text !== "") ? 44 : 16
    topPadding: outlined ? 16 : (label !== "" ? 24 : 16)
    bottomPadding: outlined ? 16 : (label !== "" ? 8 : 16)
    font.pixelSize: Appearance.font.pixelSize.large
    color: enabled ? Appearance.colors.m3onSurface : Appearance.colors.m3onSurfaceVariant

    Behavior on implicitWidth {animation: Appearance.animation.elementMove.numberAnimation.createObject(root)}

    background: Rectangle {
        id: container
        color: control.outlined ? "transparent" : (
               !control.enabled ? Qt.alpha(Appearance.colors.m3surfaceVariant, 0.38) :
               control.hovered ? Appearance.colors.m3surfaceContainerHighest :
               Appearance.colors.m3surfaceContainerHigh)

        radius: control.outlined ? Appearance.rounding.normal : 0
        topLeftRadius: control.outlined ? Appearance.rounding.normal : Appearance.rounding.small
        topRightRadius: control.outlined ? Appearance.rounding.normal : Appearance.rounding.small

        border.color: !control.outlined ? "transparent" : (
                      !control.enabled ? Qt.alpha(Appearance.colors.m3outline, 0.38) :
                      control.activeFocus ? Appearance.colors.m3primary :
                      control.hovered ? Appearance.colors.m3onSurface : Appearance.colors.m3outline)
        border.width: control.outlined ? (control.activeFocus ? 2 : 1) : 0

        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        Behavior on border.color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}

        MaterialSymbol { // Icon
            id: leadingIcon
            text: control.icon
            visible: control.icon !== ""
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            iconSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.m3onSurfaceVariant
        }

        StyledText { // Floating Label
            id: labelText

            readonly property bool isFloating: control.activeFocus || control.text !== ""

            text: control.label
            visible: control.label !== ""
            anchors.left: parent.left
            anchors.leftMargin: control.icon !== "" ? 44 : 16
            anchors.top: parent.top
            anchors.topMargin: isFloating ? (control.outlined ? -8 : 4) : 16
            font.pixelSize: isFloating ? Appearance.font.pixelSize.small : Appearance.font.pixelSize.large
            color: control.activeFocus ? Appearance.colors.m3primary : Appearance.colors.m3onSurfaceVariant
            Behavior on anchors.topMargin { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on font.pixelSize { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        }

        Rectangle { // Bottom Line
            id: activeIndicator
            visible: !control.outlined
            width: parent.width
            height: control.activeFocus ? 2 : 1
            anchors.bottom: parent.bottom
            color: !control.enabled ? Qt.alpha(Appearance.colors.m3onSurface, 0.38) :
                   control.activeFocus ? Appearance.colors.m3primary :
                   control.hovered ? Appearance.colors.m3onSurface : Appearance.colors.m3outlineVariant

        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        }
    }

    MaterialSymbol { // Clear Button
        id: clearButton
        text: "cancel"
        visible: control.showClearButton && control.text !== "" && control.enabled
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        iconSize: Appearance.font.pixelSize.large
        color: clearMouse.hovered ? Appearance.colors.m3onSurface : Appearance.colors.m3onSurfaceVariant

        MouseArea {
            id: clearMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                control.clear()
                control.forceActiveFocus()
            }
        }
    }
}
