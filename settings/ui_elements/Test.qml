import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.settings

ApplicationWindow {
    id: settingsWindow
    width: 600
    height: 400
    visible: Config.generalStorage.showSettings
    color: "#121212"

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
            Switch {
                text: "Orientation (Top/Bottom)"
                checked: Config.generalStorage.isTop
                onToggled: Config.togglePossition()
            }
        }
    }

    Component {
        id: appearanceUI
        ColumnLayout {
            Label { text: "Opacity: " + (Config.appearanceStorage.opacity * 100).toFixed(0) + "%"; color: "white" }
            Slider {
                from: 0; to: 1
                value: Config.appearanceStorage.opacity
                onMoved: Config.appearanceStorage.opacity = value
            }
            TextField {
                placeholderText: "Theme"
                text: Config.appearanceStorage.theme
                onEditingFinished: Config.appearanceStorage.theme = text
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
