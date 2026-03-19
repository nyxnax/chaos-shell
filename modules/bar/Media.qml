import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.services
import Qt5Compat.GraphicalEffects

RowLayout {
    id: root
    spacing: 8


    readonly property bool shouldShow: MediaService.hasMedia && Config.options.bar.showMedia
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

    // Album Art
    Rectangle {
        id: albumArt
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        radius: 8
        color: Appearance.colors.m3surfaceVariant
        clip: true

        readonly property bool isShown: MediaService.trackArtUrl !== "" && Config.options.bar.showCoverArt
        visible: opacity > 0

        opacity: isShown ? 1 : 0
        scale: isShown ? 1 : 0.7

        Behavior on opacity {
            NumberAnimation {
                duration: Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }

        Image {
            id: coverArt
            anchors.fill: parent
            source: MediaService.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            mipmap: true // Makes it look smooth when scaled down to 32x32

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: coverArt.width
                    height: coverArt.height
                    radius: albumArt.radius
                }
            }

            Behavior on source {
                NumberAnimation {
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                    easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
                }
            }
        }
    }

    // Play/Pause Button
    Rectangle {
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        radius: 8
        color: Appearance.colors.m3surfaceVariant
        clip: true

        Text {
            anchors.centerIn: parent
            text: MediaService.isPlaying ? "󰏤" : "󰐊"
            color: Appearance.colors.m3onSurfaceVariant
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: MediaService.togglePlayPause()
        }
    }

    // Text Display with Marquee Scrolling
    ColumnLayout {
        spacing: -2
        Layout.maximumWidth: 200
        Layout.fillWidth: true
        clip: true

        // Scrolling Title Container
        Item {
            id: titleContainer
            Layout.fillWidth: true
            Layout.preferredWidth: titleText.implicitWidth
            Layout.preferredHeight: titleText.implicitHeight
            clip: true

            // React to layout resizing
            onWidthChanged: titleText.checkScroll()

            Text {
                id: titleText
                text: MediaService.trackTitle
                color: Appearance.colors.m3onBackground
                font.pixelSize: 13
                font.weight: Font.DemiBold

                onTextChanged: checkScroll()
                onImplicitWidthChanged: checkScroll()

                function checkScroll() {
                    // Only start the animation if the text actually overflows the container
                    if (implicitWidth > titleContainer.width && titleContainer.width > 0) {
                        if (!titleAnim.running) titleAnim.restart();
                    } else {
                        // Otherwise, kill the animation and lock it to the start position
                        titleAnim.stop();
                        x = 0;
                    }
                }

                SequentialAnimation on x {
                    id: titleAnim
                    loops: Animation.Infinite

                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        // Safety clamp: ensures 'to' is NEVER positive, making it physically impossible to scroll backwards
                        to: Math.min(0, titleContainer.width - titleText.implicitWidth)
                        duration: Math.max(1000, (titleText.implicitWidth - titleContainer.width) * 30)
                    }
                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: 0
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // Scrolling Artist Container
        Item {
            id: artistContainer
            Layout.fillWidth: true
            Layout.preferredWidth: artistText.implicitWidth
            Layout.preferredHeight: artistText.implicitHeight
            clip: true

            onWidthChanged: artistText.checkScroll()

            Text {
                id: artistText
                text: MediaService.trackArtist
                color: Appearance.colors.m3outline
                font.pixelSize: 11

                onTextChanged: checkScroll()
                onImplicitWidthChanged: checkScroll()

                function checkScroll() {
                    if (implicitWidth > artistContainer.width && artistContainer.width > 0) {
                        if (!artistAnim.running) artistAnim.restart();
                    } else {
                        artistAnim.stop();
                        x = 0;
                    }
                }

                SequentialAnimation on x {
                    id: artistAnim
                    loops: Animation.Infinite

                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: Math.min(0, artistContainer.width - artistText.implicitWidth)
                        duration: Math.max(1000, (artistText.implicitWidth - artistContainer.width) * 30)
                    }
                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: 0
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
