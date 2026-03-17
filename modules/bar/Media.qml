import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.services

RowLayout {
    id: root
    spacing: 8

    // Bind visibility and opacity to the service
    visible: MediaService.hasMedia
    opacity: MediaService.hasMedia ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }

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

            Text {
                id: titleText
                text: MediaService.trackTitle
                color: Appearance.colors.m3onBackground
                font.pixelSize: 13
                font.weight: Font.DemiBold

                onTextChanged: {
                    x = 0;
                    titleAnim.restart();
                }

                SequentialAnimation on x {
                    id: titleAnim
                    loops: Animation.Infinite
                    running: titleText.implicitWidth > titleContainer.width && titleContainer.width > 0

                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: titleContainer.width - titleText.implicitWidth
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

            Text {
                id: artistText
                text: MediaService.trackArtist
                color: Appearance.colors.m3outline
                font.pixelSize: 11

                onTextChanged: {
                    x = 0;
                    artistAnim.restart();
                }

                SequentialAnimation on x {
                    id: artistAnim
                    loops: Animation.Infinite
                    running: artistText.implicitWidth > artistContainer.width && artistContainer.width > 0

                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: artistContainer.width - artistText.implicitWidth
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
    // Album Art
    Rectangle {
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        radius: 8
        color: Appearance.colors.m3surfaceVariant
        clip: true
        // Only show this block if the media player actually provides cover art
        visible: MediaService.trackArtUrl !== ""

        Image {
            anchors.fill: parent
            source: MediaService.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            mipmap: true // Makes it look smooth when scaled down to 32x32
        }
    }
}
