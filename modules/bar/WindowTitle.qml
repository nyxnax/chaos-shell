import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    height: 30
    width: layout.width + 16
    color: "transparent"
    radius: 6

    property bool isShown: Config.options.bar.showWindowTitle
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    readonly property string windowTitle: ToplevelManager.activeToplevel?.title
    property var mainAppIconSource: Quickshell.iconPath(AppSearch.guessIcon(activeWindow?.appId), "image-missing")

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

        Item {
            implicitHeight: 26; implicitWidth: 26
            IconImage {
                id: appIcon
                anchors.fill: parent
                source: mainAppIconSource
                visible: status === Image.Ready

                ColorOverlay {
                    anchors.fill: appIcon
                    source: appIcon
                    color: Appearance.colors.m3onSurfaceVariant
                    opacity: 0.4
                }
            }
        }

        StyledText {
            id: titleText
            Layout.maximumWidth: 350
            elide: Text.ElideRight
            text: activeWindow?.title || "Desktop"
            font.weight: 500
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.colors.m3onBackground
            opacity: 0.8
            Layout.alignment: Qt.AlignVCenter
            Behavior on text {
                SequentialAnimation {
                    NumberAnimation { target: titleText; property: "opacity"; to: 0; duration: 100 }
                    PropertyAction { target: titleText; property: "text" }
                    NumberAnimation { target: titleText; property: "opacity"; to: 1; duration: 100 }
                }
            }
        }
    }
}
