pragma Singleton
import QtQuick
import Quickshell
import qs.common

Singleton {
    id: root

    function getPosition(displayName) {
        const perDisplayEnabled = Config.options?.bar?.enablePerDisplayPosition ?? false;
        const defaultPos = Config.options?.bar?.position ?? "top";
        if (perDisplayEnabled && ShellState.ready) {
            return ShellState.values.bar?.[displayName]?.position ?? defaultPos;
        }
        return defaultPos;
    }

    function setPosition(displayName, newPosition) {
        ShellState.setStateValue("bar", displayName, "position", newPosition);
    }

    readonly property var defaultWidgets: {
        "left": ["Clock", "WindowTitle"],
        "center": ["Workspaces"],
        "right": ["SysTray", "Media", "ControlCenter", "BatteryIndicator", "SessionButton"]
    }

    readonly property var availableWidgets: [
        {name: "Battery",        value: "BatteryIndicator",   icon: "battery_android_full"},
        {name: "Clock",          value: "Clock",              icon: "schedule"},
        {name: "Control Center", value: "ControlCenter",    icon: "wifi"},
        {name: "Media",          value: "Media",              icon: "music_note"},
        {name: "Logout",         value: "SessionButton",      icon: "logout"},
        {name: "System Tray",    value: "SysTray",            icon: "arrow_circle_up"},
        {name: "Window Title",   value: "WindowTitle",        icon: "title"},
        {name: "Workspaces",     value: "Workspaces",         icon: "workspaces"}
    ]

    function getWidgetInfo(val) {
        return availableWidgets.find(w => w.value === val) || { name: val, icon: "extension" };
    }

    function getWidgetsFor(displayName, area) {
        const barState = ShellState.values.bar || {};
        const perDisplayEnabled = Config.options?.bar?.enablePerDisplayWidgets ?? false;
        if (perDisplayEnabled && barState[displayName]?.widgets?.[area]) {
            return barState[displayName].widgets[area];
        }
        return barState["default"]?.widgets?.[area]
            || ShellState.values.global?.widgets?.[area]
            || defaultWidgets[area];
    }

    function moveWidget(displayName, area, fromIndex, toIndex) {
        let widgets = [...getWidgetsFor(displayName, area)];
        const [movedItem] = widgets.splice(fromIndex, 1);
        widgets.splice(toIndex, 0, movedItem);
        saveWidgets(displayName, area, widgets);
    }

    function removeWidget(displayName, area, index) {
        let widgets = [...getWidgetsFor(displayName, area)];
        widgets.splice(index, 1);
        saveWidgets(displayName, area, widgets);
    }

    function addWidget(displayName, area, widgetName) {
        let widgets = [...getWidgetsFor(displayName, area)];
        if (!widgets.includes(widgetName)) {
            widgets.push(widgetName);
            saveWidgets(displayName, area, widgets);
        }
    }

    function saveWidgets(displayName, area, widgetList) {
        ShellState.setStateValue("bar", displayName, "widgets", widgetList, area);
    }

    function copyGlobal(displayName, area) {
        if (displayName === "default") return;
        ShellState.setStateValue("bar", displayName, "widgets", null, area);
    }

    function resetGlobal(area) {
        ShellState.setStateValue("bar", "default", "widgets", null, area);
    }
}
