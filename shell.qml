//@ pragma UseQApplication
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000


import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.bar
import qs.modules.osd
import qs.modules.corners
import qs.modules.session
import qs.settings
import qs.common
import qs.services

ShellRoot {

    LazyLoader {
        id: settingsLoader
        active: Global.states.settingsOpen
        loading: Global.states.settingsOpen
        Settings {}
    }

    Bar {}
    ScreenCorners {}
    Ipc {}
    VolumeOSD {}
    BrightnessOSD {}
    SessionManager {}

    Component.onCompleted: {
        Theme.reapplyTheme()
    }
}
