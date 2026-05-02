pragma Singleton
import Quickshell
import qs.common

Singleton {
    id: root

    function getPosition(screenName) {
        const perDisplayEnabled = Config.options?.bar?.enablePerDisplayPosition ?? false;
        const defaultPos = Config.options?.bar?.position ?? "top";
        if (perDisplayEnabled && ShellState.ready) {
            return ShellState.values.bar?.[screenName]?.position ?? defaultPos;
        }
        return defaultPos;
    }

    function setPosition(screenName, newPosition) {
        ShellState.setStateValue("bar", screenName, "position", newPosition);
    }
}
