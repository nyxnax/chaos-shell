import QtQuick
import Quickshell

//import qs.modules.bar
import "modules/bar"
import "settings"
import "settings/ui_elements"



ShellRoot {
    Config { 
        id: mainConfig 
    }
    Bar {
        config: mainConfig
    }
    Test {
        config: mainConfig
    }
}
