import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services
import qs.common.functions

RowLayout {
    id: root
    spacing: 4

    property int workspaceOffset: 0
    property string targetMonitorName: ""

    // Dynamically calculate the number of workspaces to show
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
            readonly property var ws: Hyprland.workspaces.values.find(w =>
                w.id === wsId && w.monitor && w.monitor.name === targetMonitorName
            )

            readonly property bool exists: ws !== undefined
            readonly property bool isOccupied: exists && ws.toplevels.values.length > 0
            readonly property bool isFocused: exists && ws.active

            readonly property bool showIcons: isOccupied && Config.options.bar.workspaceIcons

            // Expand the width of the pill to fit the icons inside!
            Layout.preferredWidth: {
                if (!showIcons) return isFocused ? 28 : 16;
                return Math.max(isFocused ? 28 : 16, iconRow.width + 12);
            }

            Layout.preferredHeight: 16
            radius: 100


            color: {
                if (isFocused) return Appearance.colors.m3primary
                if (isOccupied) return Appearance.colors.m3secondary
                return Appearance.colors.m3outlineVariant
            }

            Behavior on Layout.preferredWidth {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}

            // --- ICONS ---
            Row {
                id: iconRow
                anchors.centerIn: parent
                spacing: 5

                visible: showIcons

                // Get all running apps on this workspace, filtering out duplicates
                property var uniqueClasses: {
                    if (!isOccupied) return [];
                    let classes = [];
                    for (let i = 0; i < ws.toplevels.values.length; i++) {
                        let tl = ws.toplevels.values[i];
                        //let windowClass = tl.lastIpcObject.class;
                        //let cls = tl.title;
//
                        //if (windowClass == "" || windowClass == undefined || windowClass == "steam_app_default" || windowClass == "~"){
                        //    windowClass = cls
                        //}
                        //let windowTitle = tl.title;
                        let windowClass = ClassOrTitle.excludeClass(tl.lastIpcObject.class, tl.title)
                        //console.log("[Vented Debug] Title or CLass output for Icons: ", ClassOrTitle.excludeClass(windowClass, windowTitle))

                        if (windowClass !== "" && !classes.includes(windowClass)) {
                            classes.push(windowClass);
                        }
                    }

                    if (classes.length === 0) classes.push("unknown");
                    return classes;
                }

                Repeater {
                    model: iconRow.uniqueClasses

                    delegate: Text {
                        text: BarIcons.getAppIcon(modelData)
                        font.family: Appearance.font.family.iconNerd
                        font.pixelSize: 11
                        color: isFocused ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSecondary
                        anchors.verticalCenter: parent.verticalCenter
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
