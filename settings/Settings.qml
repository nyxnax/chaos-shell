import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.widgets

ApplicationWindow {
    id: root

    width: Screen.width * 0.7
    height: Screen.height * 0.7
    minimumWidth: 400
    minimumHeight: 400
    visible: Global.states.settingsOpen
    title: "Chaos Settings"
    onClosing: Global.states.settingsOpen = false
    color: Appearance.colors.m3background

    property var pages: [
        {
            name: "Wallpaper",
            icon: "wallpaper_slideshow",
            iconRotation: 180,
            component: "WallpaperConfig.qml"
        },
        {
            name: "Appearance",
            icon: "palette",
            iconRotation: 180,
            component: "AppearanceConfig.qml"
        },
        {
            name: "Bar",
            icon: "toast",
            iconRotation: 180,
            component: "BarConfig.qml"
        },
        {
            name: "About",
            icon: "info",
            iconRotation: 180,
            component: "About.qml"
        }
    ]
    property int currentPage: 0

    Process {
        id: matugenProcess
        running: false
        // Call the interpreter, then the absolute path to your script
        command: ["bash", Quickshell.shellPath("./scripts/wall.sh")]

        onStdoutChanged: console.log("Script Out: " + stdout)
        onStderrChanged: console.warn("Script Error: " + stderr)

        onExited: (exitCode) => {
            console.log("Script finished with code: " + exitCode);
            matugenProcess.running = false;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Keys.onPressed: (event) => {
            if (event.modifiers === Qt.ControlModifier) {
                if (event.key === Qt.Key_PageDown) {
                    root.currentPage = Math.min(root.currentPage + 1, root.pages.length - 1)
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_PageUp) {
                    root.currentPage = Math.max(root.currentPage - 1, 0)
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Tab) {
                    root.currentPage = (root.currentPage + 1) % root.pages.length;
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Backtab) {
                    root.currentPage = (root.currentPage - 1 + root.pages.length) % root.pages.length;
                    event.accepted = true;
                }
            }
        }


        StackLayout {
            currentIndex: tab.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: root.pages
                delegate: ScrollView {
                contentWidth: availableWidth

                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        ConfigRow {
                            MaterialSymbol {
                                text: modelData.icon
                                font.pixelSize: Appearance.font.pixelSize.title * 1.2
                            }
                            StyledText {
                                text: modelData.name
                                font.pixelSize: Appearance.font.pixelSize.title * 1.2
                            }
                        }

                        Loader {
                            Layout.fillWidth: true
                            source: modelData.component
                        }
                    }
                }
            }
        }

        TabBar {
            id: tab
            currentIndex: root.currentPage
            width: contentWidth
            Layout.alignment: Qt.AlignHCenter

            background:Rectangle {
                color: Appearance.colors.m3primary
                radius: 10

                Rectangle {
                    id: indicator
                    height: parent.height - 8
                    width: 60 - 8
                    y: 4
                    x: (tab.currentItem ? tab.currentItem.x : 0) + 4
                    color: Appearance.colors.m3primaryContainer
                    radius: 8

                    Behavior on x {
                        NumberAnimation {
                            duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                        }
                    }
                }
            }

            Repeater {
                model: root.pages

                StyledTabButton {
                    id: tabButton
                    implicitWidth: 60
                    implicitHeight: 60

                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: modelData.icon
                        color: tabButton.checked
                            ? Appearance.colors.m3onPrimaryContainer
                            : Appearance.colors.m3onPrimary
                        iconSize: Appearance.font.pixelSize.huge
                        opacity: 0.9
                    }

                    ToolTip {
                        text: modelData.name
                        visible: tabButton.hovered && text !== ""
                        //delay: 50

                        contentItem: Text {
                            text: modelData.name
                            color: Appearance.colors.m3onSecondaryContainer
                            font.pixelSize: Appearance.font.pixelSize.normal
                        }
                        background: Rectangle {
                            color: Appearance.colors.m3secondaryContainer
                            radius: 6
                        }
                    }
                }
            }
        }
    }
}
