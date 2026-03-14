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
        spacing: 0

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

        StyledText { // Date
            id: date
            text: "  " + Time.date
            font.weight: 400
            opacity: 0.5
            anchors.bottomMargin: 1
            visible: Config.options.bar.date
        }
    }
}
