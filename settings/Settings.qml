import Qt5Compat.GraphicalEffects
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
    Component.onCompleted: pagesStack.forceActiveFocus()
    color: Config.options.appearance.opacity <= 0 ? "transparent" :
           Qt.alpha(Appearance.colors.m3background, Config.options.appearance.opacity / 100.0)
    property bool isPortrait: root.height > root.width
    property var pages: [
        {
            name: "Wallpaper",
            icon: "wallpaper_slideshow",
            iconRotation: 180,
            component: "WallpaperConfig.qml"
        },
        {
            name: "Display",
            icon: "display_settings",
            iconRotation: 180,
            component: "DisplayConfig.qml"
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
            id: pagesStack
            anchors.fill: parent
            currentIndex: root.currentPage
            anchors.leftMargin: isPortrait ? 30 : navRail.width + 40
            anchors.rightMargin: 20
            Behavior on anchors.leftMargin {animation: Appearance.animation.elementResize.numberAnimation.createObject(this)}

            Repeater {
                model: root.pages

                delegate: ScrollView {
                    id: scroll
                    Layout.fillWidth: true
                    contentHeight: pageColumn.height
                    readonly property bool isActive: StackLayout.isCurrentItem
                    opacity: isActive ? 1 : 0
                    verticalPadding: isActive ? 0 : 20
                    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
                    Behavior on verticalPadding {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                    Item {
                        height: pageColumn.height
                        width: scroll.availableWidth

                        Column {
                            id: pageColumn
                            width: Math.min(scroll.availableWidth, 1000)
                            anchors.horizontalCenter: parent.horizontalCenter
                            bottomPadding: isPortrait ? navBar.height + 40 : 16
                            spacing: 5
                            topPadding: 12
                            Behavior on bottomPadding {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                            ConfigRow {
                                anchors.right: parent.right
                                anchors.left: parent.left

                                MaterialSymbol {text: modelData.icon; font.pixelSize: Appearance.font.pixelSize.title}
                                StyledText {text: modelData.name; font.pixelSize: Appearance.font.pixelSize.title}
                                Item {Layout.fillWidth: true}
                                ProfileCard {shouldShow: isPortrait}
                            }

                            Loader {
                                width: parent.width
                                source: modelData.component
                            }
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
                delegate: StyledTabButton {
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
                            : Appearance.colors.m3onSecondary
                        iconSize: Appearance.font.pixelSize.huge
                        opacity: 0.9
                    }

                    StyledToolTip {
                        text: modelData.name
                    }
                }
            }

            background:Rectangle {
                color: Appearance.colors.m3secondary
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
            property bool isExpanded: false
            opacity: !isPortrait ? 1 : 0
            visible: opacity > 0
            width: isExpanded ? 220 : 80
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 20
            color: isExpanded ? Appearance.colors.m3surfaceContainer : Appearance.colors.m3surfaceContainerLow
            radius: 12

            Behavior on width {animation: Appearance.animation.elementResize.numberAnimation.createObject(root)}
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
            Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

            StyledButton {
                size: StyledButton.Size.L
                buttonIcon: navRail.isExpanded ? "menu_open" : "menu"
                //text: navRail.isExpanded ? "Retract" : ""
                onPressed: navRail.isExpanded = !navRail.isExpanded
                x: 16
                y: 8
                buttonColor: "transparent"
                fontColor: Appearance.colors.m3onSurface
            }

            Column {
                id: buttonColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4
                leftPadding: 16
                rightPadding: 16

                Repeater {
                    model: root.pages
                    delegate: StyledButton {
                        size: StyledButton.Size.L
                        text: navRail.isExpanded ? modelData.name : ""
                        buttonIcon: modelData.icon
                        isSelected: root.currentPage === index
                        onReleased: root.currentPage = index
                        clip: true
                        buttonColor: pressed ? Appearance.colors.m3primaryContainer :
                                     isSelected && hovered ? Qt.darker(Appearance.colors.m3primary, 1.25) :
                                     isSelected ? Appearance.colors.m3primary :
                                     hovered ? Appearance.colors.m3surfaceContainerHigh
                                     : "transparent"
                        StyledToolTip {
                            text: modelData.name
                            shown: parent.hovered && !navRail.isExpanded && text !== ""
                        }
                    }
                }
            }

            ProfileCard {
                isExpanded: navRail.isExpanded
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                x: 16
            }
        }
    }
}
