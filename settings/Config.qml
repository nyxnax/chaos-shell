pragma Singleton
import QtQuick
import QtCore
import Quickshell

Singleton {
    id: root
    property Settings storage: Settings {
        category: "General"
        property bool isTop: true
    }
    property bool isTop: storage.isTop
    function togglePossition() {
        storage.isTop = !storage.isTop
    }
}
