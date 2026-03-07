import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.settings

ApplicationWindow {
    id: settingsWindow
    minimumWidth: 720
    minimumHeight: 600
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
            text: "Orientation"
            checked: false
            onClicked: Config.togglePossition()
        }
    }
}
