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
    readonly property string themeJson: shellConfig + "/theme.json"
    readonly property string wallpapers: home + "/Pictures/Wallpapers"

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`])
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}/config`])
    }
}
