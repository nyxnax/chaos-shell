import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.common
import qs.common.widgets

ApplicationWindow {
    id: root
    minimumWidth: 600
    minimumHeight: 600
    visible: Global.states.settingsOpen
    color: "black"

    property var pages: [
        {
            name: "Appearance",
            icon: "yes",
            iconRotation: 180,
            component: "AppearanceConfig.qml"
        },
        {
            name: "Bar",
            icon: "bar",
            iconRotation: 180,
            component: "BarConfig.qml"
        }
    ]
    property int currentPage: 0

    Process {
        id: matugenProcess
        running: false
        // Call the interpreter, then the absolute path to your script
        command: ["bash", Quickshell.shellPath("./scripts/wall.sh")]

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

        Keys.onPressed: (event) => {
            if (event.modifiers === Qt.ControlModifier) {
                if (event.key === Qt.Key_PageDown) {
                    root.currentPage = Math.min(root.currentPage + 1, root.pages.length - 1)
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_PageUp) {
                    root.currentPage = Math.max(root.currentPage - 1, 0)
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Tab) {
                    root.currentPage = (root.currentPage + 1) % root.pages.length;
                    event.accepted = true;
                }
                else if (event.key === Qt.Key_Backtab) {
                    root.currentPage = (root.currentPage - 1 + root.pages.length) % root.pages.length;
                    event.accepted = true;
                }
            }
        }

        TabBar {
            id: bar
            currentIndex: root.currentPage
            Layout.fillWidth: true
            Repeater {
                model: root.pages
                StyledTabButton { text: modelData.name }
            }
        }

        StackLayout {
            currentIndex: bar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: root.pages
                delegate: ScrollView {
                    ColumnLayout {
                        width: parent.width
                        spacing: 20

                        Label {
                            text: modelData.name
                            font.pixelSize: 42
                            font.capitalization: Font.Capitalize
                            color: "white"
                        }

                        Loader {
                            Layout.fillWidth: true
                            source: modelData.component
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
                    text: "Chaos Shell Alpha 0.3"
                    color: "#AAAAAA"
                    font.pixelSize: 14
                }

                Item { Layout.fillWidth: true }

                StyledButton {
                    text: "Close"
                    onClicked: Global.states.settingsOpen = false
                }
            }
        }
    }
}
