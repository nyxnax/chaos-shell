import QtQuick
import qs.common
import qs.common.widgets

BarItem {
    id: root

    onClicked: Global.states.sessionManagerOpen = !Global.states.sessionManagerOpen

    Item {
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize

        MaterialSymbol {
            anchors.centerIn: parent
            text: "power_settings_new"
            iconSize: Appearance.font.pixelSize.larger
        }
    }
}
