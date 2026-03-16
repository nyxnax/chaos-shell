import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common

RowLayout {
    spacing: 3

    property int workspaceOffset: 0
    property string targetMonitorName: ""

    // Dynamically calculate the number of workspaces to show.
    // Minimum 5, Maximum 10.
    readonly property int workspaceCount: {
        let maxIdx = 5;
        const monitorWorkspaces = Hyprland.workspaces.values;
        for (let i = 0; i < monitorWorkspaces.length; i++) {
            const ws = monitorWorkspaces[i];

            if (ws && ws.monitor && ws.monitor.name === targetMonitorName) {
                const relativeId = ws.id - workspaceOffset;
                if (relativeId > maxIdx) maxIdx = relativeId;
            }
        }
        return Math.min(10, Math.max(5, maxIdx));
    }

    Repeater {
        model: workspaceCount
        delegate: Rectangle {
            readonly property int wsId: workspaceOffset + index + 1

            // Find the workspace object and ensure it actually belongs to this monitor
            readonly property var ws: Hyprland.workspaces.values.find(w =>
                w.id === wsId && w.monitor && w.monitor.name === targetMonitorName
            )

            readonly property bool exists: ws !== undefined
            readonly property bool isOccupied: exists && ws.toplevels.values.length > 0

            // 'active' is the property that tracks visibility per monitor
            // in the split-monitor-workspaces plugin.
            readonly property bool isFocused: exists && ws.active

            Layout.preferredWidth: isFocused ? 28 : 14
            Layout.preferredHeight: 14
            radius: 100

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                }
            }

            Behavior on color {
                animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
            }

            color: {
                if (isFocused) return Appearance.colors.m3primary
                if (isOccupied) return Appearance.colors.m3outline
                return Appearance.colors.m3outlineVariant
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${wsId}`)
            }
        }
    }
}
