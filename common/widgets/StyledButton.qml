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

    readonly property real targetRadius: {
        if (isRound || isIconOnly) return Appearance.rounding.full;

        switch(size) {
            case StyledButton.Size.XS: return Appearance.rounding.tiny;
            case StyledButton.Size.S:  return Appearance.rounding.verysmall;
            case StyledButton.Size.M:  return Appearance.rounding.small;
            case StyledButton.Size.L:  return Appearance.rounding.normal;
            case StyledButton.Size.XL: return Appearance.rounding.large;
            default: return Appearance.rounding.small;
        }
    }

    scale: 1
    implicitHeight: targetHeight
    implicitWidth: {
        let baseWidth = isIconOnly ? targetHeight : (layoutWrapper.implicitWidth + (hPadding * 2))
        return pressed ? baseWidth * 0.9 :
               hovered ? baseWidth * 1.2 :
               baseWidth
    }

    Behavior on implicitWidth {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}

    property bool isRound: false
    property bool isSelected: false
    readonly property bool isIconOnly: root.text === "" && root.buttonIcon !== ""
    property string fontColor: root.pressed ? Appearance.colors.m3onPrimaryContainer :
                               isSelected ? Appearance.colors.m3onPrimary :
                               root.hovered ? Appearance.colors.m3onSurfaceVariant
                               : Appearance.colors.m3onSurface
    property string buttonColor: pressed ? Appearance.colors.m3primaryContainer :
                                 isSelected && hovered ? Qt.darker(Appearance.colors.m3primary, 1.25) :
                                 isSelected ? Appearance.colors.m3primary :
                                 hovered ? Appearance.colors.m3surfaceContainerHigh
                                 : Appearance.colors.m3surfaceContainerLow
    property string buttonIcon: ""
    property int border: 0

    property int radius: targetRadius
    property int outerRadius: radius
    property int innerRadius: Appearance.rounding.unsharpen
    property int position: 3 // 0: mid, 1: left, 2: right, 3: single

    background: Rectangle {
        topLeftRadius: (root.position === 1 || root.position === 3) ? outerRadius : innerRadius
        topRightRadius: (root.position === 2 || root.position === 3) ? outerRadius : innerRadius
        bottomLeftRadius: (root.position === 1 || root.position === 3) ? outerRadius : innerRadius
        bottomRightRadius: (root.position === 2 || root.position === 3) ? outerRadius : innerRadius
        color: buttonColor
        border.width: 0
        border.color: Appearance.colors.m3outlineVariant

        Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }
        Behavior on border.width {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on topLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on topRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
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
                color: fontColor
                anchors.verticalCenter: parent.verticalCenter
            }
            StyledText {
                id: text
                text: root.text
                visible: text !== ""
                scale: root.pressed ? 0.95 : 1.0
                font.pixelSize: fontSize
                color: fontColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
