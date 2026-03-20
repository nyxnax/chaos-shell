import QtQuick
import QtQuick.Layouts
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

    RowLayout {
        id: layout
        anchors.centerIn: parent

        Item { // Input
            id: input
            property bool reveal
            property bool vertical: false
            clip: true

            implicitHeight: root.height
            implicitWidth: root.height / 1.5
            visible: Audio.source?.audio?.muted ?? false

            MaterialSymbol {
                id: inputIcon
                text: "mic_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }
        }

        Item { // Output
            id: output
            property bool reveal
            property bool vertical: false
            clip: true

            implicitHeight: root.height
            implicitWidth: root.height / 1.5
            visible: Audio.sink?.audio?.muted ?? false

            MaterialSymbol {
                id: outputIcon
                text: "volume_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }
        }

        Item { // Network
            id: network
            implicitHeight: root.height
            implicitWidth: root.height / 1.5
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
