import QtQuick
import qs.common
import Quickshell.Io

Rectangle {
    id: root
    height: 30 * (Config.options.appearance.displayScale / 100 )
    width: (layout.width) + (14 * Config.options.appearance.displayScale / 100)
    property bool background: Config.options.bar.showBackground
    signal clicked(var mouse)

    color: (mouseArea.containsMouse && root.enabled) ? Appearance.colors.m3surfaceContainerHighest : (root.background ? Appearance.colors.m3surfaceContainerHigh : "transparent")
    enabled: true
    radius: mouseArea.pressed ? 15 : (mouseArea.containsMouse ? 10 : 8)
    scale: mouseArea.pressed ? 0.9 : 1.0

    Behavior on width { animation: Appearance.animation.elementResize.numberAnimation.createObject(root) }
    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
    Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }
    Behavior on radius { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(root) }
    Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        //onClicked: Global.states.settingsOpen = !Global.states.settingsOpen
        onClicked: (mouse) => root.clicked(mouse)
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        //onPressed: (mouse) => {
        //    if (mouse.button === Qt.RightButton) {
        //        powerToggle.running = true
        //    } else {
        //        Global.states.settingsOpen = !Global.states.settingsOpen;
        //    }
        //}
        cursorShape: Qt.PointingHandCursor
    }
    Process {
        id: powerToggle
        command: ["poweroff"]
        running: false
    }
}
