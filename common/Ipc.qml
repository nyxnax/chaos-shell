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
}
