import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services
import qs.common.functions

BarItem {
    id: root

    spacing: 3
    usePadding: true

    // Safely get the target monitor name using the passed widgetScreen property
    property string targetMonitorName: {
        if (typeof widgetScreen !== "undefined" && widgetScreen) return widgetScreen.name;
        if (typeof bar !== "undefined" && bar.screen) return bar.screen.name;
        return "";
    }

    // With split-monitor-workspaces active, Hyprland's actual workspace IDs
    // for this monitor are assigned/renumbered by the plugin itself (it
    // rebuilds its "first monitor 1-N, second N+1-2N..." mapping whenever a
    // monitor reconnects - which is what a hypridle DPMS cycle triggers).
    // Any offset formula we compute client-side (whether from live monitor
    // enumeration order or a value we've persisted ourselves) can end up
    // disagreeing with whatever the plugin just reassigned, which is why
    // pips would silently start pointing at the wrong/nonexistent workspace.
    //
    // So: don't guess IDs at all. Ask Hyprland which workspaces currently
    // belong to this monitor (already reliable - ws.monitor.name is live and
    // always correct) and lay the pips out positionally over that, sorted by
    // id. This tracks whatever the plugin decides, automatically, always.
    readonly property var monitorWorkspaces: {
        const workspaces = Hyprland.workspaces.values;
        if (!workspaces) return [];
        return workspaces
            .filter(w => w && w.monitor && w.monitor.name === targetMonitorName)
            .sort((a, b) => a.id - b.id);
    }

    // Number of pips to show: however many workspaces the plugin currently
    // has for this monitor, clamped to the configured min/max.
    readonly property int workspaceCount: Math.min(
        Config.options.bar.workspaceMaxPerMonitor,
        Math.max(Config.options.bar.workspaceMinPerMonitor, monitorWorkspaces.length)
    );

    Repeater {
        model: workspaceCount

        delegate: Rectangle {
            readonly property var ws: index < monitorWorkspaces.length ? monitorWorkspaces[index] : undefined

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
                onClicked: if (exists) ws.activate();
            }
        }
    }
}