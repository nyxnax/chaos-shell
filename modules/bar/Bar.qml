import QtQuick
import Quickshell
import qs.services

Scope {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 42
        color: "black"

        Row {
            id: barLeft
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter   // Center vertically
            anchors.margins: 2
            spacing: 10
            Clock {}
        }

        Row {
            id: barCenter
            anchors.centerIn: parent
            Text {
                text: "Chaos Shell Alpha v0.1 Prototype"
                color: "white"
                font.pixelSize: 16
            }
        }
    }
}
