import QtQuick
import QtQuick.Controls
import Quickshell
import "../../settings"

FloatingWindow {
    id: settingsWindow
    implicitWidth: 150
    implicitHeight: 60
    visible: false
    title: "Chaos Settings"
    
    color: "black"

    MouseArea {
        anchors.fill: parent
        onClicked: Config.togglePossition()

        Text {
            anchors.centerIn: parent
            color: "white"
            text: Config.isTop ? "Move to bottom" : "Move to Top"

        }
    }
}
