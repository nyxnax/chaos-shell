import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.settings
import qs.common.widgets

ApplicationWindow {
    id: settingsWindow
    minimumWidth: 600
    minimumHeight: 600
    visible: Config.generalStorage.showSettings
    color: "black"

    Process {
        id: matugenProcess
        running: false
        // Call the interpreter, then the absolute path to your script
        command: ["bash", "./wallpaper_matugen_runner.sh"]

        onStdoutChanged: console.log("Script Out: " + stdout)
        onStderrChanged: console.warn("Script Error: " + stderr)

        onExited: (exitCode) => {
            console.log("Script finished with code: " + exitCode);
            matugenProcess.running = false;
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        TabBar {
            id: bar
            Layout.fillWidth: true
            Repeater {
                model: Config.categories
                TabButton { text: modelData.category }
            }
        }

        StackLayout {
            currentIndex: bar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: Config.categories
                delegate: ScrollView {
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Label {
                            text: modelData.category
                            font.pixelSize: 22
                            color: "white"
                        }

                        // Use a Loader to decide what UI to show
                        Loader {
                            Layout.fillWidth: true
                            sourceComponent: {
                                // Match the category name to a specific UI block
                                if (modelData.category === "generic") return genericUI;
                                if (modelData.category === "Appearance") return appearanceUI;
                                if (modelData.category === "test") return testUI;
                                return null;
                            }
                        }
                    }
                }
            }
        }
    }

    // --- UI Component Definitions ---
    // These define the actual controls for each section

    Component {
        id: genericUI
        ColumnLayout {
            Row {
                StyledSwitch {
                    text: "Orientation (Top/Bottom)"
                    checked: Config.generalStorage.isTop
                    onToggled: Config.togglePossition()
                }
                Text {
                    text: "Orientation (Top/Bottom)"
                    color: "white"
                    font.pixelSize: 18
                }
            }
        }
    }

    Component {
        id: appearanceUI
        ColumnLayout {
            spacing: 20

            Label { text: "Opacity: " + (Config.appearanceStorage.opacity * 100).toFixed(0) + "%"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 1
                value: Config.appearanceStorage.opacity
                onMoved: Config.appearanceStorage.opacity = value
            }

            TextField {
                Layout.fillWidth: true
                placeholderText: "Theme"
                text: Config.appearanceStorage.theme
                onEditingFinished: Config.appearanceStorage.theme = text
            }

            // --- New Matugen Button ---
            Button {
                text: matugenProcess.running ? "Generating..." : "Regenerate Theme from Wallpaper"
                enabled: !matugenProcess.running
                Layout.fillWidth: true

                onClicked: {
                    console.log("Starting Matugen...");
                    matugenProcess.running = true;
                }
            }
        }
    }

    Component {
        id: testUI
        ColumnLayout {
            Label { text: "Secret Phrase:"; color: "white" }
            TextField {
                text: Config.testStorage.easteregg
                onEditingFinished: Config.testStorage.easteregg = text
            }
        }
    }




}
