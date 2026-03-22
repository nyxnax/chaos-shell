import QtQuick
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    width: layout.width + 10
    radius: 6

    Row {
        id: layout
        anchors.centerIn: parent
        spacing: 8

        Row { // Time
            id: time

            property bool isShown: Config.options.bar.showTime
            visible: opacity > 0
            opacity: isShown ? 1 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }


            StyledText { // Hours
                id: hours
                text: Time.hour + ":"
                font.weight: 700
            }

            StyledText { // Minutes
                id: minutes
                text: Time.minute
                font: hours.font
            }
        }

        StyledText { // Date
            id: date
            text: Time.date
            font.weight: 400
            anchors.bottomMargin: 1

            property bool isShown: Config.options.bar.showDate
            visible: opacity > 0
            opacity: isShown ? 0.7 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
        }
    }
}
