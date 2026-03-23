import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.common.widgets
import qs.services
import Qt5Compat.GraphicalEffects

BarItem {
    id: root
    width: layout.implicitWidth

    readonly property bool isShown: MediaService.hasMedia && Config.options.bar.showMedia
    opacity: isShown ? 1 : 0
    visible: opacity > 0

    RowLayout {
        id: layout
        spacing: 8
        anchors.centerIn: parent

        Rectangle { // Album Art
            id: albumArt
            Layout.preferredWidth: root.height
            Layout.preferredHeight: root.height
            radius: 8
            color: Appearance.colors.m3surfaceVariant
            clip: true

            readonly property bool isShown: MediaService.trackArtUrl !== "" && Config.options.bar.showCoverArt

            visible: opacity > 0
            opacity: isShown ? 1 : 0
            scale: isShown ? 1 : 0.7

            Behavior on opacity {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }

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

        Rectangle { // Play/Pause Button
            id: playPause
            opacity: Config.options.bar.showMediaControl ? 1 : 0
            visible: opacity > 0
            Layout.preferredWidth: root.height
            Layout.preferredHeight: root.height
            radius: MediaService.isPlaying ? 8 : 15
            color: MediaService.isPlaying ? Appearance.colors.m3surfaceVariant : Appearance.colors.m3secondaryContainer
            scale: buttonArea.pressed ? 0.9 : 1.0
            Behavior on radius {animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)}
            Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
            Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}
            Behavior on opacity {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)}

            clip: true

            StyledText {
                anchors.centerIn: parent
                text: MediaService.isPlaying ? "󰏤" : "󰐊"
                color: MediaService.isPlaying ? Appearance.colors.m3onSurfaceVariant : Appearance.colors.m3onSecondaryContainer
                scale: buttonArea.pressed ? 0.9 : 1.0

                Behavior on color {animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)}
                Behavior on scale {animation: Appearance.animation.clickBounce.numberAnimation.createObject(this) }
                font.pixelSize: 20
            }

            MouseArea {
                id: buttonArea
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
            Layout.leftMargin: (albumArt.visible || playPause.visible) ? 0 : 10
            Layout.rightMargin: 8

            Item { // Scrolling Title Container
                id: titleContainer
                Layout.fillWidth: true
                Layout.preferredWidth: titleText.implicitWidth
                Layout.preferredHeight: titleText.implicitHeight
                clip: true

                Behavior on Layout.preferredWidth {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                onWidthChanged: titleText.checkScroll() // React to layout resizing

                StyledText {
                    id: titleText
                    text: MediaService.trackTitle
                    color: Appearance.colors.m3onBackground
                    font.pixelSize: Config.options.bar.showArtist ? Appearance.font.pixelSize.smaller : Appearance.font.pixelSize.normal
                    font.weight: 500

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
                visible: Config.options.bar.showArtist
                Behavior on Layout.preferredWidth {animation: Appearance.animation.elementMove.numberAnimation.createObject(this)}

                onWidthChanged: artistText.checkScroll()

                StyledText {
                    id: artistText
                    text: MediaService.trackArtist
                    color: Appearance.colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.smallest
                    font.weight: 400


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
