import QtQuick
import QtQuick.Layouts
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
                //console.log ("Bar: Bar bottom set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "visibility_off"
            text: "Auto-hide"
            description: "Hides bar when there is no cursor on it"
            checked: Config.options.bar.autoHide
            onCheckedChanged: {
                Config.options.bar.autoHide = checked;
                //console.log ("Bar: Auto-hide set to " + checked)
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
                //console.log ("Bar: Workspace icons set to " + checked)
            }
        }
        ConfigSwitch {
            buttonIcon: "title"
            text: "Window title"
            description: "Display the active window's title in the bar"
            checked: Config.options.bar.showWindowTitle
            onCheckedChanged: {
                Config.options.bar.showWindowTitle = checked;
                //console.log ("Bar: Window title set to " + checked)
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
            description: "Displays current media title and artist"
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
    }

    ConfigGroup { // Just here as fluff
        icon: "dashboard"
        title: "Test"
        ConfigSwitch { text: "Item 1"; description: "These do nothing, they're just here as fluff for testing and showcase" }
        ConfigSwitch { text: "Item 2" }
        ConfigSwitch { text: "Item 3" }
    }
}
