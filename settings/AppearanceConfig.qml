import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    spacing: 15

    ConfigGroup { // Theming Section
        icon: "format_paint"
        title: "Theme"
        ConfigSwitch {
            buttonIcon: Config.options.appearance.light ? "brightness_7" : "moon_stars"
            text: Config.options.appearance.light ? "Light Mode" : "Dark Mode"
            checked: Config.options.appearance.light
            onCheckedChanged: {
                Config.options.appearance.light = checked;
                console.log ("Appearance: Light theme set to " + checked)
                Theme.generate();
            }
        }
    }

    ConfigRow {
        ComboBox {
            id: schemeBox
            textRole: "label"

            // 1. The Mapping (Value -> Index)
            readonly property var indexMap: {
                "scheme-content": 0,
                "scheme-expressive": 1,
                "scheme-fidelity": 2,
                "scheme-fruit-salad": 3,
                "scheme-monochrome": 4,
                "scheme-neutral": 5,
                "scheme-rainbow": 6,
                "scheme-tonal-spot": 7,
                "scheme-vibrant": 8
            }

            // 2. The Live Binding (Just like 'checked' in your switch)
            currentIndex: indexMap[Config.options.appearance.scheme] ?? 0

            model: ListModel {
                ListElement { label: "Content"; value: "scheme-content" }
                ListElement { label: "Expressive"; value: "scheme-expressive" }
                ListElement { label: "Fidelity"; value: "scheme-fidelity" }
                ListElement { label: "Fruit salad"; value: "scheme-fruit-salad" }
                ListElement { label: "Monochrome"; value: "scheme-monochrome" }
                ListElement { label: "Neutral"; value: "scheme-neutral" }
                ListElement { label: "Rainbow"; value: "scheme-rainbow" }
                ListElement { label: "Tonal Spot"; value: "scheme-tonal-spot" }
                ListElement { label: "Vibrant"; value: "scheme-vibrant" }
            }

            // 3. The Action (Just like 'onToggled' in your switch)
            onActivated: (index) => {
                let newValue = model.get(index).value;
                console.log("Config: Scheme changed to " + newValue);

                Config.options.appearance.scheme = newValue;
                Theme.generate();
            }
        }
        StyledText {text: "Color scheme"}
    }

    Rectangle{height: 12; color:"transparent"} // Spacing

    ConfigGroup { // Visibility / Accessibility Section
        icon: "accessibility_new"
        title: "Accessibility and Visibility"
        ConfigRow {
            MaterialSymbol {text: "text_fields"}
            StyledText {text: "Font size"}
            Item {Layout.fillWidth: true}
            StyledSlider {
                id: fontSlider
                from: 80; to: 140; stepSize: 10; snapMode: Slider.SnapAlways
                value: Config.options.appearance.fontScale

                onMoved: {
                    Config.options.appearance.fontScale = value;
                    console.log("Font Scale Changed to: " + value + "%");
                }
            }
            StyledText { text: fontSlider.value + "%"; opacity: 0.5}
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
                console.log ("OSD: Enabled set to " + checked)
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
            description: "Display dots on bar (WARNING! Currently broken)"
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
