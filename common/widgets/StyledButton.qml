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

    enum Style { // The colors are slightly different from the MD3 spec
        Elevated, // Surface container low, no shadow for now
        Filled,   // Solid primary (my preferred default)
        Tonal,    // Secondary/Tertiary container
        Outlined, // Transparent + outline
        Text      // Flat/Transparent
    }

    property int size: StyledButton.Size.M
    property int style: StyledButton.Style.Filled

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

    property string fontColor: {
        switch(style) {
            case StyledButton.Style.Elevated:
                return isSelected ? Appearance.colors.m3onPrimary : Appearance.colors.m3primary;

            case StyledButton.Style.Filled:
                return isSelected ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSecondaryContainer;

            case StyledButton.Style.Tonal:
                return isSelected ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSecondaryContainer;

            case StyledButton.Style.Outlined:
            case StyledButton.Style.Text:
            default:
                return isSelected ? Appearance.colors.m3primary : Appearance.colors.m3onSurface;
        }
    }

    property string buttonColor: {
        switch(style) {
            case StyledButton.Style.Elevated:
                return pressed ? Appearance.colors.m3surfaceContainerHigh :
                       isSelected ? Appearance.colors.m3primary :
                       hovered ? Appearance.colors.m3surfaceContainerLow :
                       Appearance.colors.m3surfaceContainerLow;

            case StyledButton.Style.Filled:
                return pressed ? Appearance.colors.m3surfaceContainerHigh :
                       isSelected ? Appearance.colors.m3primary :
                       hovered ? Appearance.colors.m3surfaceContainer :
                       Appearance.colors.m3surfaceContainerLow;

            case StyledButton.Style.Tonal:
                return pressed ? Appearance.colors.m3primaryContainer :
                       isSelected ? Appearance.colors.m3primary :
                       hovered ? Appearance.colors.m3surfaceContainerHigh :
                       Appearance.colors.m3secondaryContainer;

            case StyledButton.Style.Outlined:
            case StyledButton.Style.Text:
            default:
                return pressed ? Appearance.colors.m3surfaceContainerHighest :
                       isSelected ? Appearance.colors.m3background :
                       hovered ? Appearance.colors.m3surfaceContainerLow :
                       "transparent";
        }
    }
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

        border.width: (root.style === StyledButton.Style.Outlined || root.border > 0) ? (root.border > 0 ? root.border : 2) : 0
        border.color: root.style === StyledButton.Style.Outlined ? Appearance.colors.m3outline : Appearance.colors.m3outlineVariant

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
                fill: root.isSelected || root.hovered ? 1 : 0
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
