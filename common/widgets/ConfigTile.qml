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

    property int position: 3 // 0: mid, 1: top, 2: bottom, 3: both
    property int smallRadius: Appearance.rounding.unsharpen
    property int outerRadius: Appearance.rounding.normal

    Layout.fillWidth: true
    implicitHeight: contentLayout.implicitHeight + 12 * 2
    font.pixelSize: Appearance.font.pixelSize.large

    background: Rectangle {
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
        Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
    }

    contentItem: RowLayout {
        id: contentLayout
        spacing: 16

        Item {} // Small margin

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

        RowLayout { // Widget Placeholder
            id: controlContainer
            spacing: 12
            Layout.alignment: Qt.AlignVCenter
        }

        Item {} // Small margin
    }
}
