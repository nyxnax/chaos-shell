import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.common.widgets
import qs.common.functions

Rectangle {
    id: root
    height: 30
    width: layout.width + 16
    color: "transparent"
    radius: 6

    // Using the correct property discovered from our API scan
    readonly property var activeWin: Hyprland.activeToplevel
    readonly property string windowTitle: activeWin ? activeWin.title : ""
    readonly property string windowClass: activeWin && activeWin.lastIpcObject ? activeWin.lastIpcObject.class : ""

    // Hide the module entirely if there is no window focused or the toggle is off
    property bool isShown: Config.options.bar.showWindowTitle && windowTitle !== ""

    visible: opacity > 0
    opacity: isShown ? 1 : 0
    scale: isShown ? 1 : 0.95

    Behavior on opacity {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        height: parent.height
        spacing: 6

        Text {
            id: appIcon
            text: BarIcons.getAppIcon(root.windowClass)
            font.family: Appearance.font.family.iconNerd
            font.pixelSize: 14
            color: Appearance.colors.m3onBackground
            visible: text !== ""
            opacity: 0.8
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            id: titleText
            Layout.maximumWidth: 350
            elide: Text.ElideRight
            text: root.windowTitle
            font.weight: 500
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.m3onBackground
            opacity: 0.8
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
