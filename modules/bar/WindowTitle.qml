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
    width: layout.width
    color: "transparent"
    radius: 6

    property bool isShown: Config.options.bar.showWindowTitle
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    property var mainAppIconSource: Quickshell.iconPath(AppSearch.guessIcon(activeWindow?.appId), "image-missing")

    visible: opacity > 0
    opacity: isShown ? 1 : 0
    scale: isShown ? 1 : 0.95

    Behavior on width   {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}
    Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        height: parent.height
        spacing: 6

        Item {
            visible: opacity > 0
            opacity: Config.options.bar.showWindowIcon ? 1 : 0
            scale: Config.options.bar.showWindowIcon ? 1 : 0.95

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

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
                    NumberAnimation { target: titleText; property: "opacity"; to: 0; duration: 50 }
                    PropertyAction { target: titleText; property: "text" }
                    NumberAnimation { target: titleText; property: "opacity"; to: 1; duration: 50 }
                }
            }
        }
    }
}
