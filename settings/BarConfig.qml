import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root

    ConfigRow {// Main Section
        MaterialSymbol {text: "dashboard"}
        StyledText {text: "Main"}
    }

    ConfigRow {
        uniform: false
        StyledSwitch {
            checked: Config.options.bar.bottom
            onCheckedChanged: {
                Config.options.bar.bottom = checked;
                console.log ("Bar: Position set")
            }
        }
        StyledText {text: "Orientation"}
        ToolTip {
            text: "Top - Bottom"
        }
    }

    Rectangle{height: 12; color:"transparent"} // Spacing

    ConfigRow { // Clock Section
        MaterialSymbol {text: "watch"}
        StyledText {text: "Clock"}
    }


    ConfigRow {
        StyledSwitch {
            checked: Config.options.bar.date
            onCheckedChanged: {
                Config.options.bar.date = checked;
                console.log ("Bar: Date toggled")
            }
        }
        StyledText {text: "Show date"}
    }
}
