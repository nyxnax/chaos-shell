import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
    spacing: 3

    //implicitWidth: childrenRect.width
    //implicitHeight: 12


    property int workspaceOffset: 0
    property int workspaceCount: 5

    // workspace dubug
    //Text { text: workspaceOffset; color: "red"; font.pixelSize: 10 } 

    Repeater {
        model: workspaceCount
        delegate: Rectangle {
            // calculate workspace offset for split workspaces
            readonly property int wsId: workspaceOffset + index + 1

            readonly property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
            //readonly property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            readonly property bool exists: ws !== undefined
            readonly property bool isOccupied: exists && ws.toplevels.values.length > 0
            //readonly property bool isFocused: Hyprland.focusedWorkspace?.id === wsId
            readonly property bool isFocused: exists && ws.focused 


            Layout.preferredWidth: isFocused ? 25 : 12
            Layout.preferredHeight: 12
            radius: 100

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            color: {
                if (isFocused) return "#FFFFFF"
                if (isOccupied) return "#5a5a5a"
                return "#2a2a2a"
            }
            /*
            Text {
                text: wsId; color: "red"; font.pixelSize: 8
                anchors.centerIn: parent 
            }
            */
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${wsId}`)
                //onClicked: Hyprland.dispatch("workspace " + (index +1)) 
            }
        }
    }
}
