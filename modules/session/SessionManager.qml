import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

PanelWindow {
    id: root
    visible: Global.states.sessionManagerOpen
    color: "transparent"

    Process{
        id: sessionProc

        onExited: (code) => {
            if (code !== 0) {
                console.error("Session Manager: Command failed with code " + code);
                Global.states.sessionManagerOpen = true;
            }
        }
    }

    function runCommand(cmdString) {
        Global.states.sessionManagerOpen = false;
        sessionProc.command = ["sh", "-c", cmdString];
        sessionProc.running = true;
    }

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {top: true; bottom: true; left: true; right: true}

    Rectangle { // Fullscreen background
        anchors.fill: parent
        color: "black"
        opacity: root.visible ? 0.3 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        TapHandler { onTapped: Global.states.sessionManagerOpen = false }
    }

    Rectangle { // Rectangle background / Dialog
        id: background
        anchors.centerIn: parent
        height: 150 * (Config.options.appearance.displayScale / 100)
        width: 600 * (Config.options.appearance.displayScale / 100)
        color: Appearance.colors.m3background
        radius: Appearance.rounding.verylarge
        focus: root.visible
        Keys.onEscapePressed: Global.states.sessionManagerOpen = false

        RowLayout { // Buttons
            id:buttonRow
            anchors.margins: 10
            anchors.fill: parent
            spacing: 6

            Repeater {
                model: [
                    {name: "Shutdown",  icon: "power_settings_new",  cmd: "systemctl poweroff"},
                    {name: "Restart",   icon: "restart_alt",         cmd: "systemctl reboot"},
                    {name: "Lock",      icon: "lock",                cmd: "loginctl lock-session"},
                    {name: "Logout",    icon: "logout",              cmd: "pkill Hyprland || pkill sway || pkill niri || loginctl terminate-user $USER" }
                ]

                delegate: StyledButton {
                    radius: Appearance.rounding.verylarge - buttonRow.anchors.margins
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    size: StyledButton.Size.XL
                    //text: modelData.name
                    buttonIcon: modelData.icon
                    onClicked: root.runCommand(modelData.cmd)
                }
            }
        }
    }
}
