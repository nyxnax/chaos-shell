import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    usePadding: true
    spacing: 8

    GridLayout { // CPU Percentage
        id: cpuGrid
        flow: isVertical ? Grid.TopToBottom : Grid.LeftToRight
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        visible: Config.options.bar.showCpuPercent
        rowSpacing: 4
        columnSpacing: 2

        MaterialSymbol {
            id: cpuIcon
            text: "memory"
            iconSize: Appearance.font.pixelSize.larger
            color: {
                const u = DeviceService.cpuUsage;
                u > 0.85 ? Appearance.colors.m3error
                : u > 0.30 ? Appearance.colors.m3primary
                : u > 0.10 ? Appearance.colors.m3onSurface
                : Appearance.colors.m3outline
            }
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            fill: 1
            
            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        StyledText {
            id: cpuPercent
            visible: (!Config.options.bar.showSystemStatsPercentOnHover || root.hovered)
            text: `${Math.round(DeviceService.cpuUsage * 100)}`
            font.pixelSize: Appearance.font.pixelSize.small
            font.weight: 1000
            color: DeviceService.cpuUsage > 0.85 
                ? Appearance.colors.m3error 
                : Appearance.colors.m3onSurface
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }
    }

    GridLayout { // Ram Percentage
        id: ramGrid
        flow: isVertical ? Grid.TopToBottom : Grid.LeftToRight
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        visible: Config.options.bar.showRamPercent
        rowSpacing: 4
        columnSpacing: 2

        MaterialSymbol {
            id: ramIcon
            text: "memory_alt"
            iconSize: Appearance.font.pixelSize.larger
            color: {
                const u = DeviceService.ramUsage;
                u > 0.85 ? Appearance.colors.m3error
                : u > 0.30 ? Appearance.colors.m3primary
                : u > 0.10 ? Appearance.colors.m3onSurface
                : Appearance.colors.m3outline
            }
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            fill: 1

            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        StyledText {
            id: ramPercent
            visible: (!Config.options.bar.showSystemStatsPercentOnHover || root.hovered)
            text: `${Math.round(DeviceService.ramUsage * 100)}`
            font.pixelSize: Appearance.font.pixelSize.small
            font.weight: 1000
            color: DeviceService.cpuUsage > 0.85 
                ? Appearance.colors.m3error 
                : Appearance.colors.m3onSurface
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }
    }

    StyledText { // Ram Usage
        visible: !root.isVertical && Config.options.bar.showRamUsage && (!Config.options.bar.showRamUsageOnHover || root.hovered)
        text: DeviceService.ramUsedGb.toFixed(1) + " GB / " + DeviceService.ramTotalGb.toFixed(1) + " GB"
        font.pixelSize: Appearance.font.pixelSize.small
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    }
}