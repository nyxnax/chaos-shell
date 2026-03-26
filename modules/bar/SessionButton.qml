import QtQuick
import qs.common
import qs.common.widgets

BarItem {
    id: root
    width: height
    onClicked: Global.states.sessionManagerOpen = !Global.states.sessionManagerOpen

    property bool isShown: Config.options.bar.showPowerButton
    opacity: isShown ? 1 : 0
    visible: opacity > 0


    Item {
        id: layout
        implicitHeight: root.height
        implicitWidth: root.height

        MaterialSymbol {
            anchors.centerIn: parent
            text: "power_settings_new"
            iconSize: Appearance.font.pixelSize.larger

        }
    }
}
