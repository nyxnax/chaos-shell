pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// Credit: modified from https://git.outfoxxed.me/outfoxxed/nixnew

Singleton {
    id: root

    property MprisPlayer trackedPlayer: null
    property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null;
    signal trackChanged(reverse: bool);
    property bool _reverse: false

    property var activeTrack;
    property bool isPlaying: this.activePlayer && this.activePlayer.isPlaying
    property bool canTogglePlaying: this.activePlayer?.canTogglePlaying ?? false;
    property bool canGoPrevious: this.activePlayer?.canGoPrevious ?? false;
    property bool canGoNext: this.activePlayer?.canGoNext ?? false;
    property bool canChangeVolume: this.activePlayer && this.activePlayer.volumeSupported && this.activePlayer.canControl;
    property bool loopSupported: this.activePlayer && this.activePlayer.loopSupported && this.activePlayer.canControl;
    property bool shuffleSupported: this.activePlayer && this.activePlayer.shuffleSupported && this.activePlayer.canControl;
    property bool hasShuffle: this.activePlayer?.shuffle ?? false;


    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData
            target: modelData

            Component.onCompleted: {
                if (root.trackedPlayer == null || modelData.isPlaying) {
                    root.trackedPlayer = modelData
                }
            }

            Component.onDestruction: {
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const player of Mpris.players.values) {
                        if (player.playbackState.isPlaying) {
                            root.trackedPlayer = player;
                            break;
                        }
                    }

                    if (trackedPlayer == null && Mpris.players.values.length != 0) {
                        trackedPlayer = Mpris.players.values[0];
                    }
                }
            }

            function onPlaybackStateChanged() {
                if (root.trackedPlayer !== modelData) root.trackedPlayer = modelData;
            }
        }
    }

    Connections {
        target: activePlayer

        function onPostTrackChanged() {
            root.updateTrack();
        }

        function onTrackArtUrlChanged() {
            console.log("[Media Service] Art URL: ", activePlayer.trackArtUrl)

            if (root.activePlayer.uniqueId == root.activeTrack.uniqueId && root.activePlayer.trackArtUrl != root.activeTrack.artUrl) {
                const r = root._reverse;
                root.updateTrack();
                root._reverse = r;
            }
        }
    }

    onActivePlayerChanged: this.updateTrack();

    function updateTrack() {
        this.activeTrack = {
            uniqueId: this.activePlayer?.uniqueId ?? 0,
			artUrl: this.activePlayer?.trackArtUrl ?? "",
			title: this.activePlayer?.trackTitle || "Unknown Title",
			artist: this.activePlayer?.trackArtist || "Unknown Artist",
			album: this.activePlayer?.trackAlbum || "Unknown Album",
        };
        this.trackChanged(_reverse);
        this._reverse = false;
    }

    function togglePlaying() {
		if (this.canTogglePlaying) this.activePlayer.togglePlaying();
	}

    function previous() {
		if (this.canGoPrevious) {
			this.__reverse = true;
			this.activePlayer.previous();
		}
	}

    function next() {
		if (this.canGoNext) {
			this.__reverse = false;
			this.activePlayer.next();
		}
	}

    function setLoopState(loopState: var) {
		if (this.loopSupported) {
			this.activePlayer.loopState = loopState;
		}
	}

	function setShuffle(shuffle: bool) {
		if (this.shuffleSupported) {
			this.activePlayer.shuffle = shuffle;
		}
	}

    function setActivePlayer(player: MprisPlayer) {
		const targetPlayer = player ?? Mpris.players[0];
		console.log(`setactive: ${targetPlayer} from ${activePlayer}`)

		if (targetPlayer && this.activePlayer) {
			this.__reverse = Mpris.players.indexOf(targetPlayer) < Mpris.players.indexOf(this.activePlayer);
		} else {
			// always animate forward if going to null
			this.__reverse = false;
		}

		this.trackedPlayer = targetPlayer;
	}
}
