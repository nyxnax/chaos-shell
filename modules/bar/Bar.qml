import QtQuick
import Quickshell

Scope {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 42
        color: "black"

        Text {
            anchors.centerIn: parent
            text: "Chaos Shell Alpha v0.1 Prototype"
            color: "white"
            font.pixelSize: 16
        }
    }
}
