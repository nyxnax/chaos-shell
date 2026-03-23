import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    spacing: 15

//    ConfigGroup { // Theming Section
//        icon: "format_paint"
//        title: "Theme"
//
//    }

    ConfigGroup { // Visibility / Accessibility Section
        icon: "accessibility_new"
        title: "Accessibility and Visibility"

        ConfigSlider {
            text: "Font Size"
            buttonIcon: "text_fields"
            liveUpdate: false
            from: 80; to: 120; stepSize: 5
            value: Config.options.appearance.fontScale
            onMoved: (newValue) => {Config.options.appearance.fontScale = newValue;}
        }
        ConfigSlider {
            text: "Display Scale"
            buttonIcon: "display_settings"
            description: "Work in progress, currently only affects bar"
            liveUpdate: false
            from: 100; to: 140; stepSize: 5
            value: Config.options.appearance.displayScale
            onMoved: (newValue) => {Config.options.appearance.displayScale = newValue;}
        }
        ConfigSwitch {
            buttonIcon: Config.options.appearance.light ? "brightness_7" : "moon_stars"
            text: Config.options.appearance.light ? "Light Mode" : "Dark Mode"
            checked: Config.options.appearance.light
            onCheckedChanged: {
                Config.options.appearance.light = checked;
                //console.log ("Appearance: Light theme set to " + checked)
                Theme.generate();
            }
        }
    }

    ConfigGroup { // OSD Section
        icon: "sliders"
        title: "OSD"
        ConfigSwitch {
            buttonIcon: "preview"
            text: "Enable"
            description: "Displays a bar on the screen indicating current volume and (soon) brightness levels when they are changed"
            checked: Config.options.osd.enable
            onCheckedChanged: {
                Config.options.osd.enable = checked;
                //console.log ("OSD: Enabled set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: Config.options.osd.showPercent ? "percent" : "adjust"
            text: "Show Percentage"
            description: "Replace dot at the end of the OSD"
            checked: Config.options.osd.showPercent
            onCheckedChanged: {
                Config.options.osd.showPercent = checked;
                //console.log ("OSD: Percent display set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "touch_long"
            text: "Enable Dragging"
            description: "Allows for mouse and touch drag inputs on the bar"
            checked: Config.options.osd.draggable
            onCheckedChanged: {
                Config.options.osd.draggable = checked;
                //console.log ("OSD: Dragging set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "more_horiz"
            text: "Dots"
            description: "Display dots inside the slider"
            checked: Config.options.osd.showDots
            onCheckedChanged: {
                Config.options.osd.showDots = checked;
                //console.log ("OSD: Enabled set to " + checked)
            }
        }
    }

//    Button {
//        text: matugenProcess.running ? "Generating..." : "Refresh theme"
//        enabled: !matugenProcess.running
//        Layout.fillWidth: true
//
//        onClicked: {
//            console.log("Starting Matugen...");
//            matugenProcess.running = true;
//        }
//    }
}
