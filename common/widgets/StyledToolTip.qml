import qs.common
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ToolTip {
    id: root
    property string title: ""
    property bool shown: parent.hovered && text !== ""
    visible: background.opacity > 0
    delay: 50
    timeout: 3000
    verticalPadding: 5
    horizontalPadding: 8
    background: null

    contentItem: Item {
        id: item
        property bool isVisible: background.implicitHeight > 0
        property alias font: tooltipText.font
        implicitWidth: tooltipText.implicitWidth + 2 * root.horizontalPadding
        implicitHeight: tooltipText.implicitHeight + 2 * root.verticalPadding

        Rectangle {
            id: background
            anchors {
                bottom: item.bottom
                horizontalCenter: item.horizontalCenter
            }
            color: Appearance.colors.m3inverseSurface
            opacity: shown ? 1 : 0
            implicitWidth: shown ? (textColumn.implicitWidth + 2 * root.horizontalPadding) : 0
            implicitHeight: shown ? (textColumn.implicitHeight + 2 * root.verticalPadding) : 0
            radius: Appearance.rounding.verysmall

            Behavior on implicitWidth {animation: Appearance?.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on implicitHeight {animation: Appearance?.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on opacity {animation: Appearance?.animation.elementMoveFast.numberAnimation.createObject(this)}

            ColumnLayout{
                id: textColumn
                spacing: -2
                anchors.fill: parent
                anchors.leftMargin: root.horizontalPadding
                anchors.rightMargin: root.horizontalPadding
                anchors.topMargin: root.verticalPadding
                anchors.bottomMargin: root.verticalPadding

                StyledText {
                    id: tooltipTitle
                    visible: text !== ""
                    text: root.title
                    font.pixelSize: Appearance?.font.pixelSize.small
                    font.weight: 700
                    font.hintingPreference: Font.PreferNoHinting
                    color: Appearance.colors.m3inverseOnSurface
                    wrapMode: Text.Wrap
                }

                StyledText {
                    id: tooltipText
                    text: root.text
                    font.pixelSize: Appearance?.font.pixelSize.small
                    font.hintingPreference: Font.PreferNoHinting
                    color: Appearance.colors.m3inverseOnSurface
                    wrapMode: Text.Wrap
                    opacity: 0.9
                }
            }
        }
    }
}
