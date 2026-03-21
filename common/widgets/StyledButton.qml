import qs.common
import QtQuick
import QtQuick.Controls

Button {
    id: root

    scale: 1
    implicitHeight: 48 * scale
    implicitWidth: Math.max(120, layoutWrapper.implicitWidth + 40)

    property string buttonColor: Appearance.colors.m3surfaceVariant
    property string buttonIcon: ""
    property int border: 0
    property int radius: 12

    PointingHand{}

    background: Rectangle {
        color: {
            if (root.pressed) return Qt.alpha(Appearance.colors.m3primary, 0.4)
            return root.buttonColor
        }

        radius: root.pressed ? 6 : root.radius
        scale: root.pressed ? 0.95 : 1.0
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }
        border.width: root.hovered ? Math.max(root.border, 2) : root.border
        border.color: Appearance.colors.m3outline

        Behavior on border.width {NumberAnimation {duration: 200; easing.type: Easing.InOutQuad}}
    }

    contentItem: Item {
        id: layoutWrapper
        Row {
            anchors.centerIn: parent
            spacing: 4

            MaterialSymbol {
                id: icon
                anchors.verticalCenter: parent.verticalCenter
                visible: text !== ""
                text: root.buttonIcon
                font.pixelSize: Appearance.font.pixelSize.large * root.scale
            }
            StyledText {
                id: text
                scale: root.pressed ? 0.95 : 1.0
                anchors.verticalCenter: parent.verticalCenter
                visible: text !== ""
                text: root.text
                font.pixelSize: Appearance.font.pixelSize.large * root.scale
            }
        }
    }
}
