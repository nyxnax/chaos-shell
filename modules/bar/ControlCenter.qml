import QtQuick
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    id: root
    height: 30
    width: layout.width
    color: mouse.containsMouse ? "#2affffff" : "#00000000"
    radius: 6

    Behavior on color { ColorAnimation { duration: 150 } }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            Global.states.settingsOpen = true
        }
        PointingHand {}
    }

    Row {
        id: layout
        anchors.centerIn: parent
        Item { // Network
            implicitHeight: root.height
            implicitWidth: root.height
            MaterialSymbol {
                id: networkIconBackground
                visible: Network.wifiStatus === "connected" && !Network.ethernet
                text: "wifi"
                opacity: 0.4
                iconSize: networkIcon.iconSize
                anchors.centerIn: parent
            }
            MaterialSymbol {
                id: networkIcon
                text: Network.materialSymbol
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
            }
        }
    }
}
