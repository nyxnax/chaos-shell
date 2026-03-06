import QtQuick
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
        Quickshell.process(["foot", "nmtui"]).run();
      }
    }

    Row {
        id: layout
        anchors.centerIn: parent
        spacing: 0

        Text { // Hours
            id: hours
            text: Time.hour + ":"
            font {pixelSize: 16; weight: 500}
            color: "white"
        }

        Text { // Minutes
          id: minutes
          text: Time.minute
          font: hours.font
          color: "white"
        }

        Text { // Date
          id: date
          text: "  " + Time.date
          font {pixelSize: 16; weight: 400}
          color: "white"
          opacity: 0.5
          anchors.bottom: parent.bottom
          anchors.bottomMargin: 1
        }
    }
}
