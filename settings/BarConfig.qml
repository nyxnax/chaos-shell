import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    width: 500
    spacing: 15

    ConfigGroup {// Main Section
        ConfigSwitch {
            buttonIcon: "screen_rotation_alt"
            text: "Bar position"
            description: "Switches the bar's position from top to bottom"
            checked: Config.options.bar.bottom
            onCheckedChanged: {
                Config.options.bar.bottom = checked;
                console.log ("Bar: Bar position switched")
            }
        }
    }

    ConfigGroup { // Workspaces Section
        icon: "view_carousel"
        title: "Workspaces"
        ConfigSwitch {
            buttonIcon: "apps"
            text: "App icons"
            description: "Display app icons inside the workspace indicators"
            checked: Config.options.bar.workspaceIcons
            onCheckedChanged: {
                Config.options.bar.workspaceIcons = checked;
                console.log ("Bar: Workspace icons toggled")
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
                console.log ("Bar: Time toggled")
            }
        }
        ConfigSwitch {
            buttonIcon: "calendar_clock"
            text: "Date"
            description: "Display date beside clock, or alone if unavailable"
            checked: Config.options.bar.showDate
            onCheckedChanged: {
                Config.options.bar.showDate = checked;
                console.log ("Bar: Date toggled")
            }
        }
    }

    ConfigGroup{ // Media Section
        icon: "music_note"
        title: "Media Controller"
        ConfigSwitch {
            buttonIcon: Config.options.bar.showMedia ? "visibility" : "visibility_off"
            text: Config.options.bar.showMedia ? "Enabled" : "Disabled"
            description: "Displays current media title and artist"
            checked: Config.options.bar.showMedia
            onCheckedChanged: {
                Config.options.bar.showMedia = checked;
                console.log ("Bar: Media controller toggled")
            }
        }
        ConfigSwitch {
            buttonIcon: "art_track"
            text: "Cover art"
            description: "Display cover art from currently playing media"
            checked: Config.options.bar.showCoverArt
            onCheckedChanged: {
                Config.options.bar.showCoverArt = checked;
                console.log ("Bar: Cover art toggled")
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
