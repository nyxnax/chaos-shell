import QtQuick
import QtQuick.Layouts
import qs.common

Rectangle {
    id: root

    default property alias content: layout.data
    property alias hovered: mouseArea.containsMouse
    readonly property real contentWidth: layout.childrenRect.width
    readonly property real contentHeight: layout.childrenRect.height
    readonly property real cellSize: 32 * (Config.options.appearance.displayScale / 100)

    property int spacing: 0
    property bool usePadding: false
    property real padding: 6 * (Config.options.appearance.displayScale / 100)
    readonly property real horizontalPadding: usePadding ? padding * 2 : 0
    readonly property real verticalPadding: usePadding ? padding * 2 : 0

    readonly property string position: {
        if (typeof bar !== "undefined" && bar.position !== undefined) {
            return bar.position;
        }
        return Config.options.bar.position;
    }
    readonly property bool isVertical: position === "left" || position === "right"
    property bool background: Config.options.bar.showBackground
    signal clicked(var mouse)

    implicitWidth: isVertical ? 32 * (Config.options.appearance.displayScale / 100) : (contentWidth + horizontalPadding)
    implicitHeight: isVertical ? (contentHeight + verticalPadding) : 32 * (Config.options.appearance.displayScale / 100)

    color: (mouseArea.containsMouse && root.enabled) ? Appearance.colors.m3surfaceContainerHighest : (root.background ? Appearance.colors.m3surfaceContainerHigh : "transparent")
    radius: mouseArea.pressed ? Appearance.rounding.normal : (mouseArea.containsMouse ? Appearance.rounding.small : Appearance.rounding.verysmall)
    scale: mouseArea.pressed ? 0.9 : 1.0
    enabled: true

    Behavior on implicitWidth {animation: Appearance.animation.elementResize.numberAnimation.createObject(root)}
    Behavior on implicitHeight {animation: Appearance.animation.elementResize.numberAnimation.createObject(root)}
    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
    Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}
    Behavior on radius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(root)}
    Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: (mouse) => root.clicked(mouse)
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
    }
    GridLayout {
        id: layout
        anchors.centerIn: parent
        flow: isVertical ? Grid.TopToBottom : Grid.LeftToRight
        columnSpacing: spacing
        rowSpacing: spacing
    }
}
