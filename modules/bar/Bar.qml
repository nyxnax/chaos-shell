import QtQuick
import Quickshell
import "../../settings"
import qs.services

Scope {
    //property var config
    Variants {
        model: Quickshell.screens;
        
        PanelWindow {
            required property var modelData
            screen: modelData
            anchors {
                top: Config.isTop
                bottom: !Config.isTop
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
                Workspaces {}
            }
            Row {
                id: barRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter   // Center vertically
                anchors.margins: 10
                spacing: 10
                Text {
                    text: "Chaos Shell Alpha v0.1 Prototype|" + (Config.isTop ? "Top" : "Bottom")
                    color: "white"
                    font.pixelSize: 16
                }
            }
        }
    }
}
