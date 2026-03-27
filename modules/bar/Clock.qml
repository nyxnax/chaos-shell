import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    visible: time.isShown || date.isShown
    enabled: false

    RowLayout {
        id: layout
        anchors.centerIn:parent
        spacing: 8

        StyledText { // Time
            id: time
            text: Time.hour + ":" + Time.minute
            font.weight: 700
            animateChange: true

            property bool isShown: Config.options.bar.showTime
            visible: opacity > 0
            opacity: isShown ? 1 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

        }

        StyledText { // Date
            id: date
            text: Time.date
            font.weight: 400
            animateChange: true

            property bool isShown: Config.options.bar.showDate
            visible: opacity > 0
            opacity: isShown ? 0.7 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
        }
    }
}
