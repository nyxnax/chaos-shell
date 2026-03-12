import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common.widgets

ColumnLayout {
    spacing: 20

    ConfigRow {
        uniform: false
        StyledSwitch {
            checked: Config.options.appearance.light
            onCheckedChanged: {
                Config.options.appearance.light = checked;
                console.log ("Config: Theme mode changed")
            }
        }
        Text {
            text: "Light mode"
            color: "white"
            font.pixelSize: 18
        }
    }

    Button {
        text: matugenProcess.running ? "Generating..." : "Refresh theme"
        enabled: !matugenProcess.running
        Layout.fillWidth: true

        onClicked: {
            console.log("Starting Matugen...");
            matugenProcess.running = true;
        }
    }
}
