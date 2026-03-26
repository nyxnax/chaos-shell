import Quickshell
import Quickshell.Io
import qs.settings

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
}
