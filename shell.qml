//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.bar
import qs.modules.osd
import qs.settings
import qs.common
import qs.services

ShellRoot {
    Settings {}
    Bar {}
    Ipc {}
    VolumeOSD {}

    Component.onCompleted: {
        Theme.reapplyTheme()
    }
}
