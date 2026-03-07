
import QtQuick
import Quickshell

import qs.modules.bar
import qs.settings

ShellRoot {
    id: root
    property bool ready: false

    Component.onCompleted: {
        Qt.application.name = "Chaos Shell";
        Qt.application.organization = "Choas Labs";
        root.ready = true;
    }

    // Only load these once the metadata is set
    Loader {
        active: root.ready
        sourceComponent: Component {
            Item {
                Bar {}
                Settings {}
            }
        }
    }
}
