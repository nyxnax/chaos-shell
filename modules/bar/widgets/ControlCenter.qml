import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    onClicked: Global.states.settingsOpen = !Global.states.settingsOpen

    Item { // Input
        id: input
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize - 5
        Layout.alignment: Qt.AlignCenter

        MaterialSymbol {
            id: inputIcon
            text: Audio.sourceMaterialSymbol
            iconSize: Appearance.font.pixelSize.larger
            anchors.centerIn: parent
            color: (Audio.source?.audio?.muted) ? Appearance.colors.m3outline : Appearance.colors.m3primary
            fill: 1
            animateChange: true
        }

        readonly property bool shouldShow: (Audio.ready && Audio.inputAppNodes.length > 0 || Audio.ready && Audio.source?.audio?.muted)
        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
        }

    Item { // Output
        id: output
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize - 5
        Layout.alignment: Qt.AlignCenter

        MaterialSymbol {
            id: outputIcon
            text: Audio.sinkMaterialSymbol
            iconSize: Appearance.font.pixelSize.larger
            anchors.centerIn: parent
            fill: 1
            animateChange: true
        }

        readonly property bool shouldShow: Config.options.bar.showSinkSymbol ? true : (Audio.sink?.audio?.muted ?? false)
        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    }

    Item { // Network
        id: network
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize

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
            fill: 1
        }
    }
}
