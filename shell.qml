import qs
import QtQuick
import Quickshell
import Quickshell.Io

import qs.modules.bar
import qs.settings



ShellRoot {
    readonly property bool _init: AppConfig.initialized

    Settings {}
    Bar {}
}
