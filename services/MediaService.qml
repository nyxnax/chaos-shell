pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

QtObject {
    id: root

    // --- Public API for Frontend ---
    readonly property bool hasMedia: activePlayer !== null
    readonly property string trackTitle: activePlayer ? activePlayer.trackTitle : ""
    readonly property string trackArtist: activePlayer ? activePlayer.trackArtist : ""
    readonly property bool isPlaying: activePlayer ? activePlayer.playbackState === MprisPlaybackState.Playing : false

    function togglePlayPause() {
        if (!activePlayer) return;
        if (activePlayer.playbackState === MprisPlaybackState.Playing) {
            activePlayer.pause();
        } else {
            activePlayer.play();
        }
    }

    // --- Internal Logic ---
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
}
