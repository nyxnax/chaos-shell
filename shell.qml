//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.bar
import qs.modules.osd
import qs.modules.session
import qs.settings
import qs.common
import qs.services

ShellRoot {
    Settings {}
    Bar {}
    Ipc {}
    VolumeOSD {}
    SessionManager {}

    Component.onCompleted: {
        Theme.reapplyTheme()
    }
}
