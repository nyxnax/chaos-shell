import QtQuick
import qs.common
import qs.common.widgets

BarItem {
    id: root

    onClicked: Global.states.sessionManagerOpen = !Global.states.sessionManagerOpen
    property bool isShown: Config.options.bar.showPowerButton
    opacity: isShown ? 1 : 0
    visible: opacity > 0

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
