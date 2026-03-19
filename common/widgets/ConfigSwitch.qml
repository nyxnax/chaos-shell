import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

// Material Design 3 style settings row and switch

ItemDelegate {
    id: root
    property string buttonIcon
    property string description
    property alias iconSize: iconWidget.iconSize

    Layout.fillWidth: true
    implicitHeight: contentItem.implicitHeight + 8 * 2
    font.pixelSize: Appearance.font.pixelSize.large

    property int position: 0 // 0: mid, 1: top, 2: bottom, 3: both
    property int smallRadius: 4
    readonly property int outerRadius: {
        let p = root.parent;
        while (p) {
            if (p.radiusValue !== undefined) return p.radiusValue;
            p = p.parent;
        }
        return 24;
    }
    background: Rectangle {

        topLeftRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        topRightRadius: (root.position === 1 || root.position === 3) ? outerRadius : smallRadius
        bottomLeftRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius
        bottomRightRadius: (root.position === 2 || root.position === 3) ? outerRadius : smallRadius

        color: {
            if (root.down) return Appearance.colors.m3surfaceVariant;
            if (root.hovered) return Qt.alpha(Appearance.colors.m3surfaceVariant, 0.7);
            return Qt.alpha(Appearance.colors.m3surfaceVariant, 0.5);
        }

        border.color: root.hovered ? Qt.alpha(Appearance.colors.m3primary, 0.35) : "transparent"
        border.width: 3

        Behavior on color {
            ColorAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }
    }

    checkable: true
    PointingHand {}

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

        StyledSwitch { // Switch
            id: switchWidget
            scale: 1
            checked: root.checked
            enabled: false
            Layout.alignment: Qt.AlignVCenter
        }
        Item {} // margin
    }
}
