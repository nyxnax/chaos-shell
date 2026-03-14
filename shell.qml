import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.bar
import qs.settings
import qs.common
import qs.services

ShellRoot {
    Settings {}
    Bar {}
    Ipc {}

    Component.onCompleted: {
        Theme.reapplyTheme()
    }
}
