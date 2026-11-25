import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

ColumnLayout {
    id: pageRoot
    width: 500
    spacing: 24

    GridLayout {
        columns: root.isCompact || root.isMedium || root.isExpanded ? 1 : 2
        columnSpacing: 40
        rowSpacing: 20

        ColumnLayout {
            id: mainPane
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredWidth: 600
            spacing: 24

            ConfigGroup { // Main Section
                icon: "category"
                title: "Behaviour"

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
                    text: "Widget background"
                    description: "Gives widgets a more visible background"
                    checked: Config.options.bar.showBackground
                    onCheckedChanged: {
                        Config.options.bar.showBackground = checked;
                        //console.log ("Bar: Background set to " + checked)
                    }
                }
            }

            ConfigGroup {
                id: positionGroup
                icon: "responsive_layout"
                title: "Position"

                readonly property var positionsModel: [
                    { name: "Top",      value: "top",       icon: "top_panel_close" },
                    { name: "Bottom",   value: "bottom",    icon: "bottom_panel_close" },
                    { name: "Left",     value: "left",      icon: "left_panel_close" },
                    { name: "Right",    value: "right",     icon: "right_panel_close" },
                ]

                ConfigGroup {
                    ConfigButtonFlow {
                        text: "Global (Default)"
                        buttonIcon: "globe"
                        model: positionGroup.positionsModel
                        currentValue: Config.options.bar.position
                        onChoiceSelected: (value) => Config.options.bar.position = value
                    }
                }

                ConfigGroup{
                    spacing: 0

                    ConfigSwitch {
                        buttonIcon: "splitscreen"
                        text: "Enable per display position"
                        description: ""
                        isMainToggle: true
                        checked: Config.options.bar.enablePerDisplayPosition
                        onCheckedChanged: {
                            Config.options.bar.enablePerDisplayPosition = checked;
                        }
                    }

                    ConfigGroup {
                        spacing: 0
                        shouldShow: Config.options.bar.enablePerDisplayPosition
                        Repeater {
                            model: Display.activeScreens

                            ConfigButtonFlow {
                                text: "Display: " + modelData
                                buttonIcon: info.backend === "backlight" ? "laptop_chromebook" : "monitor"
                                model: positionGroup.positionsModel

                                property string displayName: String(modelData)
                                readonly property var info: Display.displayInfo[displayName] || {}

                                currentValue: BarService.getPosition(displayName)
                                onChoiceSelected: (value) => BarService.setPosition(displayName, value)
                            }
                        }
                    }
                }
            }

            ConfigGroup { // Globbal Widgets Section
                id: globalWidgetGroup
                icon: "extension"
                title: "Widgets"

                property string selectedArea: "left"

                ConfigButtonGroup {
                    text: "Target area"
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

                    ConfigButtonFlow {
                        id: globalPicker
                        text: "Select widget to add"
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
                        text: "Reset to default"
                        buttonIcon: "restore"
                        Layout.fillWidth: true
                        onClicked: BarService.resetGlobal(globalWidgetGroup.selectedArea);
                    }
                }
            }

            ConfigGroup { // Per Display Widgets section
                id: displayWidgetGroup

                property string selectedArea: "left"
                property string selectedDisplay: Display.activeScreens[0] || ""

                ConfigSwitch {
                    buttonIcon: "extension"
                    text: "Enable per display widgets"
                    description: ""
                    isMainToggle: true
                    checked: Config.options.bar.enablePerDisplayWidgets
                    onCheckedChanged: {
                        Config.options.bar.enablePerDisplayWidgets = checked;
                    }
                }

                ConfigGroup {
                    shouldShow: Config.options.bar.enablePerDisplayWidgets

                    ConfigButtonGroup {
                        text: "Select display"
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
                        text: "Target area"
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
                        ConfigButtonFlow {
                            id: availableWidgetPicker
                            text: "Select widget to add"
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
                            text: "Follow global"
                            buttonIcon: "copy_all"
                            Layout.fillWidth: true
                            onClicked: BarService.copyGlobal(displayWidgetGroup.selectedDisplay, displayWidgetGroup.selectedArea);
                        }
                    }
                }
            }
        }


        ColumnLayout {
            id: supportingPane
            Layout.fillHeight: false
            Layout.fillWidth: true
            spacing: 24

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
                    text: "Accent color"
                    checked: Config.options.bar.chaosAccent
                    onCheckedChanged: {
                        Config.options.bar.chaosAccent = checked;
                    }
                }
            }

            ConfigGroup{ // Clock Section
                icon: "farsight_digital"
                title: "Clock"
                ConfigButtonFlow {
                    buttonIcon: "mist"
                    text: "Mode"
                    model: [
                        { name: "Both", icon: "calendar_clock", value: "both" },
                        { name: "Time", icon: "schedule",       value: "time" },
                        { name: "Date", icon: "calendar_today", value: "date" }
                    ]

                    currentValue: Config.options.bar.clockMode
                    onChoiceSelected: (val) => Config.options.bar.clockMode = val
                }
            }

            ConfigGroup { // Active Window Section
                icon: "title"
                title: "Active window title"
                ConfigSwitch {
                    buttonIcon: "image"
                    text: "Show icon"
                    description: "Display the focused app's icon"
                    checked: Config.options.bar.showWindowIcon
                    onCheckedChanged: {
                        Config.options.bar.showWindowIcon = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "text_format"
                    text: "Show text"
                    description: "Display the focused window's title"
                    checked: Config.options.bar.showWindowTitle
                    onCheckedChanged: {
                        Config.options.bar.showWindowTitle = checked;
                    }
                }
            }

            ConfigGroup{ // Workspaces Section
                icon: "workspaces"
                title: "Workspaces"
                ConfigSwitch {
                    buttonIcon: "apps"
                    text: "Show app icons"
                    description: "Display app icons inside the occupied workspace indicators"
                    checked: Config.options.bar.workspaceIcons
                    onCheckedChanged: {
                        Config.options.bar.workspaceIcons = checked;
                    }
                }
                ConfigSlider {
                    buttonIcon: "steppers"
                    text: "Minimum per display"
                    description: "Maximum number of workspace indicators to show per display"
                    defaultValue: 3
                    valueSuffix: ""
                    from: 1; to: Config.options.bar.workspaceMaxPerMonitor; stepSize: 1
                    value: Config.options.bar.workspaceMinPerMonitor
                    onMoved: (newValue) => {Config.options.bar.workspaceMinPerMonitor = newValue;}
                }
                ConfigSlider {
                    buttonIcon: "page_control"
                    text: "Maximum per display"
                    description: "Maximum number of workspace indicators to show per display"
                    defaultValue: 10
                    valueSuffix: ""
                    from: Config.options.bar.workspaceMinPerMonitor; to: 10; stepSize: 1
                    value: Config.options.bar.workspaceMaxPerMonitor
                    onMoved: (newValue) => {Config.options.bar.workspaceMaxPerMonitor = newValue;}
                }
            }


            ConfigGroup{ // Media Section
                icon: "music_note"
                title: "Media Controller"
                footer: "Automatically hidden when no media source is active"
                footerIcon: "info"
                ConfigSwitch {
                    buttonIcon: Config.options.bar.showMedia ? "visibility" : "visibility_off"
                    text: Config.options.bar.showMedia ? "Enabled" : "Disabled"
                    description: ""
                    isMainToggle: true
                    checked: Config.options.bar.showMedia
                    onCheckedChanged: {
                        Config.options.bar.showMedia = checked;
                        //console.log ("Bar: Media controller set to " + checked)
                    }
                }
                ConfigSwitch {
                    buttonIcon: "art_track"
                    text: "Show cover art"
                    description: "Display cover art from currently playing media"
                    checked: Config.options.bar.showCoverArt
                    onCheckedChanged: {
                        Config.options.bar.showCoverArt = checked;
                        //console.log ("Bar: Media cover art set to " + checked)
                    }
                }
                ConfigSwitch {
                    buttonIcon: "play_arrow"
                    text: "Show control button"
                    description: "Enable Play/Pause button beside the metadata"
                    checked: Config.options.bar.showMediaControl
                    onCheckedChanged: {
                        Config.options.bar.showMediaControl = checked;
                        //console.log ("Bar: Media control set to " + checked)
                    }
                }
                ConfigSwitch {
                    buttonIcon: "text_ad"
                    text: "Show text"
                    description: "(Automatically disabled on vertical bars) Disable to keep cover art and/or control only"
                    checked: Config.options.bar.showMediaText
                    onCheckedChanged: {
                        Config.options.bar.showMediaText = checked;
                        //console.log ("Bar: Media control set to " + checked)
                    }
                }
                ConfigSwitch {
                    buttonIcon: "album"
                    text: "Show artist name"
                    description: "Display artirst name under the title"
                    checked: Config.options.bar.showArtist
                    onCheckedChanged: {
                        Config.options.bar.showArtist = checked;
                        //console.log ("Bar: Media artist set to " + checked)
                    }
                }
            }

            ConfigGroup { // System Stats Section
                icon: "browse_activity"
                title: "System Stats"
                footerIcon: "info"
                footer: "Stats are updated every 2 seconds"
                ConfigGroup {
                    ConfigSwitch{
                        buttonIcon: "memory"
                        text: "Show CPU usage"
                        description: ""
                        checked: Config.options.bar.showCpuPercent
                        onCheckedChanged: {
                            Config.options.bar.showCpuPercent = checked;
                        }
                    }
                }
                ConfigGroup {
                    ConfigSwitch{
                        buttonIcon: "memory_alt"
                        text: "Show RAM usage"
                        description: ""
                        checked: Config.options.bar.showRamPercent
                        onCheckedChanged: {
                            Config.options.bar.showRamPercent = checked;
                        }
                    }
                    ConfigSwitch{
                        buttonIcon: "numbers"
                        text: "Show RAM usage values"
                        description: ""
                        checked: Config.options.bar.showRamUsage
                        onCheckedChanged: {
                            Config.options.bar.showRamUsage = checked;
                        }
                    }
                    ConfigSwitch{
                        buttonIcon: "highlight_mouse_cursor"
                        text: "Show RAM usage values on hover"
                        description: ""
                        checked: Config.options.bar.showRamUsageOnHover
                        onCheckedChanged: {
                            Config.options.bar.showRamUsageOnHover = checked;
                        }
                    }
                }
                ConfigGroup {
                    ConfigSwitch{
                        buttonIcon: "highlight_mouse_cursor"
                        text: "Show percentages on hover"
                        description: ""
                        checked: Config.options.bar.showSystemStatsPercentOnHover
                        onCheckedChanged: {
                            Config.options.bar.showSystemStatsPercentOnHover = checked;
                        }
                    }
                }
            }

            ConfigGroup{ // Control Center Section
                icon: "wifi"
                title: "Control Center"
                ConfigGroup {
                    ConfigSwitch {
                        buttonIcon: "bluetooth"
                        text: "Show Bluetooth icon"
                        //description: ""
                        checked: Config.options.bar.showBluetoothSymbol
                        onCheckedChanged: {
                            Config.options.bar.showBluetoothSymbol = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "hide"
                        text: "Hide Bluetooth icon when disabled"
                        //description: ""
                        checked: Config.options.bar.hideBluetoothSymbolWhenDisabled
                        onCheckedChanged: {
                            Config.options.bar.hideBluetoothSymbolWhenDisabled = checked;
                        }
                    }
                }
                ConfigGroup {
                    ConfigSwitch {
                        buttonIcon: "volume_up"
                        text: "Always show volume icon"
                        description: "When turned off, the icon stays hidden unless output is muted"
                        checked: Config.options.bar.showSinkSymbol
                        onCheckedChanged: {
                            Config.options.bar.showSinkSymbol = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "waves"
                        text: "Show on volume changed"
                        description: "Only show for 3 seconds when output volume is changed"
                        checked: Config.options.bar.showSinkOnVolumeChanged
                        onCheckedChanged: {
                            Config.options.bar.showSinkOnVolumeChanged = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "percent"
                        text: "Show percentage"
                        description: ""
                        checked: Config.options.bar.showSinkPercent
                        onCheckedChanged: {
                            Config.options.bar.showSinkPercent = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "highlight_mouse_cursor"
                        text: "Show percentage on hover"
                        description: ""
                        checked: Config.options.bar.showSinkPercentOnHover
                        onCheckedChanged: {
                            Config.options.bar.showSinkPercentOnHover = checked;
                        }
                    }
                }
                ConfigGroup {
                    ConfigSwitch {
                        buttonIcon: "download"
                        text: "Show download speed"
                        description: ""
                        checked: Config.options.bar.showDownloadSpeed
                        onCheckedChanged: {
                            Config.options.bar.showDownloadSpeed = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "upload"
                        text: "Show upload speed"
                        description: ""
                        checked: Config.options.bar.showUploadSpeed
                        onCheckedChanged: {
                            Config.options.bar.showUploadSpeed = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "hide"
                        text: (Config.options.bar.showDownloadSpeed && Config.options.bar.showUploadSpeed) ? "Hide indicators when at 0 B/s" : "Hide indicator when at 0 B/s"
                        description: ""
                        checked: Config.options.bar.hideNetworkSpeedWhenZero
                        onCheckedChanged: {
                            Config.options.bar.hideNetworkSpeedWhenZero = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "highlight_mouse_cursor"
                        text: (Config.options.bar.showDownloadSpeed && Config.options.bar.showUploadSpeed) ? "Show indicators on Hover" : "Show indicator on Hover"
                        description: ""
                        checked: Config.options.bar.showNetworkSpeedOnHover
                        onCheckedChanged: {
                            Config.options.bar.showNetworkSpeedOnHover = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "123"
                        text: "Show speed value"
                        description: ""
                        checked: Config.options.bar.showNetworkSpeedText
                        onCheckedChanged: {
                            Config.options.bar.showNetworkSpeedText = checked;
                        }
                    }
                    ConfigSwitch {
                        buttonIcon: "arrow_selector_tool"
                        text: "Show speed value on hover"
                        description: ""
                        checked: Config.options.bar.showNetworkSpeedTextOnHover
                        onCheckedChanged: {
                            Config.options.bar.showNetworkSpeedTextOnHover = checked;
                        }
                    }
                }
            }

            ConfigGroup { // Battery Section
                shouldShow: Battery.available
                icon: "battery_android_full"
                title: "Battery"
                footer: "This section only appears if you have a battery >:3"
                footerIcon: "info"
                ConfigSwitch {
                    buttonIcon: "percent"
                    text: "Show percentage"
                    description: "Show battery percentage inside the indicator (shows on hover if disabled)"
                    checked: Config.options.bar.showBatteryPercentage
                    onCheckedChanged: {
                        Config.options.bar.showBatteryPercentage = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "electrical_services"
                    text: "Hide when plugged in"
                    description: "Hide the widget while connected to AC power"
                    checked: Config.options.bar.hideBatteryWhenPlugged
                    onCheckedChanged: {
                        Config.options.bar.hideBatteryWhenPlugged = checked;
                    }
                }
                ConfigSwitch {
                    buttonIcon: "battery_android_frame_bolt"
                    text: "Hide when full"
                    description: "Hide the widget when fully charged"
                    checked: Config.options.bar.hideBatteryWhenFull
                    onCheckedChanged: {
                        Config.options.bar.hideBatteryWhenFull = checked;
                    }
                }
            }

            ConfigGroup { // Just here as fluff
                icon: "dashboard"
                title: "Test"
                footer: "idk why I haven't removed this section"
                ConfigSwitch { text: "Item 1"; description: "These do nothing, they're just here as fluff for testing and showcase" }
                ConfigSwitch { text: "Item 2" }
                ConfigSwitch { text: "Item 3" }
            }
        }
    }
}
