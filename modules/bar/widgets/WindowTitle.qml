import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.services
import qs.common
import qs.common.widgets
import qs.common.functions

BarItem {
    id: root
    enabled: false
    color: "transparent"

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    property var mainAppIconSource: Quickshell.iconPath(AppSearch.guessIcon(ClassOrTitle.excludeClass(activeWindow?.appId, activeWindow?.title, false , true)), "image-missing")

    visible: iconContainer.visible || classText.isShown || titleText.isShown

    RowLayout {
        id: layout
        spacing: 6

        Item {
            id: iconContainer

            property bool shouldShow: Config.options.bar.windowTitleIconMode
                                    === "always" ? true
                                    : Config.options.bar.windowTitleIconMode
                                    === "app" ? (root.activeWindow?.appId.length > 0)
                                    : false
            visible: opacity > 0
            opacity: shouldShow ? 1 : 0
            scale: shouldShow ? 1 : 0.7

            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on scale   { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

            implicitHeight: 26; implicitWidth: 26
            IconImage {
                id: appIcon
                anchors.fill: parent
                source: mainAppIconSource
                visible: status === Image.Ready
            }

            MultiEffect {
                anchors.fill: appIcon
                source: appIcon
                visible: appIcon.visible

                colorization: 1.0
                colorizationColor: {
                    let c = Appearance.colors.m3primaryContainer;
                    return Qt.hsla(c.hslHue, c.hslSaturation, 0.8, c.a);
                }
            }
        }

        ColumnLayout {
            spacing: -2

            StyledText {
                id: classText
                Layout.maximumWidth: 350
                elide: Text.ElideRight
                text: activeWindow?.appId || "Chaos"
                font.pixelSize: titleText.visible ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.normal
                color: Appearance.colors.m3outline
                property bool isShown: (Config.options.bar.windowTitleTextMode === "class" || Config.options.bar.windowTitleTextMode === "both") && !isVertical
                visible: opacity > 0
                opacity: isShown ? 1 : 0

                Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                Behavior on text {
                    enabled: classText.isShown
                    SequentialAnimation {
                        NumberAnimation { target: classText; property: "opacity"; to: 0; duration: 100 }
                        PropertyAction { target: classText; property: "text" }
                        NumberAnimation { target: classText; property: "opacity"; to: 1; duration: 100 }
                    }
                }
            }
            StyledText {
                id: titleText
                Layout.maximumWidth: 350
                elide: Text.ElideRight
                text: activeWindow?.title || "Desktop"
                font.pixelSize: classText.visible ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.normal
                color: Appearance.colors.m3onBackground
                property bool isShown: (Config.options.bar.windowTitleTextMode === "title" || Config.options.bar.windowTitleTextMode === "both") && !isVertical
                visible: opacity > 0
                opacity: isShown ? 1 : 0

                Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
                Behavior on text {
                    enabled: titleText.isShown
                    SequentialAnimation {
                        NumberAnimation { target: titleText; property: "opacity"; to: 0; duration: 100 }
                        PropertyAction { target: titleText; property: "text" }
                        NumberAnimation { target: titleText; property: "opacity"; to: 1; duration: 100 }
                    }
                }
            }
        }
    }
}
