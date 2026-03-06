import QtQuick
import Quickshell
import "../../settings"

Scope {
    property var config
    PanelWindow {
        
        anchors {
            top: config.isTop
            bottom: !config.isTop
            left: true
            right: true
        }

        implicitHeight: 42
        color: "black"

        Text {
            anchors.centerIn: parent
            text: "Chaos Shell Alpha v0.1 Prototype|" + (config.isTop ? "Top" : "Bottom")
            color: "white"
            font.pixelSize: 16
        }
    }
}
