pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property bool available: PowerProfiles !== undefined
    readonly property int activeProfile: available ? PowerProfiles.profile : PowerProfile.Balanced
    readonly property bool degradationState: available ? (PowerProfiles.degradationReason !== PerformanceDegradationReason.None) : false
    readonly property string degradationReason: PowerProfiles.degradationReason

    readonly property string degradationStateText: degradationState ? "Throttled / Degraded" : "Nominal"
    readonly property string degradationReasonText: degradationReason === PerformanceDegradationReason.HighTemperature
    ? "High Temperature"
    : degradationReason === PerformanceDegradationReason.LapDetected
    ? "Lap Detected"
    : "None"

    readonly property var profilesModel: [
        { name: "Power Saver", value: PowerProfile.PowerSaver,  icon: "energy_savings_leaf" },
        { name: "Balanced",    value: PowerProfile.Balanced,    icon: "balance"},
        { name: "Performance", value: PowerProfile.Performance, icon: "bolt" }
    ]

    function cycleProfile() {
        if (!available) return;

        switch (activeProfile) {
            case PowerProfile.Balanced:
                setProfile(PowerProfile.Performance);
                break;
            case PowerProfile.Performance:
                setProfile(PowerProfile.PowerSaver);
                break;
            case PowerProfile.PowerSaver:
            default:
                setProfile(PowerProfile.Balanced);
                break;
        }
    }

    function setProfile(profileEnum) {
        if (!available) return;

        if (profileEnum === PowerProfile.Performance && !PowerProfiles.hasPerformanceProfile) {
            console.warn("Power Service: Profile is not supported on this device hardware.");
            return;
        }

        PowerProfiles.profile = profileEnum;
    }
}
