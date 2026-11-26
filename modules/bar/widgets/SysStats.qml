import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    usePadding: true
    spacing: 2

    GridLayout { // CPU Percentage
        id: cpuGrid
        flow: isVertical ? Grid.TopToBottom : Grid.LeftToRight
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        visible: Config.options.bar.hardwareStatIndicators === "cpu" || Config.options.bar.hardwareStatIndicators === "both"
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
        visible: Config.options.bar.hardwareStatIndicators === "ram" || Config.options.bar.hardwareStatIndicators === "both"
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

    RowLayout { // Download speed
        id: downloadSpeed
        spacing: 0
        Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.preferredWidth: shouldShow ? -1 : 0
        Layout.preferredHeight: shouldShow ? -1 : 0

        MaterialSymbol {
            id: downloadSpeedIcon
            text: "download"
            iconSize: Appearance.font.pixelSize.larger
            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3primary : Appearance.colors.m3outline
            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        StyledText {
            visible: !root.isVertical && (Config.options.bar.networkSpeedValues === "always" && downloadSpeed.shouldShow || (Config.options.bar.networkSpeedValues === "hover" && root.hovered))
            text: Network.downloadSpeedText ?? "0 B/s"
            font.pixelSize: Appearance.font.pixelSize.small
            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        readonly property bool shouldShow: {
            const isConnected = Network.status === "connected" || Network.wifiStatus === "connected";
            const isEnabledInConfig = Config.options.bar.networkSpeedIndicators === "download" || Config.options.bar.networkSpeedIndicators === "both";
            const passesZeroCheck = Config.options.bar.hideNetworkSpeedWhenZero ? Network.downloadSpeedBytes > 0 : true;
            const passesHoverCheck = Config.options.bar.showNetworkSpeedOnHover ? root.hovered : true;
            return isConnected && isEnabledInConfig && passesZeroCheck && passesHoverCheck;
        }

        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    }

    RowLayout { // Upload speed
        id: uploadSpeed
        spacing: 0
        Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.preferredWidth: shouldShow ? -1 : 0
        Layout.preferredHeight: shouldShow ? -1 : 0

        MaterialSymbol {
            id: uploadSpeedIcon
            text: "upload"
            iconSize: Appearance.font.pixelSize.larger
            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3secondary : Appearance.colors.m3outline
            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        StyledText {
            visible: !root.isVertical && (Config.options.bar.networkSpeedValues === "always" && uploadSpeed.shouldShow || (Config.options.bar.networkSpeedValues === "hover" && root.hovered))
            text: Network.uploadSpeedText ?? "0 B/s"
            font.pixelSize: Appearance.font.pixelSize.small
            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
        }

        readonly property bool shouldShow: {
            const isConnected = Network.status === "connected" || Network.wifiStatus === "connected";
            const isEnabledInConfig = Config.options.bar.networkSpeedIndicators === "upload" || Config.options.bar.networkSpeedIndicators === "both";
            const passesZeroCheck = Config.options.bar.hideNetworkSpeedWhenZero ? Network.uploadSpeedBytes > 0 : true;
            const passesHoverCheck = Config.options.bar.showNetworkSpeedOnHover ? root.hovered : true;
            return isConnected && isEnabledInConfig && passesZeroCheck && passesHoverCheck;
        }

        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    }
}
