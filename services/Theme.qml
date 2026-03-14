pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root
    property string filePath: Directories.themeJson

    function reapplyTheme() {
        themeFileView
    }

    Process {
        id: matugenProc

        onExited: (code) => {
            if (code === 0) {
                console.log("Theme Service: Matugen finished successfully.");
                swwwProc.run(); // Set wallpaper
                swwwStart.run(); // Start Wallpaper
            } else {
                console.error("Theme Service: Matugen failed with exit code " + code);
            }
        }
    }

    function generate() {
                let img = Config.options.appearance.wallpaper
        if (!img) {
            console.log("Theme Service: No wallpaper to generate from.");
            return;
        }

        matugenProc.command = [
            "matugen", "image", img,
            "-t", Config.options.appearance.scheme,
            "-m", Config.options.appearance.light ? "light" : "dark",
            "--source-color-index", "1",
            "--verbose",
        ];

        console.log("Theme Service: Executing Matugen...");
        matugenProc.running = true;
    }

    function applyColors(fileContent) {
        const json = JSON.parse(fileContent)
        for (const key in json) {
            if (json.hasOwnProperty(key)) {
                // Convert snake_case to CamelCase
                const camelCaseKey = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                const m3Key = `m3${camelCaseKey}`
                Appearance.colors[m3Key] = json[key]
            }
        }
    }


    function resetFilePathNextTime() {
        resetFilePathNextWallpaperChange.enabled = true
    }

    Timer {
        id: delayedFileRead
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            root.applyColors(themeFileView.text())
        }
    }

    FileView {
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        onFileChanged: {
            this.reload()
            delayedFileRead.start()
        }
        onLoadedChanged: {
            const fileContent = themeFileView.text()
            root.applyColors(fileContent)
        }
        onLoadFailed: root.resetFilePathNextTime();
    }

    // Wallpaper handling
    Process {
        id: swwwStart
        function run() {
            command = [
                "swww-daemon",
            ];
            running = true
        }
    }

    Process {
        id: swwwProc
        function run() {
            command = [
                "swww", "img", Config.options.appearance.wallpaper,
                "--transition-type", "grow",        // Options: grow, outer, any, wipe, wave, etc.
                "--transition-duration", "0.8",     // Seconds
                "--transition-fps", "240",
                //"--transition-pos", "0.5,0.5",    // Center of the screen
                "--transition-bezier", ".1,1,.1,1"
            ];
            running = true;
        }
    }

    Timer {
        id: startupTimer; interval: 300; running: true; repeat: false; onTriggered: {
            if (Config.options.appearance.wallpaper) {console.log("Chaos Shell: Config loaded. Generating theme..."); Theme.generate();}
            else {console.log("Chaos Shell: Config not ready, retrying..."); startupDelay.interval = 100; startupDelay.start();}
        }
    }
}
