import QtQuick
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
            required property var modelData
            screen: modelData

            readonly property int screenIndex: screenList.indexOf(modelData.name)

            readonly property bool isAutoHide: Config.options.bar.autoHide
            property bool mouseOver: false
            readonly property bool expanded: !isAutoHide || mouseOver

            anchors {
                // Primary monitor (index 0) uses the global config, secondary monitors (index > 0) are forced to the bottom
                top: screenIndex === 0 ? !Config.options.bar.bottom : false
                bottom: screenIndex === 0 ? Config.options.bar.bottom : true
                left: true
                right: true
            }

            exclusionMode: isAutoHide ? ExclusionMode.Ignore : ExclusionMode.Auto
            implicitHeight: expanded ? 48 : 5
            color: Appearance.colors.m3background

            Behavior on implicitHeight {
                    NumberAnimation {
                        duration: Appearance.animation.elementMoveFast.duration
                        easing.type: Appearance.animation.elementMoveFast.type
                    }
                }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: bar.mouseOver = true
                onExited: bar.mouseOver = false
                // Allows you to click items inside the bar
                propagateComposedEvents: true
            }

            Item {
                anchors.fill: parent

                opacity: bar.expanded ? 1 : 0
                Row {
                    id: barLeft
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    spacing: 10

                    Clock {}
                    WindowTitle {}
                }

                Row {
                    id: barCenter
                    anchors.centerIn: parent
                    spacing: 5

                    Workspaces {
                        workspaceOffset: Math.max(0, screenIndex) * workspacesPerScreen
                        targetMonitorName: bar.screen.name
                    }
                }

                Row {
                    id: barRight
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    spacing: 10

                    SysTray {}
                    Media {}
                    ControlCenter {}
                    BatteryIndicator {}
                }
            }
        }
    }
}
