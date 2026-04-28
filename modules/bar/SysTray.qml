import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import qs.common
import qs.common.widgets

BarItem {
    id: root

    property bool isExpanded: hoverHandler.hovered
    color: isExpanded ? Appearance.colors.m3surfaceVariant : "transparent"
    implicitWidth: isVertical ? 32 : (isExpanded ? layout.implicitWidth + 14 : 14)
    implicitHeight: isVertical ? (isExpanded ? layout.implicitHeight + 18 : 18) : 32
    Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
    Behavior on implicitWidth {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
    Behavior on implicitHeight { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}

    HoverHandler {id: hoverHandler}

    GridLayout {
        id: layout
        flow: root.isVertical ? Grid.TopToBottom : Grid.LeftToRight
        columns: root.isVertical ? 1 : -1
        rows: root.isVertical ? -1 : 1
        columnSpacing: (root.isExpanded && !isVertical) ? 10 : 0
        rowSpacing: (root.isExpanded && isVertical) ? 10 : 0

        Rectangle { // Expander dot
            implicitWidth: 10
            implicitHeight: 10
            radius: 5
            border.color: Appearance.colors.m3onSurfaceVariant
            border.width: 2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: root.isExpanded ? Appearance.colors.m3onSurfaceVariant : "transparent"
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
        }

        GridLayout { // Icon Row
            id: iconRow
            columnSpacing: (root.isExpanded && !isVertical) ? 6 : 0
            rowSpacing: (root.isExpanded && isVertical) ? 6 : 0
            flow: root.isVertical ? Grid.TopToBottom : Grid.LeftToRight
            columns: root.isVertical ? 1 : -1
            rows: root.isVertical ? -1 : 1
            clip: false

            Layout.preferredWidth: isVertical ? 20 : (root.isExpanded ? implicitWidth : 0)
            Layout.preferredHeight: isVertical ? (root.isExpanded ? implicitHeight : 0) : 20
            Layout.alignment: Qt.AlignVCenter
            opacity: root.isExpanded ? 1 : 0
            Behavior on Layout.preferredWidth {NumberAnimation {duration: 250; easing.type: Easing.OutQuart}}
            Behavior on Layout.preferredHeight {NumberAnimation {duration: 250; easing.type: Easing.OutQuart}}
            Behavior on opacity {NumberAnimation {duration: 200; easing.type: Easing.InOutQuad}}

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

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: modelData.menu
                        anchor.window: bar
                        anchor.item: iconContainer
                        anchor.edges: Quickshell.Bottom | Quickshell.Right
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onPressed: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                if (menuAnchor.anchor.window && menuAnchor.anchor.window.visible) {
                                    menuAnchor.open();
                                } else {
                                    modelData.secondaryActivate();
                                }
                            }
                        }
                    }

                    //StyledToolTip {
                    //    id: trayToolTip
                    //    enabled: false
                    //    shown: mouseArea.containsMouse && text !== ""
                    //    text: (modelData.tooltipText && modelData.tooltipText !== "") ? modelData.tooltipText : modelData.title
                    //    //title: modelData.title || ""
                    //}
                }
            }
        }
    }
}
