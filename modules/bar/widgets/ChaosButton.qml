import QtQuick
import Quickshell.Io
import qs.common
import qs.common.widgets

BarItem {
    id: root

    Process {
        id: startProc
        command: Config.options.bar.chaosCommand.split(" ")
    }

    onClicked: {
        startProc.running = true
    }

    Item {
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize

        MaterialSymbol {
            anchors.centerIn: parent
            color: Config.options.bar.chaosAccent ? Appearance.colors.m3primary : Appearance?.colors.m3onBackground
            text: Config.options.bar.chaosIcon
            iconSize: Appearance.font.pixelSize.larger

            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        }
    }
}
