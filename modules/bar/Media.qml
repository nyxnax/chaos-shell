import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.common

RowLayout {
    id: root
    spacing: 8

    // Hide completely if there is no active player
    visible: activePlayer !== null

    // Dont ask it wouldnt die
    readonly property var validPlayers: {
        return Mpris.players.values.filter(p => {
            const dbusName = p.dbusName ? p.dbusName.toLowerCase() : "";
            if (dbusName.includes("playerctld")) return false;

            if (p.canControl === false) return false;
            if (!p.trackTitle || p.trackTitle.trim() === "") return false;

            const desktop = p.desktopEntry ? p.desktopEntry.toLowerCase() : "";
            if (desktop.includes("playerctl")) return false;

            return true;
        });
    }

    readonly property var activePlayer: {
        if (validPlayers.length === 0) return null;

        const playing = validPlayers.find(p => p.playbackState === MprisPlaybackState.Playing);
        if (playing) return playing;

        const paused = validPlayers.find(p => p.playbackState === MprisPlaybackState.Paused);
        return paused || null;
    }

    readonly property string trackTitle: activePlayer ? activePlayer.trackTitle : ""
    readonly property string trackArtist: activePlayer ? activePlayer.trackArtist : ""

    Behavior on opacity { NumberAnimation { duration: 200 } }
    opacity: activePlayer ? 1 : 0

    // Play/Pause Button
    Rectangle {
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        radius: 8
        color: Appearance.colors.m3surfaceVariant
        clip: true

        Text {
            anchors.centerIn: parent
            text: (activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing) ? "󰏤" : "󰐊"
            color: Appearance.colors.m3onSurfaceVariant
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (!activePlayer) return;
                if (activePlayer.playbackState === MprisPlaybackState.Playing) {
                    activePlayer.pause();
                } else {
                    activePlayer.play();
                }
            }
        }
    }

    // Text Display with Marquee Scrolling
    ColumnLayout {
        spacing: -2
        Layout.maximumWidth: 200 // Increased from 150
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
                text: root.trackTitle
                color: Appearance.colors.m3onBackground
                font.pixelSize: 13
                font.weight: Font.DemiBold

                // Reset scroll position when the song changes
                onTextChanged: {
                    x = 0;
                    titleAnim.restart();
                }

                SequentialAnimation on x {
                    id: titleAnim
                    loops: Animation.Infinite
                    // Only scroll if the text is longer than the container
                    running: titleText.implicitWidth > titleContainer.width && titleContainer.width > 0

                    PauseAnimation { duration: 2000 }
                    NumberAnimation {
                        to: titleContainer.width - titleText.implicitWidth
                        // Speed scales with text length so it always feels consistent (approx 30ms per pixel)
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
                text: root.trackArtist
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
}
