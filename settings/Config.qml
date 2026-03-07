pragma Singleton
import QtQuick
import QtCore
import Quickshell

Singleton {

    id: root
    property Settings generalStorage: Settings {
        category: "generic"
        property bool isTop: true
        property bool showSettings: false
    }
    property bool isTop: generalStorage.isTop
    function togglePossition() {
        generalStorage.isTop = !generalStorage.isTop
    }

    property bool showSettings: generalStorage.showSettings
    function toggleSettings() {
        generalStorage.showSettings = !generalStorage.showSettings
    }


    property Settings appearanceStorage: Settings {
        category: "Appearance"
        property string theme: "dark"
        property real opacity: 0.9
    }

    property Settings testStorage: Settings {
        category: "test"
        property string easteregg: "unga bunga"
    }

    // Facade properties for Appearance
    property string theme: appearanceStorage.theme
    property real opacity: appearanceStorage.opacity

    //function setTheme(newTheme) {
    //    appearanceStorage.theme = newTheme
    //}

    property var categories: [generalStorage, appearanceStorage, testStorage]

}
