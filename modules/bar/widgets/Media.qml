import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import Qt5Compat.GraphicalEffects

BarItem {
    id: root

    readonly property bool isShown:  (MediaService.activePlayer !== null) && Config.options.bar.showMedia
    opacity: isShown ? 1 : 0
    visible: opacity > 0

    GridLayout {
        id: layout
        columns: isVertical ? 1 : 10
        flow: isVertical ? Grid.TopToBottom : Grid.LeftToRight

        Rectangle { // Album Art
            id: albumArt
            width: root.cellSize
            height: root.cellSize
            radius: 8
            color: Appearance.colors.m3surfaceVariant
            clip: true

            readonly property bool isShown: Config.options.bar.showCoverArt
            visible: opacity > 0
            opacity: isShown ? 1 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }

            Image {
                id: coverArt
                anchors.fill: parent
                source: MediaService.activeTrack?.artUrl
                sourceSize.height: 50
                sourceSize.width: 50
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                mipmap: true // Makes it look smooth when scaled down to 32x32

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: root.cellSize
                        height: root.cellSize
                        radius: albumArt.radius
                    }
                }

                opacity: 1

                onSourceChanged: {
                    fadeAnimation.stop();
                    coverArt.opacity = 0;
                    if (status === Image.Ready) {
                        fadeAnimation.start();
                    }
                }

                onStatusChanged: {
                    if (status === Image.Ready) {
                        fadeAnimation.restart();
                    } else if (status === Image.Loading || status === Image.Null) {
                        fadeAnimation.stop();
                        coverArt.opacity = 0;
                    }
                }

                NumberAnimation on opacity {
                    id: fadeAnimation
                    from: 0
                    to: 1
                    duration: Appearance.animation.elementMoveFast.duration
                    easing.type: Appearance.animation.elementMoveFast.type
                }
            }
        }

        Rectangle { // Play/Pause Button
            id: playPause
            opacity: Config.options.bar.showMediaControl ? 1 : 0
            visible: opacity > 0
            width: root.cellSize
            height: root.cellSize
            radius: MediaService.isPlaying ? 8 : 15
            color: MediaService.isPlaying ? Appearance.colors.m3surfaceVariant : Appearance.colors.m3secondaryContainer
            scale: buttonArea.pressed ? 0.9 : (MediaService.isPlaying ? 1.0 : 0.95)
            Behavior on radius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
            Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}
            Behavior on opacity {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}

            clip: true

            StyledText {
                anchors.centerIn: parent
                text: MediaService.isPlaying ? "󰏤" : "󰐊"
                color: MediaService.isPlaying ? Appearance.colors.m3onSurfaceVariant : Appearance.colors.m3onSecondaryContainer
                scale: buttonArea.pressed ? 0.9 : (MediaService.isPlaying ? 1.0 : 0.98)

                Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }
                font.pixelSize: 20
            }

            MouseArea {
                id: buttonArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: MediaService.togglePlaying()
            }
        }

        // Text Display with Marquee Scrolling
        ColumnLayout {
            readonly property bool isShown: Config.options.bar.showMediaText && !isVertical
            opacity: isShown ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}

            spacing: -2
            Layout.maximumWidth: 200
            Layout.fillWidth: true
            clip: true
            Layout.leftMargin: (albumArt.visible || playPause.visible) ? 0 : 10
            Layout.rightMargin: 8

            Item { // Scrolling Title Container
                id: titleContainer
                Layout.fillWidth: true
                Layout.preferredWidth: titleText.implicitWidth
                Layout.preferredHeight: titleText.implicitHeight
                clip: true

                onWidthChanged: titleText.checkScroll() // React to layout resizing

                StyledText {
                    id: titleText
                    text: MediaService.activeTrack?.title
                    color: Appearance.colors.m3onBackground
                    font.pixelSize: artistContainer.visible ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.normal
                    font.weight: 500
                    animateChange: true

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

            Item { // Scrolling Artist Container
                id: artistContainer
                Layout.fillWidth: true
                Layout.preferredWidth: artistText.implicitWidth
                Layout.preferredHeight: artistText.implicitHeight
                clip: true
                visible: Config.options.bar.showArtist && MediaService.activeTrack?.artist !== null
                onWidthChanged: artistText.checkScroll()

                StyledText {
                    id: artistText
                    text: MediaService.activeTrack?.artist
                    color: Appearance.colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    font.weight: 400
                    animateChange: true

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
}
