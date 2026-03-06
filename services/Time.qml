pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string hour: Qt.formatDateTime(clock.date, "hh")
    property string minute: Qt.formatDateTime(clock.date, "mm")
    property string date: Qt.formatDateTime(clock.date, "ddd, dd MMM yyyy")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
