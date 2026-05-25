import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.common
import qs.services

RowLayout {
    id: root

    property bool shouldShow: true
    property bool isExpanded: false
    property int size: ProfileCard.Size.L
    property bool isRound: false

    scale: 1
    spacing: isExpanded ? 2 : 0
    visible: opacity > 0
    opacity: shouldShow ? 1 : 0

    enum Size {
        XS, // 24px - Tiny/Icon-only style
        S,  // 32px - Compact
        M,  // 40px - Standard
        L,  // 48px - Comfortable/Touch
        XL  // 56px - Prominent
    }

    readonly property real targetHeight: {
        switch(size) {
            case ProfileCard.Size.XS: return 24;
            case ProfileCard.Size.S:  return 32;
            case ProfileCard.Size.M:  return 40;
            case ProfileCard.Size.L:  return 48;
            case ProfileCard.Size.XL: return 56;
            default: return 40;
        }
    }

    readonly property real hPadding: {
        switch(size) {
            case ProfileCard.Size.XS: return 8;
            case ProfileCard.Size.S:  return 12;
            case ProfileCard.Size.M:  return 16;
            case ProfileCard.Size.L:  return 20;
            case ProfileCard.Size.XL: return 24;
            default: return 16;
        }
    }

    readonly property real fontSize: {
        switch(size) {
            case ProfileCard.Size.XS: return Appearance.font.pixelSize.small;
            case ProfileCard.Size.S:  return Appearance.font.pixelSize.normal;
            case ProfileCard.Size.M:  return Appearance.font.pixelSize.large;
            case ProfileCard.Size.L:  return Appearance.font.pixelSize.larger;
            case ProfileCard.Size.XL: return Appearance.font.pixelSize.huge;
            default: return Appearance.font.pixelSize.large;
        }
    }

    readonly property real targetRadius: {
        if (isRound) return Appearance.rounding.full;

        switch(size) {
            case ProfileCard.Size.XS: return Appearance.rounding.tiny;
            case ProfileCard.Size.S:  return Appearance.rounding.verysmall;
            case ProfileCard.Size.M:  return Appearance.rounding.small;
            case ProfileCard.Size.L:  return Appearance.rounding.normal;
            case ProfileCard.Size.XL: return Appearance.rounding.large;
            default: return Appearance.rounding.small;
        }
    }

    property int innerRadius: Appearance.rounding.unsharpen * 2
    property int outerRadius: targetRadius

    implicitHeight: targetHeight
    implicitWidth: !isExpanded ? targetHeight : (targetHeight + textContainer.Layout.preferredWidth + root.spacing)

    Behavior on implicitWidth {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}
    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

    Rectangle {
        id: profilePictureContainer
        height: targetHeight
        width: targetHeight
        color: Appearance.colors.m3surfaceContainerHighest

        topLeftRadius: outerRadius
        bottomLeftRadius: outerRadius
        topRightRadius: isExpanded? innerRadius : outerRadius
        bottomRightRadius: isExpanded? innerRadius : outerRadius

        Behavior on topLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on topRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: profilePictureContainer.width
                height: profilePictureContainer.height

                topLeftRadius: outerRadius
                bottomLeftRadius: outerRadius
                topRightRadius: isExpanded? innerRadius : outerRadius
                bottomRightRadius: isExpanded? innerRadius : outerRadius

                Behavior on topLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
                Behavior on bottomLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
                Behavior on topRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
                Behavior on bottomRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

            }
        }

        Image {
            id: picture
            source: Config.options.system.profile.usePicture ? Config.options.system.profile.picture : ""
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }

        MaterialSymbol {
            anchors.centerIn:parent
            text: Config.options.system.profile.icon
            fill: 1
            visible: picture.status === Image.Null || picture.status === Image.Error
        }
    }

    Rectangle {
        id: textContainer

        visible: root.isExpanded
        opacity: isExpanded ? 1 : 0
        color: Appearance.colors.m3surfaceContainerHigh
        Layout.fillHeight: true
        Layout.fillWidth: false
        Layout.preferredWidth: isExpanded ? (textColumn.implicitWidth + root.hPadding) : 0

        topLeftRadius: isExpanded? innerRadius : outerRadius
        bottomLeftRadius: isExpanded? innerRadius : outerRadius
        topRightRadius: outerRadius
        bottomRightRadius: outerRadius

        Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on topLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomLeftRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on topRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
        Behavior on bottomRightRadius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

        ColumnLayout {
            id: textColumn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.hPadding / 2
            spacing: 0

            RowLayout {
                Layout.fillWidth: false
                StyledText {
                    text: DeviceService.userName
                    font.pixelSize: root.fontSize * 0.6
                }
                StyledText {
                    text: DeviceService.hostName
                    font.pixelSize: root.fontSize * 0.6
                    opacity: 0.7
                }
            }


            StyledText {
                text: DeviceService.distroName
                font.pixelSize: root.fontSize * 0.55
                opacity: 0.55
            }
        }
    }
}
