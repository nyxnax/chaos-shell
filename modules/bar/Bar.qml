import QtQuick
import QtQuick.Controls
import Quickshell
import qs.settings
import qs.services
import qs.common
import qs.common.widgets

Scope {
    //property var config
    // Dynamically create an array of names like ["DP-1", "DP-2"]
    readonly property int workspacesPerScreen: 5
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
            required property var modelData
            screen: modelData
            readonly property int screenIndex: screenList.indexOf(modelData.name)
            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
                left: true
                right: true
            }
            implicitHeight: 42
            color: "black"
            Row {
                id: barLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter   // Center vertically
                anchors.margins: 2
                spacing: 10
                Clock {}
            }
            Row {
                id: barCenter
                anchors.centerIn: parent
                spacing: 5

            // DEBUG TEXT: This will tell us if Quickshell sees the monitor name
            //Text {
            //    text: `[Index: ${modelData.index}]` // Should show 0 on screen 1, 1 on screen 2
            //    color: "red"
            //    font.pixelSize: 10
            //    anchors.verticalCenter: parent.verticalCenter
            //}

                Workspaces {
                    workspaceOffset: Math.max(0, screenIndex) * workspacesPerScreen
                }
            }
            Row {
                id: barRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter   // Center vertically
                anchors.margins: 10
                spacing: 10
                // ControlCenter {}
            }
        }
    }
}
