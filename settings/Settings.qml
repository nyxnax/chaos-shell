import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.widgets
import qs.services

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

    enum Breakpoint { // Material Design 3 Breakpoints
        Compact, // Phone in portrait
        Medium, // Tablet in portrait / Foldable in portrait (unfolded)
        Expanded, // Phone in landscape / Tablet in landscape / Foldable in landscape (unfolded) / Desktop
        Large, // Desktop / Fullscreen-ish 16:9 display
        ExtraLarge // Ultrawide display
    }

    readonly property int currentBreakpoint: {
        let width = root.width
        if (width < 700)  return Settings.Breakpoint.Compact // Larger than 600 because I'm stupid and can't do 600 without breaking things yet :)
        if (width < 840)  return Settings.Breakpoint.Medium
        if (width < 1200) return Settings.Breakpoint.Expanded
        if (width < 1600) return Settings.Breakpoint.Large
        return Settings.Breakpoint.ExtraLarge
    }

    readonly property bool isCompact:    currentBreakpoint === Settings.Breakpoint.Compact
    readonly property bool isMedium:     currentBreakpoint === Settings.Breakpoint.Medium
    readonly property bool isExpanded:   currentBreakpoint === Settings.Breakpoint.Expanded
    readonly property bool isLarge:      currentBreakpoint === Settings.Breakpoint.Large
    readonly property bool isExtraLarge: currentBreakpoint === Settings.Breakpoint.ExtraLarge

    property int currentPage: 0
    property var pages: [
        { name: "Network",   icon: Network.materialSymbol, component: "NetworkConfig.qml" },
        { name: "Wallpaper", icon: "wallpaper_slideshow",  component: "WallpaperConfig.qml" },
        { name: "Display",   icon: "display_settings",     component: "DisplayConfig.qml" },
        { name: "Bar",       icon: "toast",                component: "BarConfig.qml" },
        { name: "System",    icon: "tune",                 component: "SystemConfig.qml" },
        { name: "About",     icon: "info",                 component: "About.qml" }
    ]

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

        Shortcut {
            sequence: "Alt+Up"
            onActivated: root.currentPage = (root.currentPage - 1 + root.pages.length) % root.pages.length;
        }
        Shortcut {
            sequence: "Alt+Down"
            onActivated: root.currentPage = (root.currentPage + 1) % root.pages.length
        }

        Shortcut {
            sequences: ["Alt+Left", "Escape"]
            enabled: backButton.visible && root.currentPage > 0
            onActivated: backButton.animateClick()
        }

        Shortcut {
            sequence: "Ctrl+B"
            onActivated: navRail.isExpanded = !navRail.isExpanded
            autoRepeat: false
        }

        Item {
            id: headerArea
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: isCompact ? 30 : navRail.width + 40
            anchors.rightMargin: 20
            height: header.implicitHeight
            z: 10

            Behavior on anchors.leftMargin { animation: Appearance.animation.elementResize.numberAnimation.createObject(this) }

            ConfigRow {
                id: header
                width: Math.min(parent.width, 1800)
                anchors.horizontalCenter: parent.horizontalCenter

                StyledButton {
                    id: backButton
                    visible: true
                    size: StyledButton.Size.M
                    buttonIcon: "arrow_back"
                    fontColor: Appearance.colors.m3onSurface
                    onReleased: root.currentPage = Math.max(0, root.currentPage - 1)
                    opacity: root.currentPage === 0 ? 0.38 : 1
                }

                StyledText {
                    text: root.pages[root.currentPage].name
                    font.pixelSize: Appearance.font.pixelSize.title
                    Layout.alignment: Qt.AlignBaseline
                }

                StyledText {
                    text: "[CHA_OS] :: settings // " + "page_0" + (root.currentPage+1)
                    color: Appearance.colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    Layout.alignment: Qt.AlignBaseline
                }

                Item {Layout.fillWidth: true}
                StyledText {
                    text: ":: " + DeviceService.ramUsedGb.toFixed(5) + " //"
                    color: Appearance.colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    Layout.alignment: Qt.AlignBaseline
                }
                ProfileCard {shouldShow: isCompact}
            }
        }

        StackLayout { // Pages
            id: pagesStack

            anchors.top: headerArea.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 12
            anchors.leftMargin: isCompact ? 30
                                : navRail.isExpanded ? (navRail.width + 20)
                                : (navRail.width + 40)
            anchors.rightMargin: 20
            currentIndex: root.currentPage
            Behavior on anchors.leftMargin {animation: Appearance.animation.elementResize.numberAnimation.createObject(this)}

            Repeater {
                model: root.pages

                delegate: ScrollView {
                    id: scroll
                    Layout.fillWidth: true
                    contentHeight: pageColumn.implicitHeight
                    readonly property bool isActive: StackLayout.isCurrentItem
                    opacity: isActive ? 1 : 0
                    verticalPadding: isActive ? 0 : 20

                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                    Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
                    Behavior on verticalPadding {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                    Item {
                        height: pageColumn.implicitHeight
                        width: scroll.availableWidth

                        Column {
                            id: pageColumn
                            width: Math.min(scroll.availableWidth, 1800)
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            bottomPadding: isCompact ? navBar.height + 40 : 16

                            Behavior on bottomPadding {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                            Loader {
                                width: parent.width
                                source: modelData.component
                            }

                            ColumnLayout {
                                id: pageFooter

                                StyledText {
                                    text: ":: end_of page_0" + (root.currentPage+1) + " //"
                                    color: Appearance.colors.m3outline
                                    font.pixelSize: Appearance.font.pixelSize.smaller
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout { // Bottom Navigation Bar
            id: navBar
            opacity: isCompact ? 1 : 0
            visible: opacity > 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

            Rectangle {
                color: Appearance.colors.m3surfaceContainerLowest
                height: navButtons.height + 10
                width: navButtons.width + 10
                radius: Appearance.rounding.verylarge + 5

                StyledButtonGroup {
                    id: navButtons
                    anchors.centerIn:parent
                    model: root.pages
                    buttonSize: StyledButton.Size.XL
                    style: StyledButton.Style.Tonal
                    columns: root.pages.length
                    collapsed: true
                    currentValue: root.currentPage
                    onChoiceSelected: (index) => root.currentPage = index
                }
            }
        }

        Rectangle { // Navigation Rail
            id: navRail
            property bool isExpanded: false
            opacity: !isCompact ? 1 : 0
            visible: opacity > 0
            width: isExpanded ? 220 : 80
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: isExpanded ? 0 : 20
            color: isExpanded ? Appearance.colors.m3surfaceContainer : Appearance.colors.m3surfaceContainerLow
            radius: 12

            Behavior on width {animation: Appearance.animation.elementResize.numberAnimation.createObject(root)}
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
            Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on anchors.margins {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

            Column {
                id: buttonColumn
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 4
                leftPadding: 16
                rightPadding: 16
                y: 8

                StyledButton {
                    size: StyledButton.Size.L
                    buttonIcon: navRail.isExpanded ? "menu_open" : "menu"
                    //text: navRail.isExpanded ? "Retract" : ""
                    onPressed: navRail.isExpanded = !navRail.isExpanded
                    buttonColor: "transparent"
                    fontColor: Appearance.colors.m3onSurface
                }

                Repeater {
                    model: root.pages
                    delegate: StyledButton {
                        size: StyledButton.Size.L
                        style: isSelected ? StyledButton.Style.Tonal : StyledButton.Style.Text
                        text: navRail.isExpanded ? modelData.name : ""
                        buttonIcon: modelData.icon
                        isSelected: root.currentPage === index
                        onReleased: root.currentPage = index
                        opacity: isSelected ? 1 : 0.8
                        clip: true

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
