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
        command: ["bash", Quickshell.configPath("./scripts/wall.sh")]

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
                StyledTabButton { text: modelData.category }
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
                            font.pixelSize: 42
                            font.capitalization: Font.Capitalize
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

        Rectangle {
            id: footer
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: "transparent"

            Rectangle {
                width: parent.width
                height: 1
                color: "#222222"
                anchors.top: parent.top
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Label {
                    text: "Chaos Shell Alpha 0.2"
                    color: "#AAAAAA"
                    font.pixelSize: 14
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "Close"
                    onClicked: Config.generalStorage.showSettings = false
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
                spacing: 10
                StyledSwitch {
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

            Column {
                Label {
                    text: "Background Opacity" ; color: "white"
                    font.pixelSize: 18
                }
                RowLayout {
                    spacing: 10
                    Slider {
                        Layout.fillWidth: true
                        from: 0; to: 1
                        value: Config.appearanceStorage.opacity
                        onMoved: Config.appearanceStorage.opacity = value
                    }
                    Label {
                        text: (Config.appearanceStorage.opacity * 100).toFixed(0) + "%"
                        font.pixelSize: 16
                    }
                }
            }
            Row {
                spacing: 10
                StyledSwitch {
                    checked: Config.generalStorage.isTop
                    onToggled: Config.toggleLight()
                }
                Text {
                    text: "Light mode"
                    color: "white"
                    font.pixelSize: 18
                }
            }

            // --- New Matugen Button ---
            Button {
                text: matugenProcess.running ? "Generating..." : "Refresh theme"
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
