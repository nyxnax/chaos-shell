import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    ConfigRow { // Customization Section
        MaterialSymbol {text: "format_paint"}
        StyledText {text: "Customization"}
    }

    ConfigRow {
        uniform: false
        StyledSwitch {
            checked: Config.options.appearance.light
            onCheckedChanged: {
                Config.options.appearance.light = checked;
                console.log ("Config: Theme mode changed")
            }
            onToggled: {
                console.log("Light mode set to: " + checked);
                Config.options.appearance.light = checked;
                Theme.generate();
            }
        }
        StyledText {
            text: "Light mode"
            font.pixelSize: 18
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

    ConfigRow { // Accessibility Section
        MaterialSymbol {text: "visibility"}
        StyledText {text: "Visability and Accessibility"}
    }

    Column {
        spacing: 2;
        ConfigRow {StyledText {text: "Font size"}}
        ConfigRow {
            Slider {
                id: fontSlider
                from: 80
                to: 200
                stepSize: 20
                snapMode: Slider.SnapAlways

                value: Config.options.appearance.fontScale

                onMoved: {
                    Config.options.appearance.fontScale = value;
                    console.log("Font Scale Changed to: " + value + "%");
                }
            }
            StyledText { text: fontSlider.value + "%"; font.pixelSize: Appearance.font.pixelSize.smaller; opacity: 0.5}
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
