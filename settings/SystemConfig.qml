import QtQuick // Just for the Item {} padding
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.modules.bar

ColumnLayout {
    id:root
    spacing: 24

    ConfigGroup { // Profile Section
        title: "Profile"
        icon: "id_card"
        ProfileCard {isExpanded: true; size: ProfileCard.Size.XL}
        ConfigSwitch {
            buttonIcon: "photo"
            text: "Use picture"
            description: "Stored at ~/.face"
            checked: Config.options.system.profile.usePicture
            onCheckedChanged: Config.options.system.profile.usePicture = checked
        }
        ConfigTile {
            visible: !Config.options.system.profile.usePicture
            buttonIcon: Config.options.system.profile.icon
            text: "Profile icon"
            description: "Icon to fall back to when not using a picture"
            control: StyledTextField {
                outlined: true
                placeholderText: "person"
                text: Config.options.system.profile.icon
                onTextChanged: {
                    if (Config.options.system.profile.icon !== text) {
                        Config.options.system.profile.icon = text
                    }
                }
            }
        }
    }

    ConfigGroup { // Power Profiles Section
        visible: PowerService.available
        title: "Power"
        icon: "power"
        ConfigButtonGroup {
            text: "Profile"
            buttonIcon: "electrical_services"
            model: PowerService.profilesModel
            currentValue: PowerService.activeProfile
            onChoiceSelected: (value) => {
                PowerService.setProfile(value);
            }
        }

        Item {} // Padding
        StyledCallout {
            icon: "info"
            text: "Power info"
        }

        StyledCallout {
            opacity: 0.8
            RowLayout {
                MaterialSymbol {fill: 1; text: "trending_down";}
                StyledText {text: "Degradation state: " + PowerService.degradationStateText}
            }
            RowLayout {
                MaterialSymbol { fill: 1; text: "comment"}
                StyledText {text: "Degradation reason: " + PowerService.degradationReasonText}
            }
        }
    }

    ConfigGroup{ // Battery Section
        visible: Battery.available
        title: "Battery"
        icon: "battery_android_full"
        ConfigGroup {
            ConfigSwitch{
                buttonIcon: "ear_sound"
                text: "Sounds"
                description: "Enable sounds related to power and battery (Plugged, unplugged, low, critical)"
                checked: Config.options.battery.sounds
                onCheckedChanged: {
                    Config.options.battery.sounds = checked;
                }
            }
            ConfigSwitch{
                buttonIcon: "power_off"
                text: "Automatic suspend"
                description: "Suspend system when at very low battery to avoid losing progress"
                checked: Config.options.battery.automaticSuspend
                onCheckedChanged: {
                    Config.options.battery.automaticSuspend = checked;
                }
            }
        }
        ConfigGroup {
            //descriptionIcon: "percent"
            //description: "Percentages"
            ConfigSlider {
                buttonIcon:"emergency_home"
                text: "Suspend percentage"
                description: "Trigger automatic system suspend when reached"
                defaultValue: 3
                valueSuffix: ""
                from: 1; to: Config.options.battery.critical; stepSize: 1
                value: Config.options.battery.suspend
                onMoved: (newValue) => {Config.options.battery.suspend = newValue;}
            }
            ConfigSlider {
                buttonIcon:"battery_android_1"
                text: "Critical percentage"
                description: ""
                defaultValue: 10
                valueSuffix: ""
                from: 1; to: Config.options.battery.low; stepSize: 1
                value: Config.options.battery.critical
                onMoved: (newValue) => {Config.options.battery.critical = newValue;}
            }
            ConfigSlider {
                buttonIcon:"battery_android_2"
                text: "Low percentage"
                description: ""
                defaultValue: 20
                valueSuffix: ""
                from: Config.options.battery.critical; to: 30; stepSize: 1
                value: Config.options.battery.low
                onMoved: (newValue) => {Config.options.battery.low = newValue;}
            }
            ConfigSlider {
                buttonIcon:"battery_android_full"
                text: "Full percentage"
                description: ""
                defaultValue: 100
                valueSuffix: ""
                from: 80; to: 100; stepSize: 1
                value: Config.options.battery.full
                onMoved: (newValue) => {Config.options.battery.full = newValue;}
            }
        }

        Item {} // Padding
        StyledCallout {
            icon: "info"
            text: "Battery info";
        }
        StyledCallout {
            opacity: 0.8
            RowLayout {
                MaterialSymbol{fill: 1; text: "percent"}
                StyledText {text: "Battery percentage: " + `${Math.round(Battery.percentage * 100)}%`}
            }
            RowLayout {
                MaterialSymbol{fill: 1; text: "bolt"}
                StyledText {text: "Usage: " + `${Battery.energyRate.toFixed(2)} W`}
            }
            RowLayout {
                MaterialSymbol{fill: 1; text: "timer"}
                StyledText {text:{if (Battery.chargeState == 4) {return "Fully charged";} else if (Battery.chargeState == 1) {return "Charging: ";} else {return "Discharging: ";}}}
                StyledText {text: {function formatTime(seconds) {var h = Math.floor(seconds / 3600); var m = Math.floor((seconds % 3600) / 60); if (h > 0) return `${h}h, ${m}m`; else return `${m}m`;} if (Battery.isCharging) return formatTime(Battery.timeToFull);else if (Battery.chargeState == 4) {return ""}; return formatTime(Battery.timeToEmpty);}}
            }
            RowLayout{
                MaterialSymbol{fill: 1; text: "heart_check"}
                StyledText {text: "Health: " + `${(Battery.health).toFixed(1)}%`}
            }
        }
    }

    ConfigGroup { // Audio Section
        title: "Audio"
        icon: "volume_up"
        ConfigSwitch {
            buttonIcon: "hearing_aid"
            text: "Protection"
            description: "Disallow any sudden jumps in volume for safety"
            checked: Config.options.audio.protection.enable
            onCheckedChanged: {
                Config.options.audio.protection.enable = checked;
                //console.log ("System: Audio protection set to " + checked)
            }
        }
    }
}
