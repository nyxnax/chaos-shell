import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.common

Rectangle {
    id: root

    height: 32
    implicitHeight: 32
    Layout.preferredHeight: 32

    implicitWidth: trayLayout.implicitWidth + 16
    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuart }
    }

    radius: 8
    color: Appearance.colors.m3surfaceVariant

    property bool isExpanded: hoverHandler.hovered

    HoverHandler {
        id: hoverHandler
    }

    RowLayout {
        id: trayLayout
        anchors.centerIn: parent

        spacing: (root.isExpanded && SystemTray.items.values.length > 0) ? 10 : 0
        Behavior on spacing { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }

        //expander dot
        Rectangle {
            implicitWidth: 10
            implicitHeight: 10
            Layout.preferredWidth: 10
            Layout.preferredHeight: 10

            radius: 5
            color: root.isExpanded ? Appearance.colors.m3onSurfaceVariant : "transparent"
            border.color: Appearance.colors.m3onSurfaceVariant
            border.width: 2
            Layout.alignment: Qt.AlignVCenter

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        // --- THE TRAY ICONS (Sliding Drawer) ---
        Row {
            id: iconRow
            spacing: 10
            clip: true // Acts as a mask, hiding icons when the width shrinks below their size

            // Expand to fit the icons when hovered, crush down to 0px when not
            Layout.preferredWidth: root.isExpanded ? implicitWidth : 0
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

            opacity: root.isExpanded ? 1 : 0

            Behavior on Layout.preferredWidth { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

            Repeater {
                model: SystemTray.items.values

                delegate: Item {
                    id: iconContainer
                    width: 20
                    height: 20
                    property string rawIcon: modelData.icon ? modelData.icon.toString() : ""
                    property bool hasPath: rawIcon.indexOf("?path=") !== -1

                    property string iconName: {
                        let leftPart = rawIcon.split("?path=")[0];
                        return leftPart.split("/").pop();
                    }
                    property string iconDir: hasPath ? rawIcon.split("?path=")[1] : ""

                    // 2. Fallback Image Chain
                    Image {
                        anchors.fill: parent
                        sourceSize: Qt.size(24, 24)
                        source: !iconContainer.hasPath ? modelData.icon : ""
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        visible: source.toString() !== ""
                    }

                    Image {
                        id: pngImg
                        anchors.fill: parent
                        sourceSize: Qt.size(24, 24)
                        source: iconContainer.hasPath ? "file://" + iconContainer.iconDir + "/" + iconContainer.iconName + ".png" : ""
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        visible: source.toString() !== ""
                    }

                    Image {
                        id: svgImg
                        anchors.fill: parent
                        sourceSize: Qt.size(24, 24)
                        source: (iconContainer.hasPath && pngImg.status === Image.Error) ? "file://" + iconContainer.iconDir + "/" + iconContainer.iconName + ".svg" : ""
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        visible: source.toString() !== ""
                    }

                    // 3. Interaction
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        ToolTip.text: modelData.tooltipText || modelData.title || ""
                        ToolTip.visible: containsMouse && ToolTip.text !== ""
                    }
                }
            }
        }
    }
}
