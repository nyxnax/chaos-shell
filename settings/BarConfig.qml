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
        icon: "watch"
        title: "Time"
        ConfigSwitch {
            buttonIcon: "calendar_clock"
            text: "Date"
            description: "Show date next to clock"
            checked: Config.options.bar.date
            onCheckedChanged: {
                Config.options.bar.date = checked;
                console.log ("Bar: Date toggled")
            }
        }
    }

    ConfigGroup{ // Media Section
        icon: "music_note"
        title: "Media"
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
