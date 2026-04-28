import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.settings
import qs.services
import qs.common
import qs.common.widgets

Scope {
    readonly property int workspacesPerScreen: 10

    // Dynamically create an array of names like ["DP-1", "DP-2"]
    readonly property var screenList: {
        const names = [];
        for (let i = 0; i < Quickshell.screens.length; i++) {
            names.push(Quickshell.screens[i].name);
        }
        return names;
    }

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            id: bar
            property alias window: bar
            required property var modelData
            screen: modelData

            readonly property int screenIndex: screenList.indexOf(modelData.name)
            readonly property bool isAutoHide: Config.options.bar.autoHide
            readonly property string position: (Config.options && Config.options.bar) ? Config.options.bar.position : "top"
            readonly property bool isVertical: position === "left" || position === "right"
            property real barThickness: 48 * (Config.options.appearance.displayScale / 100)
            property bool mouseOver: false
            readonly property bool expanded: !isAutoHide || mouseOver

            anchors {
                top: screenIndex === 0 ? (position === "top" || isVertical) : false
                bottom: screenIndex === 0 ? (position === "bottom" || isVertical) : true
                left: position === "left" || !isVertical
                right: position === "right" || !isVertical
            }

            exclusionMode: isAutoHide ? ExclusionMode.Ignore : ExclusionMode.Auto
            implicitHeight: isVertical ? -1 : (expanded ? barThickness : 5)
            implicitWidth: isVertical ? (expanded ? barThickness : 5) : -1
            color: "transparent"

            Rectangle { // Background
                id: barBackground
                anchors.fill: parent
                color: Config.options.appearance.opacity <= 0 ? "transparent" :
                        Qt.alpha(Appearance.colors.m3background, Config.options.appearance.opacity / 100.0)
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: bar.mouseOver = true
                onExited: bar.mouseOver = false
                propagateComposedEvents: true
            }

            Item {
                anchors.fill: parent
                anchors.margins: 8
                opacity: bar.expanded ? 1 : 0

                RowLayout { // Left
                    id: barLeft
                    visible: !isVertical
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Clock {}
                    WindowTitle {}
                }

                ColumnLayout { // Top
                    id: barTop
                    visible: isVertical
                    anchors.top: parent.top
                    spacing: 6

                    Clock {}
                    WindowTitle {}
                }

                RowLayout { // Center
                    anchors.centerIn: parent
                    spacing: 6

                    Workspaces {
                        workspaceOffset: Math.max(0, screenIndex) * workspacesPerScreen
                        targetMonitorName: bar.screen.name
                    }
                }

                RowLayout { // Right
                    id: barRight
                    visible: !isVertical
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    SysTray {}
                    Media {}
                    ControlCenter {}
                    BatteryIndicator {}
                    SessionButton {}
                }

                ColumnLayout { // Bottom
                    id: barBottom
                    visible: isVertical
                    anchors.bottom: parent.bottom
                    spacing: 6

                    SysTray {}
                    Media {}
                    ControlCenter {}
                    BatteryIndicator {}
                    SessionButton {}
                }
            }
        }
    }
}
