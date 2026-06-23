import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

BarItem {
    id: root
    onClicked: Global.states.settingsOpen = !Global.states.settingsOpen
    usePadding: true

    Item { // Input
        id: input
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize - 5
        Layout.alignment: Qt.AlignCenter

        MaterialSymbol {
            id: inputIcon
            text: Audio.sourceMaterialSymbol
            iconSize: Appearance.font.pixelSize.larger
            anchors.centerIn: parent
            color: (Audio.source?.audio?.muted) ? Appearance.colors.m3outline : Appearance.colors.m3primary
            fill: 1
            animateChange: true
        }

        readonly property bool shouldShow: (Audio.ready && Audio.inputAppNodes.length > 0 || Audio.ready && Audio.source?.audio?.muted)
        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    }

    RowLayout { // Output
        id: output
        spacing: 2
        Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter

        property bool timeoutActive: false

        WheelHandler {
            id: volumeWheelHandler
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            orientation: Qt.Vertical
            onWheel: (event) => {
                if (event.angleDelta.y > 0) {
                    Audio.incrementVolume()
                    if (Audio.sink?.audio?.muted) Audio.sink.audio.muted = false
                } else {
                    Audio.decrementVolume()
                }
            }
        }

        Connections {
            target: Audio
            function onValueChanged() {
                output.timeoutActive = true
                sinkPercentTimeout.restart()
            }
        }

        MaterialSymbol {
            id: outputIcon
            Layout.preferredWidth: shouldShow ? -1 : 0
            Layout.preferredHeight: shouldShow ? -1 : 0
            text: Audio.sinkMaterialSymbol
            iconSize: Appearance.font.pixelSize.larger
            color: (!Audio.sink?.audio?.muted && Math.round(Audio.value * 100) > 0) ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
            fill: 1
            animateChange: true

            readonly property bool shouldShow: (Config.options.bar.showSinkSymbol || (Config.options.bar.showSinkOnVolumeChanged && output.timeoutActive)) ? true : (Audio.sink?.audio?.muted ?? false)
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

        }

        StyledText {
            id: sinkPercent
            Layout.preferredWidth: shouldShow ? -1 : 0
            Layout.preferredHeight: shouldShow ? -1 : 0
            text: Math.round(Audio.value * 100) + "%"
            font.pixelSize: Appearance.font.pixelSize.small
            color: (!Audio.sink?.audio?.muted && Math.round(Audio.value * 100) > 0) ? Appearance.colors.m3onSurface : Appearance.colors.m3outline

            readonly property bool shouldShow: !root.isVertical && Config.options.bar.showSinkPercent
                                                && ((Config.options.bar.showSinkPercentOnHover && root.hovered)
                                                || (Config.options.bar.showSinkOnVolumeChanged && output.timeoutActive)
                                                || (!Config.options.bar.showSinkPercentOnHover && !Config.options.bar.showSinkOnVolumeChanged))
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
        }

        Timer {
            id: sinkPercentTimeout
            interval: 3000
            repeat: false
            onTriggered: {
                output.timeoutActive = false;
            }
        }
    }


    Item { // Network
        id: network
        implicitHeight: root.cellSize
        implicitWidth: root.cellSize

        MaterialSymbol {
            id: networkIconBackground
            visible: Network.wifiStatus === "connected" && !Network.ethernet
            text: "wifi"
            opacity: 0.4
            iconSize: networkIcon.iconSize
            anchors.centerIn: parent
        }

        MaterialSymbol {
            id: networkIcon
            text: Network.materialSymbol
            iconSize: Appearance.font.pixelSize.larger
            anchors.centerIn: parent
            fill: 1
        }
    }

    RowLayout { // Download speed
        id: downloadSpeed
        spacing: 2
        Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.preferredWidth: shouldShow ? -1 : 0
        Layout.preferredHeight: shouldShow ? -1 : 0

        MaterialSymbol {
            id: downloadSpeedIcon
            text: "download"
            iconSize: Appearance.font.pixelSize.larger
            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3primary : Appearance.colors.m3outline
        }

        StyledText {
            visible: !root.isVertical && Config.options.bar.showNetworkSpeedText && downloadSpeed.shouldShow && (!Config.options.bar.showNetworkSpeedTextOnHover || root.hovered)
            text: Network.downloadSpeedText ?? "0 B/s"
            font.pixelSize: Appearance.font.pixelSize.small
            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
        }

        readonly property bool shouldShow: {
            const isConnected = Network.status === "connected" || Network.wifiStatus === "connected";
            const isEnabledInConfig = Config.options.bar.showDownloadSpeed;
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
        spacing: 2
        Layout.alignment: root.isVertical ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.preferredWidth: shouldShow ? -1 : 0
        Layout.preferredHeight: shouldShow ? -1 : 0

        MaterialSymbol {
            id: uploadSpeedIcon
            text: "upload"
            iconSize: Appearance.font.pixelSize.larger
            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3secondary : Appearance.colors.m3outline
        }

        StyledText {
            visible: !root.isVertical && Config.options.bar.showNetworkSpeedText && uploadSpeed.shouldShow && (!Config.options.bar.showNetworkSpeedTextOnHover || root.hovered)
            text: Network.uploadSpeedText ?? "0 B/s"
            font.pixelSize: Appearance.font.pixelSize.small
            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
        }

        readonly property bool shouldShow: {
            const isConnected = Network.status === "connected" || Network.wifiStatus === "connected";
            const isEnabledInConfig = Config.options.bar.showUploadSpeed;
            const passesZeroCheck = Config.options.bar.hideNetworkSpeedWhenZero ? Network.uploadSpeedBytes > 0 : true;
            const passesHoverCheck = Config.options.bar.showNetworkSpeedOnHover ? root.hovered : true;
            return isConnected && isEnabledInConfig && passesZeroCheck && passesHoverCheck;
        }

        opacity: shouldShow ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }
    }
}
