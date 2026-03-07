import QtQuick
import QtQuick.Controls
import Quickshell
import "../../settings"

FloatingWindow {
    id: settingsWindow
    property var config
    implicitWidth: 150
    implicitHeight: 60
    visible: true
    title: "Chaos Settings"
    
    color: "black"

    MouseArea {
        anchors.fill: parent
        onClicked: config.togglePossition()

        Text {
            anchors.centerIn: parent
            color: "white"
            text: config.isTop ? "Move to bottom" : "Move to Top"

        }
    }
}
