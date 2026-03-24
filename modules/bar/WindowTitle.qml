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

BarItem {
    id: root
    enabled: false
    width: layout.width
    color: "transparent"

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    property var mainAppIconSource: Quickshell.iconPath(AppSearch.guessIcon(ClassOrTitle.excludeClass(activeWindow?.appId, activeWindow?.title, false , true)), "image-missing")


    property bool isShown: Config.options.bar.showWindowTitle
    visible: opacity > 0
    opacity: isShown ? 1 : 0
    scale: isShown ? 1 : 0.95

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 6

        Item {
            id: iconContainer
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
            text: ClassOrTitle?.excludeClass(activeWindow?.appId, activeWindow?.title, false, false) || "Desktop"
            color: Appearance.colors.m3onBackground
            opacity: 0.8
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
