import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common.widgets

ColumnLayout {
        id: genericUI
    ConfigRow {
        uniform: false
        StyledSwitch {
            checked: Config.options.bar.bottom
            onCheckedChanged: {
                Config.options.bar.bottom = checked;
                //console.log ("Config: Bar position set")
            }
        }
        Text {
            text: "Orientation"
            color: "white"
            font.pixelSize: 18
        }
        ToolTip {
            text: "Top - Bottom"
        }
    }
}
