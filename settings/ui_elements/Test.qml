import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../../settings"

ApplicationWindow {
    id: settingsWindow
    minimumWidth: 150
    minimumHeight: 60
    width: 1100
    height: 750
    visible: Config.showSettings
    title: "Chaos Settings"

    color: "black"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Switch {
            id: bartoggle
            text: qsTr("Orientation")
            checked: false
            onClicked: Config.togglePossition()

        }
    }
}
