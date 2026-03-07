
import QtQuick
import Quickshell

import qs.modules.bar
import qs.settings

import "." // Import the directory where AppConfig is

ShellRoot {
    readonly property bool _init: AppConfig.initialized

    Bar {}
    Settings {}
}
