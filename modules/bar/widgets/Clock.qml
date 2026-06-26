import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    enabled: false
    usePadding: true

    property bool shouldShow: time.shouldShow || date.shouldShow || verticalTime.shouldShow || verticalDate.shouldShow
    visible: opacity > 0
    opacity: shouldShow ? 1 : 0
    scale: shouldShow ? 1 : 0.7

    RowLayout { // Horozontal
        visible: !isVertical

        StyledText { // Time
            id: time
            text: Time.hour + ":" + Time.minute
            font.weight: 700
            animateChange: true

            property bool shouldShow: Config.options.bar.showTime
            visible: opacity > 0
            opacity: shouldShow ? 1 : 0
            scale: shouldShow ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

        }

        StyledText { // Date
            id: date
            text: Time.date
            font.weight: 400
            animateChange: true

            property bool shouldShow: Config.options.bar.showDate
            visible: opacity > 0
            opacity: shouldShow ? 0.7 : 0
            scale: shouldShow ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
        }
    }

    ColumnLayout { // Vertical
        visible: isVertical
        spacing: 0

        ColumnLayout { // Time
            id: verticalTime
            spacing: -4

            property bool shouldShow: Config.options.bar.showTime
            visible: opacity > 0
            opacity: shouldShow ? 0.7 : 0
            scale: shouldShow ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

            StyledText {
                text: Time.hour
                font.weight: 800
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                animateChange: true
            }

            StyledText {
                text: Time.minute
                font.weight: 800
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                animateChange: true
            }
        }

        ColumnLayout { // Date
            id: verticalDate
            spacing: -4

            property bool shouldShow: Config.options.bar.showDate
            visible: opacity > 0
            opacity: shouldShow ? 0.7 : 0
            scale: shouldShow ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

            StyledText {
                text: Time.day
                font.weight: 500
                opacity: 0.8
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                animateChange: true
            }

            StyledText {
                text: Time.month
                font.weight: 500
                opacity: 0.8
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                animateChange: true
            }
        }
    }
}
