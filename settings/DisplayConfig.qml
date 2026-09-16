import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: pageRoot
    spacing: 24

    GridLayout {
        columns: root.isCompact || root.isMedium || root.isExpanded ? 1 : 2
        columnSpacing: 40
        rowSpacing: 20

        ColumnLayout {
            id: mainPane
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignTop
            spacing: 24

            ConfigGroup {
                title: "Brightness"
                icon: "brightness_7"

                Repeater {
                    model: Display.activeScreens

                    delegate: ConfigSlider {
                        readonly property string screenName: modelData
                        readonly property var info: Display.displayInfo[screenName] || {}

                        text: info.model || screenName
                        buttonIcon: info.backend === "backlight" ? "laptop_chromebook" : "monitor"
                        //description: ""
                        //liveUpdate: false
                        defaultValue: 100
                        valueSuffix: "%"
                        from: 0; to: 100; stepSize: 10
                        value: {
                            const state = ShellState.values.displayInfo[screenName];
                            return (state && state.brightness !== undefined) ? state.brightness : 100;
                        }
                        onMoved: (newValue) => Brightness.setBrightness(screenName, newValue)
                    }
                }
            }

            ConfigGroup {
                icon: "palette"
                title: "Appearance"

                ConfigSwitch {
                    buttonIcon: "moon_stars"
                    text: "Dark mode"
                    checked: !Config.options.appearance.light
                    onCheckedChanged: {
                        Config.options.appearance.light = !checked;
                        Theme.generate();
                    }
                }
                ConfigSwitch {
                    buttonIcon: "orbit"
                    text: "Show display corners"
                    checked: Config.options.appearance.showScreenRounding
                    onCheckedChanged: {
                        Config.options.appearance.showScreenRounding = checked;
                        //console.info ("Appearance: Screen rounding set to " + checked)
                    }
                }
            }

            ConfigGroup { // Visibility / Accessibility Section
                icon: "accessibility_new"
                title: "Accessibility and visibility"

                ConfigSlider {
                    text: "Font size"
                    buttonIcon: "text_fields"
                    liveUpdate: false
                    from: 80; to: 120; stepSize: 5
                    value: Config.options.appearance.fontScale
                    onMoved: (newValue) => {Config.options.appearance.fontScale = newValue;}
                }
                ConfigSlider {
                    text: "Display scale"
                    buttonIcon: "linear_scale"
                    //description: "Work in progress, currently only affects bar"
                    liveUpdate: false
                    from: 100; to: 140; stepSize: 5
                    value: Config.options.appearance.displayScale
                    onMoved: (newValue) => {Config.options.appearance.displayScale = newValue;}
                }
                ConfigSlider {
                    text: "Opacity"
                    buttonIcon: "blur_medium"
                    //description: ""
                    //liveUpdate: false
                    defaultValue: 100
                    valueSuffix: "%"
                    from: 0; to: 100; stepSize: 10
                    value: Config.options.appearance.opacity
                    onMoved: (newValue) => {Config.options.appearance.opacity = newValue;}
                }
                ConfigSlider {
                    text: "Rounding"
                    buttonIcon: "rounded_corner"
                    //description: ""
                    //liveUpdate: false
                    defaultValue: 100
                    valueSuffix: "%"
                    from: 0; to: 200; stepSize: 10
                    value: Config.options.appearance.rounding
                    onMoved: (newValue) => {Config.options.appearance.rounding = newValue;}
                }
            }
        }


    ColumnLayout {
        id: supportingPane
        Layout.alignment: Qt.AlignTop
        Layout.fillHeight: false
        Layout.fillWidth: true
        spacing: 24

        ConfigGroup { // OSD Section
            icon: "instant_mix"
            title: "On-screen display"
            description: "Show a bar indicating volume and brightness levels as they change."
            descriptionIcon: ""
            footer: "The OSD automatically fades away after a few seconds."
            footerIcon: "info"

            ConfigSwitch {
                buttonIcon: "preview"
                isMainToggle: true
                text: "Enable"
                description: ""
                checked: Config.options.osd.enable
                onCheckedChanged: {
                    Config.options.osd.enable = checked;
                    //console.log ("OSD: Enabled set to " + checked)
                }
            }
            ConfigSwitch {
                buttonIcon: "touch_long"
                text: "Enable dragging"
                description: "Allow mouse and touch drag inputs on the bar"
                checked: Config.options.osd.draggable
                onCheckedChanged: {
                    Config.options.osd.draggable = checked;
                    //console.log ("OSD: Dragging set to " + checked)
                }
            }
            ConfigSwitch {
                buttonIcon: Config.options.osd.showPercent ? "percent" : "adjust"
                text: "Show percentage"
                description: "Replace dot at the end of the OSD"
                checked: Config.options.osd.showPercent
                onCheckedChanged: {
                    Config.options.osd.showPercent = checked;
                    //console.log ("OSD: Percent display set to " + checked)
                }
            }
            ConfigSwitch {
                buttonIcon: "more_horiz"
                text: "Show dots"
                description: "Display dots inside the slider"
                checked: Config.options.osd.showDots
                onCheckedChanged: {
                    Config.options.osd.showDots = checked;
                    //console.log ("OSD: Enabled set to " + checked)
                }
            }
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
