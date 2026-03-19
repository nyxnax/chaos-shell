import QtQuick
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    id: root
    height: 30
    width: layout.width + 10
    color: mouse.containsMouse ? "#2affffff" : "#00000000"
    radius: 6

    Behavior on color { ColorAnimation { duration: 150 } }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            Global.states.settingsOpen = true
        }
        PointingHand {}
    }

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

            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }

            StyledText { // Hours
                id: hours
                text: Time.hour + ":"
                font.weight: 500
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

            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }
        }
    }
}
