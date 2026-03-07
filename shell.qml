
import QtQuick
import Quickshell

import qs.modules.bar
import qs.settings

ShellRoot {
    Component.onCompleted: {
        Qt.application.name = "Chaos Shell";
        Qt.application.organization = "Choas Labs";
    }
    Bar {}
    Settings {}
}
