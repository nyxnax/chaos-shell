import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

// Battery Icon, modified from end-4's dotfiles

MouseArea {
    id: root
    visible: Battery.available
    //property bool borderless: Config.options.bar.borderless
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    implicitWidth: batteryProgress.implicitWidth
    implicitHeight: 30

    hoverEnabled: true

    BatteryBar {
        id: batteryProgress
        anchors.centerIn: parent
        value: percentage
        highlightColor: (isLow && !isCharging) ? Appearance.colors.m3error : Appearance.colors.m3onSecondaryContainer

        Item {
            anchors.centerIn: parent
            width: batteryProgress.valueBarWidth
            height: batteryProgress.valueBarHeight

            RowLayout {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: (parent.height - height) / 2
                }
                spacing: 2

                MaterialSymbol {
                    id: boltIcon
                    property bool isShown: isCharging && percentage < 1
                    opacity : isShown ? 1 : 0
                    visible: opacity > 0
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: -2
                    Layout.rightMargin: -2
                    fill: 1
                    text: "bolt"
                    iconSize: !percentageText.visible ?  16 : (batteryProgress.font.pixelSize - 2)
                    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(root)}
                }
                StyledText {
                    id: percentageText
                    property bool isShown: Config.options.bar.showBatteryPercentage || root.containsMouse
                    opacity : isShown ? 1 : 0
                    visible: opacity > 0
                    Layout.alignment: Qt.AlignVCenter
                    font: batteryProgress.font
                    text: batteryProgress.text
                    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(root)}
                }
            }
        }
    }
}
