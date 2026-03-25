import qs.common
import QtQuick
import QtQuick.Controls

Button {
    id: root

    enum Size {
        XS, // 24px - Tiny/Icon-only style
        S,  // 32px - Compact
        M,  // 40px - Standard MD3
        L,  // 48px - Comfortable/Touch
        XL  // 56px - Prominent
    }

    property int size: StyledButton.Size.M

    readonly property real targetHeight: {
        switch(size) {
            case StyledButton.Size.XS: return 24;
            case StyledButton.Size.S:  return 32;
            case StyledButton.Size.M:  return 40;
            case StyledButton.Size.L:  return 48;
            case StyledButton.Size.XL: return 56;
            default: return 40;
        }
    }

    readonly property real hPadding: {
        switch(size) {
            case StyledButton.Size.XS: return 8;
            case StyledButton.Size.S:  return 12;
            case StyledButton.Size.M:  return 16;
            case StyledButton.Size.L:  return 20;
            case StyledButton.Size.XL: return 24;
            default: return 16;
        }
    }

    readonly property real fontSize: {
        switch(size) {
            case StyledButton.Size.XS: return Appearance.font.pixelSize.small;
            case StyledButton.Size.S:  return Appearance.font.pixelSize.normal;
            case StyledButton.Size.M:  return Appearance.font.pixelSize.large;
            case StyledButton.Size.L:  return Appearance.font.pixelSize.larger;
            case StyledButton.Size.XL: return Appearance.font.pixelSize.huge;
            default: return Appearance.font.pixelSize.large;
        }
    }

    scale: 1
    implicitHeight: targetHeight
    implicitWidth: isIconOnly ? targetHeight : (layoutWrapper.implicitWidth + (hPadding * 2))

    readonly property bool isIconOnly: root.text === "" && root.buttonIcon !== ""
    property string buttonColor: Appearance.colors.m3surfaceVariant
    property string buttonIcon: ""
    property int border: 0
    property int radius: size <= StyledButton.Size.S ? 8 : 12

    background: Rectangle {
        color: root.pressed ? Qt.darker(root.buttonColor, 1.1) :
               root.hovered ? Qt.lighter(root.buttonColor, 1.1) : root.buttonColor

        radius: root.radius
        scale: root.pressed ? 0.95 : 1.0
        border.width: root.hovered ? Math.max(root.border, 2) : root.border
        border.color: Appearance.colors.m3primary

        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }
        Behavior on border.width {animation: Appearance.animation.elementMove.numberAnimation.createObject(root)}
    }

    contentItem: Item {
        id: layoutWrapper
        implicitWidth: contentRow.implicitWidth
        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: size <= StyledButton.Size.S ? 4 : 8

            MaterialSymbol {
                id: icon
                text: root.buttonIcon
                visible: text !== ""
                font.pixelSize: fontSize * 1.1
                color: Appearance.colors.m3onSurface
                anchors.verticalCenter: parent.verticalCenter
            }
            StyledText {
                id: text
                text: root.text
                visible: text !== ""
                scale: root.pressed ? 0.95 : 1.0
                font.pixelSize: fontSize
                color: Appearance.colors.m3onSurface
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
