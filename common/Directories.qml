pragma Singleton
pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import qs.common.functions

Singleton {
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]


    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.config}/chaos-labs`)
    property string shellConfigName: "/config.json"
    property string shellConfigPath: `${Directories.shellConfig}/config/${Directories.shellConfigName}`
    property string generatedMaterialThemePath: FileUtils.trimFileProtocol(`${Directories.config}/nucleus-shell/config/colors.json`)

    readonly property string wallDir: home + "/Pictures/Wallpapers"
    readonly property string themeJson: shellConfig + "/theme.json"
    readonly property string matugenTemplate: config + "/common/templates/quickshell.json"

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`])
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}/config`])
    }
}
