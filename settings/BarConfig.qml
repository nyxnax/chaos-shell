import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ColumnLayout {
    id: root
    width: 500
    spacing: 15

    ConfigGroup {
        id: arrangementGroup
        icon: "responsive_layout"
        title: "Arrangement"

        readonly property var positionsModel: [
            { name: "Top",      value: "top",       icon: "top_panel_close" },
            { name: "Bottom",   value: "bottom",    icon: "bottom_panel_close" },
            { name: "Left",     value: "left",      icon: "left_panel_close" },
            { name: "Right",    value: "right",     icon: "right_panel_close" },
        ]

        ConfigButtonGroup {
            id: globalArrangement
            text: "Global (Default)"
            buttonIcon: "globe"
            model: arrangementGroup.positionsModel
            currentValue: Config.options.bar.position
            onChoiceSelected: (value) => Config.options.bar.position = value
        }
    }

    ConfigGroup{
        ConfigSwitch {
            buttonIcon: "splitscreen"
            text: "Per Display Position"
            description: ""
            checked: Config.options.bar.enablePerDisplayPosition
            onCheckedChanged: {
                Config.options.bar.enablePerDisplayPosition = checked;
            }
        }
    }

    ConfigGroup {
        shouldShow: Config.options.bar.enablePerDisplayPosition
        Repeater {
            model: Display.activeScreens

            ConfigButtonGroup {
                id: displayArrangement
                text: "Display: " + modelData
                buttonIcon: info.backend === "backlight" ? "laptop_chromebook" : "monitor"
                model: arrangementGroup.positionsModel

                property string displayName: String(modelData)
                readonly property var info: Display.displayInfo[displayName] || {}

                currentValue: BarService.getPosition(displayArrangement.displayName)
                onChoiceSelected: (value) => BarService.setPosition(displayArrangement.displayName, value)
            }
        }
    }

    ConfigGroup { // Globbal Widgets Section
        id: globalWidgetGroup
        icon: "extension"
        title: "Global Widgets"

        property string selectedArea: "left"

        ConfigButtonGroup {
            text: "Target Area"
            model: [
                { name: "Left", value: "left", icon: "align_horizontal_left" },
                { name: "Center", value: "center", icon: "align_horizontal_center" },
                { name: "Right", value: "right", icon: "align_horizontal_right" }
            ]
            currentValue: globalWidgetGroup.selectedArea
            onChoiceSelected: (val) => globalWidgetGroup.selectedArea = val
        }

        ConfigGroup {
            Repeater {
                id: globalRepeater
                model: BarService.getWidgetsFor("default", globalWidgetGroup.selectedArea)

                delegate: ConfigButtonGroup {
                    readonly property var info: BarService.getWidgetInfo(modelData)
                    text: info.name
                    buttonIcon: info.icon
                    currentValue: null
                    fullWidth: false

                    model: [
                        { name: "", icon: "arrow_upward", value: "up", action: () => BarService.moveWidget("default", globalWidgetGroup.selectedArea, index, index - 1) },
                        { name: "", icon: "arrow_downward", value: "down", action: () => BarService.moveWidget("default", globalWidgetGroup.selectedArea, index, index + 1) },
                        { name: "", icon: "delete", value: "remove", action: () => BarService.removeWidget("default", globalWidgetGroup.selectedArea, index) }
                    ]

                    onChoiceSelected: (val) => {
                        const item = model.find(i => i.value === val);
                        if (item && item.action) item.action();
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ConfigButtonGroup {
                id: globalPicker
                text: "Add Widget"
                Layout.fillWidth: true
                model: BarService.availableWidgets
                property string toAdd: ""
                currentValue: toAdd
                onChoiceSelected: (val) => toAdd = val
            }

            StyledButton {
                buttonIcon: "add"
                Layout.fillHeight: true
                enabled: globalPicker.toAdd !== ""
                onClicked: {
                    BarService.addWidget("default", globalWidgetGroup.selectedArea, globalPicker.toAdd);
                    globalPicker.toAdd = "";
                }
            }
        }

        ColumnLayout {
            StyledButton {
                text: "Reset to Default"
                buttonIcon: "restore"
                Layout.fillWidth: true
                onClicked: BarService.resetGlobal(globalWidgetGroup.selectedArea);
            }
        }
    }

    ConfigGroup { // Per Display Widgets section
        id: displayWidgetGroup
        icon: "extension"
        title: "Per Display Widgets"

        property string selectedArea: "left"
        property string selectedDisplay: Display.activeScreens[0] || ""

        ConfigSwitch {
            buttonIcon: ""
            text: "Enable"
            description: ""
            checked: Config.options.bar.enablePerDisplayWidgets
            onCheckedChanged: {
                Config.options.bar.enablePerDisplayWidgets = checked;
            }
        }

        ConfigGroup {
            shouldShow: Config.options.bar.enablePerDisplayWidgets

            ConfigButtonGroup {
                text: "Select Display"
                model: Display.activeScreens.map((displayName) => ({
                        name: displayName,
                        value: displayName,
                        icon: (Display.displayInfo[displayName] || {}).backend === "backlight"
                            ? "laptop_chromebook"
                            : "monitor"
                }))
                currentValue: displayWidgetGroup.selectedDisplay
                onChoiceSelected: (val) => displayWidgetGroup.selectedDisplay = val
            }

            ConfigButtonGroup {
                text: "Target Area"
                model: [
                    { name: "Left", value: "left", icon: "align_horizontal_left" },
                    { name: "Center", value: "center", icon: "align_horizontal_center" },
                    { name: "Right", value: "right", icon: "align_horizontal_right" }
                ]
                currentValue: displayWidgetGroup.selectedArea
                onChoiceSelected: (val) => displayWidgetGroup.selectedArea = val
            }

            ConfigGroup {
                Repeater {
                    id:widgetRepeater
                    model: BarService.getWidgetsFor(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea)

                    delegate: ConfigButtonGroup {
                        readonly property var info: BarService.getWidgetInfo(modelData)
                        text: info.name
                        buttonIcon: info.icon
                        currentValue: null
                        fullWidth: false

                        model: [
                            { name: "", icon: "arrow_upward", value: "up", action: () => BarService.moveWidget(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea, index, index - 1) },
                            { name: "", icon: "arrow_downward", value: "down", action: () => BarService.moveWidget(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea, index, index + 1) },
                            { name: "", icon: "delete", value: "remove", action: () => BarService.removeWidget(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea, index) }
                        ]

                        onChoiceSelected: (val) => {
                            const item = model.find(i => i.value === val);
                            if (item && item.action) item.action();
                        }
                    }
                }
            }

            RowLayout{
                ConfigButtonGroup {
                    id: availableWidgetPicker
                    text: "Add Widget"
                    Layout.fillWidth: true
                    model: BarService.availableWidgets
                    property string toAdd: ""
                    currentValue: toAdd
                    onChoiceSelected: (val) => toAdd = val

                }

                StyledButton {
                    buttonIcon: "add"
                    Layout.fillHeight: true

                    onClicked: {
                        BarService.addWidget(
                            displayWidgetGroup.selectedDisplay,
                            displayWidgetGroup.selectedArea,
                            availableWidgetPicker.toAdd
                        )
                        availableWidgetPicker.toAdd = ""
                    }
                }
            }
            ColumnLayout {
                StyledButton {
                    text: "Follow Global"
                    buttonIcon: "copy_all"
                    Layout.fillWidth: true
                    onClicked: BarService.copyGlobal(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea);
                }
            }
        }
    }

    ConfigGroup { // Main Section
        icon: "menu"
        title: "Main"
        //ConfigSwitch {
        //    buttonIcon: "screen_rotation_alt"
        //    text: "Bar position"
        //    description: "Switches the bar's position from top to bottom"
        //    checked: Config.options.bar.bottom
        //    onCheckedChanged: {
        //        Config.options.bar.bottom = checked;
        //        //console.log ("Bar: Bar bottom set to " + checked)
        //    }
        //}
        ConfigSwitch {
            buttonIcon: "visibility_off"
            text: "Auto-hide"
            description: "Hide bar when there is no cursor on it"
            checked: Config.options.bar.autoHide
            onCheckedChanged: {
                Config.options.bar.autoHide = checked;
                //console.log ("Bar: Auto-hide set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "gradient"
            text: "Widget Background"
            description: "Gives widgets a more visible background"
            checked: Config.options.bar.showBackground
            onCheckedChanged: {
                Config.options.bar.showBackground = checked;
                //console.log ("Bar: Background set to " + checked)
            }
        }
    }

        ConfigGroup { // Chaos Button Section
        icon: Config.options.bar.chaosIcon
        title: "Chaos Button"
        ConfigTile {
            buttonIcon: "code"
            text: "Command"
            description: "Runs when you press the button"
            control: StyledTextField {
                outlined: true
                placeholderText: ""
                text: Config.options.bar.chaosCommand
                onTextChanged: {
                    if (Config.options.bar.chaosCommand !== text) {
                        Config.options.bar.chaosCommand = text
                    }
                }
            }
        }
        ConfigTile {
            buttonIcon: "window"
            text: "Icon"
            description: "Example: 'orbit', 'planet' More at 'https://fonts.google.com/icons'"
            control: StyledTextField {
                outlined: true
                placeholderText: "apps"
                text: Config.options.bar.chaosIcon
                onTextChanged: {
                    if (Config.options.bar.chaosIcon !== text) {
                        Config.options.bar.chaosIcon = text
                    }
                }
            }
        }
        ConfigSwitch {
            buttonIcon: "format_color_fill"
            text: "Accent Color"
            checked: Config.options.bar.chaosAccent
            onCheckedChanged: {
                Config.options.bar.chaosAccent = checked;
            }
        }
    }

    ConfigGroup { // Focused Window and Workspace Indicator Section
        icon: "toolbar"
        title: "Windows and Workspaces"
        ConfigSwitch {
            buttonIcon: "title"
            text: "Active Window Title"
            description: "Display the focused window's title in the bar"
            checked: Config.options.bar.showWindowTitle
            onCheckedChanged: {
                Config.options.bar.showWindowTitle = checked;
                //console.log ("Bar: Window title set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "image"
            text: "Active Window Icon"
            description: "Display the focused app's icon "
            checked: Config.options.bar.showWindowIcon
            onCheckedChanged: {
                Config.options.bar.showWindowIcon = checked;
                //console.log ("Bar: Window icon set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "apps"
            text: "Workspace App icons"
            description: "Display app icons inside the occupied workspace indicators"
            checked: Config.options.bar.workspaceIcons
            onCheckedChanged: {
                Config.options.bar.workspaceIcons = checked;
                //console.log ("Bar: Workspace icons set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "power_settings_new"
            text: "Power Button"
            description: "Launches session manager when clicked"
            checked: Config.options.bar.showPowerButton
            onCheckedChanged: {
                Config.options.bar.showPowerButton = checked;
                //console.log ("Bar: Workspace icons set to " + checked)
            }
        }
    }

    ConfigGroup{ // Clock Section
        icon: "farsight_digital"
        title: "Date & Time"
        ConfigSwitch {
            buttonIcon: "nest_clock_farsight_analog"
            text: "Time"
            description: "Disable this to hide your time information on the bar"
            checked: Config.options.bar.showTime
            onCheckedChanged: {
                Config.options.bar.showTime = checked;
                //console.log ("Bar: Time set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "calendar_clock"
            text: "Date"
            description: "Display date beside clock, or alone if unavailable"
            checked: Config.options.bar.showDate
            onCheckedChanged: {
                Config.options.bar.showDate = checked;
                //console.log ("Bar: Date set to " + checked)
            }
        }
    }

    ConfigGroup{ // Media Section
        icon: "music_note"
        title: "Media Controller"
        ConfigSwitch {
            buttonIcon: Config.options.bar.showMedia ? "visibility" : "visibility_off"
            text: Config.options.bar.showMedia ? "Enabled" : "Disabled"
            description: "Display current media title and artist"
            checked: Config.options.bar.showMedia
            onCheckedChanged: {
                Config.options.bar.showMedia = checked;
                //console.log ("Bar: Media controller set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "art_track"
            text: "Cover art"
            description: "Display cover art from currently playing media"
            checked: Config.options.bar.showCoverArt
            onCheckedChanged: {
                Config.options.bar.showCoverArt = checked;
                //console.log ("Bar: Media cover art set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "album"
            text: "Artist name"
            description: "Display artirst name under the title"
            checked: Config.options.bar.showArtist
            onCheckedChanged: {
                Config.options.bar.showArtist = checked;
                //console.log ("Bar: Media artist set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "play_arrow"
            text: "Control"
            description: "Enable Play/Pause button beside the metadata"
            checked: Config.options.bar.showMediaControl
            onCheckedChanged: {
                Config.options.bar.showMediaControl = checked;
                //console.log ("Bar: Media control set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "text_ad"
            text: "Text"
            description: "Disable to keep cover art and/or control only"
            checked: Config.options.bar.showMediaText
            onCheckedChanged: {
                Config.options.bar.showMediaText = checked;
                //console.log ("Bar: Media control set to " + checked)
            }
        }
    }

    ConfigGroup { // Just here as fluff
        icon: "dashboard"
        title: "Test"
        ConfigSwitch { text: "Item 1"; description: "These do nothing, they're just here as fluff for testing and showcase" }
        ConfigSwitch { text: "Item 2" }
        ConfigSwitch { text: "Item 3" }
    }
}
