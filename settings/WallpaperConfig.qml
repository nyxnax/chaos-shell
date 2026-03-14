import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    spacing: 20

    Rectangle { // Current Wallpaper
        id: wallpaperPreview
        width: 320
        height: 180
        radius: 12
        color: Appearance.colors.m3surfaceContainer
        clip: true

        Image {
            id: previewImage
            anchors.fill: parent
            source: Config.options.appearance.wallpaper ? "file://" + Config.options.appearance.wallpaper : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true

            opacity: status === Image.Ready ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: wallpaperPreview.width
                    height: wallpaperPreview.height
                    radius: 12 // Same as parent
                }
            }
        }
    }

    ListModel { id: wallpaperModel }

    Process {
        id: wallpaperScanner
        command: ["ls", "-1", "-p", Quickshell.env("HOME") + "/Pictures/Wallpapers"]
        running: true // Run on startup

        stdout: StdioCollector {
            onStreamFinished: {
                wallpaperModel.clear();
                let lines = text.split("\n");

                lines.forEach(line => {
                    if (line && !line.endsWith("/") && line.match(/\.(jpg|jpeg|png|webp)$/i)) {
                        wallpaperModel.append({
                            "name": line,
                            "path": Quickshell.env("HOME") + "/Pictures/Wallpapers/" + line
                        });
                    }
                });
            }
        }
    }

    StyledText {
        text: "Select Wallpaper"
        font.pixelSize: 18
    }

    ScrollView { // Wallpaper Selector
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        padding: 20
        background: Rectangle {
            color: Appearance.colors.m3secondaryContainer
            radius: 12
        }

        GridView {
            id: grid
            width: parent.width
            height: contentHeight
            cellWidth: width / 5
            cellHeight: 180
            model: wallpaperModel

            delegate: Item {
                width: grid.cellWidth
                height: grid.cellHeight

                Rectangle {
                    id: frame
                    anchors.fill: parent
                    anchors.margins: 5
                    radius: 12
                    color: "transparent"
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: model.path
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: frame.width
                                height: frame.height
                                radius: 12 // Same as parent
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Config.options.appearance.wallpaper = model.path;
                            Theme.generate(model.path, Config.options.appearance.light);
                        }
                        PointingHand{}
                    }
                }
            }
        }
    }
}
