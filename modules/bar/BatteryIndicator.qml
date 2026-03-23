import qs.common
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

// Battery Icon, modified from end-4's dotfiles

BarItem {
    id:root
    visible: Battery.available
    color: "transparent"
    width: layout.width

    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    MouseArea {
        id: layout
        hoverEnabled: true

        implicitWidth: batteryProgress.width
        implicitHeight: 30
        anchors.centerIn: parent

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
                    anchors.centerIn: parent
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
                        property bool isShown: Config.options.bar.showBatteryPercentage || layout.containsMouse
                        opacity : isShown ? 1 : 0
                        visible: opacity > 0
                        Layout.alignment: Qt.AlignVCenter
                        font: batteryProgress.font
                        text: batteryProgress.text
                        Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(layout)}
                    }
                }
            }
        }
    }
}
