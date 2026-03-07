import QtQuick
import Quickshell
import "../../settings"

PanelWindow {
    property var config
    implicitWidth: 150
    implicitHeight: 60
    anchors {
        bottom: true
        right: true
    }

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