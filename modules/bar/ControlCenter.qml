import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    width: layout.width + 6

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: -4

        Item { // Input
            id: input
            implicitHeight: root.height
            implicitWidth: root.height

            MaterialSymbol {
                id: inputIcon
                text: "mic_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }

            readonly property bool shouldShow: Audio.source?.audio?.muted ?? false
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0
            scale: shouldShow ? 1 : 0.95

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

        }

        Item { // Output
            id: output
            implicitHeight: root.height
            implicitWidth: root.height

            MaterialSymbol {
                id: outputIcon
                text: "volume_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }

            readonly property bool shouldShow: Audio.sink?.audio?.muted ?? false
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0
            scale: shouldShow ? 1 : 0.95

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
        }

        Item { // Network
            id: network
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
