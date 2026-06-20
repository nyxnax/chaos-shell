import QtQuick // Just for the Item {} padding
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.modules.bar

ColumnLayout {
    id:root
    spacing: 15

    ConfigGroup { // Profile Section
        title: "Profile"
        icon: "id_card"
        ProfileCard {isExpanded: true; size: ProfileCard.Size.XL}
        ConfigSwitch {
            buttonIcon: "photo"
            text: "Use Picture"
            description: "Stored at ~/.face"
            checked: Config.options.system.profile.usePicture
            onCheckedChanged: Config.options.system.profile.usePicture = checked
        }
        ConfigTile {
            visible: !Config.options.system.profile.usePicture
            buttonIcon: Config.options.system.profile.icon
            text: "Profile Icon"
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
        RowLayout {
            MaterialSymbol {text: "info"}
            StyledText {text: "Power info";}
        }
        ColumnLayout{
            opacity: 0.8
            RowLayout {
                MaterialSymbol {text: "trending_down"}
                StyledText {text: "Degradation state: "}
                StyledText {text: PowerService.degradationStateText}
            }
            RowLayout {
                MaterialSymbol {text: "comment"}
                StyledText {text: "Degradation reason: "}
                StyledText {text: PowerService.degradationReasonText}
            }
        }
    }

    ConfigGroup{ // Battery Section
        visible: Battery.available
        title: "Battery"
        icon: "battery_android_full"
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
            text: "Automatic Suspend"
            description: "Suspend system when at very low battery to avoid losing progress"
            checked: Config.options.battery.automaticSuspend
            onCheckedChanged: {
                Config.options.battery.automaticSuspend = checked;
            }
        }
        Item {} // Padding
        RowLayout {
            MaterialSymbol {text: "info"}
            StyledText {text: "Battery info";}
        }
        ColumnLayout {
            opacity: 0.8
            RowLayout {
                MaterialSymbol{text: "percent"}
                StyledText {text: "Battery percentage: "}
                StyledText {text: `${Math.round(Battery.percentage * 100)}%`}
            }
            RowLayout {
                MaterialSymbol{text: "bolt"}
                StyledText {text: "Usage: "}
                StyledText {text: `${Battery.energyRate.toFixed(2)} W`}
            }
            RowLayout {
                MaterialSymbol{text: "timer"}
                StyledText {text:{if (Battery.chargeState == 4) {return "Fully charged";} else if (Battery.chargeState == 1) {return "Charging: ";} else {return "Discharging: ";}}}
                StyledText {text: {function formatTime(seconds) {var h = Math.floor(seconds / 3600); var m = Math.floor((seconds % 3600) / 60); if (h > 0) return `${h}h, ${m}m`; else return `${m}m`;} if (Battery.isCharging) return formatTime(Battery.timeToFull);else return formatTime(Battery.timeToEmpty);}}
            }
            RowLayout{
                MaterialSymbol{text: "heart_check"}
                StyledText {text: "Health: "}
                StyledText {text: `${(Battery.health).toFixed(1)}%`}
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
