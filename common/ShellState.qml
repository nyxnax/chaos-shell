pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    property string filePath: Directories.shellStatePath
    property alias values: shellStateJsonAdapter
    property bool ready: false
    property int readWriteDelay: 50

    function setDisplayValue(monitorName, key, value) {
        if (!monitorName || monitorName === "undefined") return;
        let currentBarData = JSON.parse(JSON.stringify(shellStateJsonAdapter.bar || {}));
        let monitorSettings = currentBarData[monitorName] || {};
        monitorSettings[key] = value;
        currentBarData[monitorName] = monitorSettings;
        shellStateJsonAdapter.bar = currentBarData;
        fileWriteTimer.restart();
    }

    Timer { id: fileReloadTimer; interval: root.readWriteDelay; repeat: false; onTriggered: configFileView.reload() }
    Timer { id: fileWriteTimer; interval: root.readWriteDelay; repeat: false; onTriggered: configFileView.writeAdapter() }

    FileView {
        id: configFileView
        path: root.filePath
        watchChanges: true
        onFileChanged: fileReloadTimer.restart()
        onAdapterUpdated: fileWriteTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) writeAdapter();
        }

        JsonAdapter {
            id: shellStateJsonAdapter
            property var bar: ({})
        }
    }
}
