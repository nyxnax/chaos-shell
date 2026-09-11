pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property bool available: Bluetooth.adapters.values.length > 0
    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property bool connected: Bluetooth.devices.values.some(d => d.connected)

    property string materialSymbol: connected
        ? "bluetooth_connected"
        : enabled
        ? "bluetooth"
        : "bluetooth_disabled"
}
