import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services
import qs.common.functions

GridLayout {
    id: root

    columns: isVertical ? 1 : -1
    rows: isVertical ? -1 : 1
    columnSpacing: isVertical ? 0 : 4
    rowSpacing: isVertical ? 4 : 0

    // Defined locally to prevent scope shadowing from Bar.qml
    readonly property int workspacesPerScreen: 10

    // Safely get the target monitor name using the passed widgetScreen property
    property string targetMonitorName: {
        if (typeof widgetScreen !== "undefined" && widgetScreen) return widgetScreen.name;
        if (typeof bar !== "undefined" && bar.screen) return bar.screen.name;
        return "";
    }

    // Dynamically get the index of the monitor from Hyprland to create a reliable offset
    property int screenIndex: {
        if (!targetMonitorName) return 0;

        const monitors = Hyprland.monitors.values;
        if (!monitors) return 0;

        const idx = monitors.findIndex(m => m && m.name === targetMonitorName);
        return Math.max(0, idx);
    }

    property int workspaceOffset: screenIndex * workspacesPerScreen

    // Dynamically calculate the number of workspaces to show
    readonly property int workspaceCount: {
        let maxIdx = 5;
        const monitorWorkspaces = Hyprland.workspaces.values;
        if (monitorWorkspaces) {
            for (let i = 0; i < monitorWorkspaces.length; i++) {
                const ws = monitorWorkspaces[i];
                if (ws && ws.monitor && ws.monitor.name === targetMonitorName) {
                    const relativeId = ws.id - workspaceOffset;
                    if (relativeId > maxIdx) maxIdx = relativeId;
                }
            }
        }
        return Math.min(10, Math.max(5, maxIdx));
    }

    Repeater {
        model: workspaceCount

        delegate: Rectangle {
            readonly property int wsId: workspaceOffset + index + 1
            readonly property var ws: {
                const workspaces = Hyprland.workspaces.values;
                if (!workspaces) return undefined;
                return workspaces.find(w => w.id === wsId && w.monitor && w.monitor.name === targetMonitorName);
            }

            readonly property bool exists: ws !== undefined
            readonly property bool isOccupied: exists && ws.toplevels.values.length > 0
            readonly property bool isFocused: exists && ws.active
            readonly property bool showIcons: isOccupied && Config.options.bar.workspaceIcons

            Layout.preferredWidth: {
                if (isVertical) return 16;
                if (!showIcons) return isFocused ? 28 : 16;
                return Math.max(isFocused ? 28 : 16, iconContainer.width + 12);
            }

            Layout.preferredHeight: {
                if (!isVertical) return 16;
                if (!showIcons) return isFocused ? 28 : 16;
                return Math.max(isFocused ? 28 : 16, iconContainer.height + 12);
            }

            radius: 100
            color: {
                if (isFocused) return Appearance.colors.m3primary
                if (isOccupied) return Appearance.colors.m3secondary
                return Appearance.colors.m3outlineVariant
            }

            Behavior on Layout.preferredWidth {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on Layout.preferredHeight { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}

            // --- ICONS ---
            Flow {
                id: iconContainer
                anchors.centerIn: parent
                spacing: 5
                flow: isVertical ? Flow.TopToBottom : Flow.LeftToRight
                visible: showIcons

                // Get all running apps on this workspace, filtering out duplicates
                property var uniqueClasses: {
                    if (!isOccupied) return [];
                    let classes = [];
                    for (let i = 0; i < ws.toplevels.values.length; i++) {
                        let tl = ws.toplevels.values[i];
                        let windowClass = ClassOrTitle.excludeClass(tl.lastIpcObject.class, tl.title)

                        if (windowClass !== "" && !classes.includes(windowClass)) {
                            classes.push(windowClass);
                        }
                    }

                    if (classes.length === 0) classes.push("unknown");
                    return classes;
                }

                Repeater {
                    model: iconContainer.uniqueClasses

                    delegate: Text {
                        text: BarIcons.getAppIcon(modelData)
                        font.family: Appearance.font.family.iconNerd
                        font.pixelSize: 11
                        color: isFocused ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSecondary
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${wsId}`)
            }
        }
    }
}
