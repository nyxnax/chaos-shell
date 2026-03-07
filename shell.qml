
import QtQuick
import Quickshell

import qs.modules.bar
import qs.settings
import qs.settings.ui_elements

ShellRoot {
    Component.onCompleted: {
        Qt.application.name = "Chaos Shell";
        Qt.application.organization = "Choas Labs";
    }
    Bar {}
    Test {}
}
