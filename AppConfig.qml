pragma Singleton
import QtQuick
QtObject {
    readonly property bool initialized: {
        Qt.application.name = "Chaos Shell";
        Qt.application.organization = "Chaos Labs";
        return true;
    }
}
