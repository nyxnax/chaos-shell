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

            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
                left: true
                right: true
            }

            implicitHeight: 48
            color: Appearance.colors.m3background

            Row {
                id: barLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10
                spacing: 10
                Clock {}
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
                ControlCenter {}
            }
        }
    }
}
