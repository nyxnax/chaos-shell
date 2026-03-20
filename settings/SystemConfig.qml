import QtQuick // Just for the Item {} padding
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.modules.bar

ColumnLayout {
    id:root
    spacing: 15

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
                console.log ("System: Battery sounds set to " + checked)
            }
        }
        ConfigSwitch{
            buttonIcon: "power_off"
            text: "Automatic Suspend"
            description: "Suspend system when at very low battery to avoid losing progress"
            checked: Config.options.battery.automaticSuspend
            onCheckedChanged: {
                Config.options.battery.automaticSuspend = checked;
                console.log ("System: Battery auto-suspend set to " + checked)
            }
        }
        Item {} // Padding
        RowLayout {
            MaterialSymbol {text: "info"}
            StyledText {text: "Battery Info";}
        }
        ColumnLayout {
            opacity: 0.8
            RowLayout {
                MaterialSymbol{text: "percent"}
                StyledText {text: "Battery Percentage: "}
                BatteryIndicator {}
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
}
