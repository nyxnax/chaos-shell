import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets
import qs.services

Rectangle {
    id: root
    height: 30
    width: layout.width
    color: mouse.containsMouse ? "#2affffff" : "#00000000"
    radius: 6

    Behavior on color { ColorAnimation { duration: 150 } }

    Behavior on width {
        NumberAnimation {
            duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            Global.states.settingsOpen = true
        }
        PointingHand {}
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: -2

        Item { // Input
            id: input
            implicitHeight: root.height
            implicitWidth: root.height

            MaterialSymbol {
                id: inputIcon
                text: "mic_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }

            readonly property bool shouldShow: Audio.source?.audio?.muted ?? false
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }

            scale: shouldShow ? 1 : 0.95
            Behavior on scale {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                }
            }
        }

        Item { // Output
            id: output
            implicitHeight: root.height
            implicitWidth: root.height

            MaterialSymbol {
                id: outputIcon
                text: "volume_off"
                iconSize: Appearance.font.pixelSize.larger
                anchors.centerIn: parent
                opacity: 0.6
            }

            readonly property bool shouldShow: Audio.sink?.audio?.muted ?? false
            opacity: shouldShow ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }

            scale: shouldShow ? 1 : 0.95
            Behavior on scale {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                }
            }
        }

        Item { // Network
            id: network
            implicitHeight: root.height
            implicitWidth: root.height
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
            }
        }
    }
}
