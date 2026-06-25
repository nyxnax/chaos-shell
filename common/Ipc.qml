import Quickshell
import Quickshell.Io
import qs.settings
import qs.services

Scope {
    id: root

    IpcHandler {
        target: "settings"

        function toggle() {
            Global.states.settingsOpen = !Global.states.settingsOpen;
            return "Settings toggled: " + Global.states.settingsOpen;
        }

        function open() {
            Global.states.settingsOpen = true;
            return "Settings opened";
        }
    }

    IpcHandler {
        target: "session"

        function toggle() {
            Global.states.sessionManagerOpen = !Global.states.sessionManagerOpen;
            return "Session manager toggled: " + Global.states.sessionManagerOpen;
        }

        function open() {
            Global.states.sessionManagerOpen = true;
            return "Session manager opened";
        }

        function close() {
            Global.states.sessionManagerOpen = false;
            return "Session manager closed";
        }
    }

    IpcHandler {
        target: "brightness"

        function increase() {
            Brightness.increaseBrightness();
            return "Increasing brightness";
        }

        function decrease() {
            Brightness.decreaseBrightness();
            return "Decreasing brightness";
        }
    }

    IpcHandler {
		target: "media"

		function playPause(): void {MediaService.togglePlaying();}
		function previous(): void {MediaService.previous();}
		function next(): void {MediaService.next();}
	}

    IpcHandler {
        target: "theme"

        function toggle() {
            Config.options.appearance.light = !Config.options.appearance.light
            Theme.generate()
        }

        function dark() {
            Config.options.appearance.light = false
            Theme.generate()
        }

        function light() {
            Config.options.appearance.light = true
            Theme.generate()
        }
    }

    IpcHandler {
        target: "power"
        function cycleProfile() {
            PowerService.cycleProfile()
        }
    }
}
