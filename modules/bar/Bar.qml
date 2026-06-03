import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.settings
import qs.services
import qs.common
import qs.common.widgets
import qs.modules.bar.widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens;

        PanelWindow {
            id: bar
            property alias window: bar
            required property var modelData
            screen: modelData

            readonly property bool isAutoHide: Config.options.bar.autoHide
            readonly property string position: BarService.getPosition(modelData.name)
            readonly property bool isVertical: position === "left" || position === "right"
            property real barThickness: 48 * (Config.options.appearance.displayScale / 100)
            property bool mouseOver: false
            readonly property bool expanded: !isAutoHide || mouseOver

            anchors {
                top: position === "top" || isVertical
                bottom: position === "bottom" || isVertical
                left: position === "left" || !isVertical
                right: position === "right" || !isVertical
            }

            exclusionMode: isAutoHide ? ExclusionMode.Ignore : ExclusionMode.Auto
            implicitHeight: isVertical ? -1 : (expanded ? barThickness : 5)
            implicitWidth: isVertical ? (expanded ? barThickness : 5) : -1
            color: "transparent"

            Rectangle { // Background
                id: barBackground
                anchors.fill: parent
                color: Config.options.appearance.opacity <= 0 ? "transparent" :
                        Qt.alpha(Appearance.colors.m3background, Config.options.appearance.opacity / 100.0)
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: bar.mouseOver = true
                onExited: bar.mouseOver = false
                propagateComposedEvents: true
            }

            Item {
                anchors.fill: parent
                anchors.margins: 8
                opacity: bar.expanded ? 1 : 0

                RowLayout { // Left
                    id: barLeft
                    visible: !isVertical
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "left")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }

                ColumnLayout { // Top
                    id: barTop
                    visible: isVertical
                    anchors.top: parent.top
                    spacing: 6

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "left")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }

                RowLayout { // Center
                    anchors.centerIn: parent
                    spacing: 6
                    visible: !isVertical

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "center")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }

                ColumnLayout { // Vertical Center
                    anchors.centerIn: parent
                    spacing: 6
                    visible: isVertical

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "center")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }

                RowLayout { // Right
                    id: barRight
                    visible: !isVertical
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "right")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }

                ColumnLayout { // Bottom
                    id: barBottom
                    visible: isVertical
                    anchors.bottom: parent.bottom
                    spacing: 6

                    Repeater {
                        model: BarService.getWidgetsFor(modelData.name, "right")
                        delegate: BarWidgetLoader { widgetScreen: bar.screen }
                    }
                }
            }
        }
    }
}
