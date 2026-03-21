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
    minimumWidth: 600
    minimumHeight: 500
    visible: Global.states.settingsOpen
    title: "Chaos Settings"
    onClosing: Global.states.settingsOpen = false
    color: Appearance.colors.m3background

    property bool isPortrait: root.height > root.width
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
            name: "System",
            icon: "tune",
            iconRotation: 180,
            component: "SystemConfig.qml"
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

    Item {
        id: mainContent
        anchors.fill: parent

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


        StackLayout { // Pages
            anchors.fill: parent
            currentIndex: root.currentPage
            anchors.leftMargin: isPortrait ? 30 : navRail.width + 40
            anchors.rightMargin: 20

            Repeater {
                model: root.pages

                delegate: ScrollView {
                    id: scroll
                    Layout.fillWidth: true

                    Column {
                        width: scroll.availableWidth
                        bottomPadding: isPortrait ? navBar.height + 20 : 20
                        topPadding: 20

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
                            width: parent.width
                            source: modelData.component
                        }
                    }
                }
            }
        }

        TabBar { // Bottom Navigation Bar
            id: navBar
            currentIndex: root.currentPage
            opacity: isPortrait ? 1 : 0
            visible: opacity > 0
            height: 60
            width: (60 * root.pages.length)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

            Repeater {
                model: root.pages
                delegate: navButtonDelegate
            }
            background:Rectangle {
                color: Appearance.colors.m3primary
                radius: 10

                Rectangle {
                    id: indicator
                    height: parent.height - 8
                    width: 60 - 8
                    y: 4
                    x: (navBar.currentItem ? navBar.currentItem.x : 0) + 4
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
        }

        Rectangle { // Navigation Rail
            id: navRail
            opacity: !isPortrait ? 1 : 0
            visible: opacity > 0
            width: 60
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 20
            color: Appearance.colors.m3primary
            radius: 12

            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

            Rectangle {
                id: sideIndicator
                width: parent.width - 8
                height: 52
                x: 4
                y: (root.currentPage * 60) + 4
                color: Appearance.colors.m3primaryContainer
                radius: 10
                Behavior on y {
                    NumberAnimation {
                        duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                        easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                    }
                }
            }

            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: root.pages
                    delegate: navButtonDelegate
                }
            }
        }

        Component {
            id: navButtonDelegate

            StyledTabButton {
                id: tabButton
                implicitWidth: 60
                implicitHeight: 60
                checked: root.currentPage === index
                onClicked: root.currentPage = index

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
                    delay: 50
                    timeout: 2000

                    contentItem: Text {
                        text: modelData.name
                        color: Appearance.colors.m3onSecondaryContainer
                        font.pixelSize: Appearance.font.pixelSize.normal
                    }
                    background: Rectangle {
                        color: Appearance.colors.m3secondaryContainer
                        radius: 6
                    }

                    enter: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0.0
                            to: 1.0
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }
                    }

                    exit: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 1.0
                            to: 0.0
                            duration: Appearance.animation.elementMoveFast.duration
                            easing.type: Appearance.animation.elementMoveFast.type
                            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                        }
                    }
                }
            }
        }
    }
}
