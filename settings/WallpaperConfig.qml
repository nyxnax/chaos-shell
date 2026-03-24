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

    RowLayout {
        Rectangle { // Current Wallpaper
            id: wallpaperPreview
            Layout.fillWidth: true
            Layout.maximumWidth: 800
            Layout.minimumWidth: 300
            implicitHeight: width * (9 / 18.5)
            radius: 12
            color: Appearance.colors.m3surfaceContainer

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: wallpaperPreview.width
                    height: wallpaperPreview.height
                    radius: wallpaperPreview.radius
                }
            }

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
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Appearance.colors.m3scrim
                border.width: 5
                radius: parent.radius
                z: 1
            }
        }

        ColumnLayout { // Mode switcher
            id: modeSwitcher
            spacing: 5
            Layout.fillWidth: true

            StyledButton { // Light Mode
                Layout.fillHeight: true
                Layout.fillWidth: true
                buttonColor: "white"
                border: Config.options.appearance.light ? 2 : 0

                contentItem: Item {
                    ColumnLayout{
                        anchors.centerIn: parent
                        RowLayout {Layout.alignment: Qt.AlignHCenter; MaterialSymbol {text: "brightness_7"; color: "black"; font.pixelSize: Appearance.font.pixelSize.larger} StyledText{text: "Light"; color: "black"; font.pixelSize: Appearance.font.pixelSize.larger}}
                        Row {
                            spacing: 5;Layout.alignment: Qt.AlignHCenter;
                            Rectangle {color: Appearance.colors.m3primary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                            Rectangle {color: Appearance.colors.m3secondary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                            Rectangle {color: Appearance.colors.m3tertiary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                        }
                    }
                }
                onClicked: {
                    Config.options.appearance.light = true
                    Theme.generate()
                }
            }
            StyledButton { // Dark Mode
                Layout.fillHeight: true
                Layout.fillWidth: true
                buttonColor: "black"
                border: !Config.options.appearance.light ? 2 : 0

                contentItem: Item {
                    ColumnLayout{
                        anchors.centerIn: parent
                            RowLayout {Layout.alignment: Qt.AlignHCenter; MaterialSymbol {text: "moon_stars"; color: "white"; font.pixelSize: Appearance.font.pixelSize.larger} StyledText{text: "Dark"; color: "white"; font.pixelSize: Appearance.font.pixelSize.larger}}
                        Row {spacing: 5;Layout.alignment: Qt.AlignHCenter;
                            Rectangle {color: Appearance.colors.m3primary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                            Rectangle {color: Appearance.colors.m3secondary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                            Rectangle {color: Appearance.colors.m3tertiary; implicitHeight: 30 ;implicitWidth: 30; radius: 15}
                        }
                    }
                }
                onClicked: {
                    Config.options.appearance.light = false
                    Theme.generate()
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

    ConfigGroup{
        icon: "colors"
        title: "Color Scheme"
        Flow {
            id: schemeFlow
            width: parent.width
            spacing: 8
            padding: 10
            Layout.fillWidth: true

            Repeater {
                model: [
                    { name: "Tonal Spot (Default)", value: "scheme-tonal-spot",  icon: "palette" },
                    { name: "Content",              value: "scheme-content",     icon: "filter_center_focus" },
                    { name: "Expressive",           value: "scheme-expressive",  icon: "auto_awesome" },
                    { name: "Fidelity",             value: "scheme-fidelity",    icon: "high_quality" },
                    { name: "Fruit Salad",          value: "scheme-fruit-salad", icon: "nutrition" },
                    { name: "Monochrome",           value: "scheme-monochrome",  icon: "lens_blur" },
                    { name: "Neutral",              value: "scheme-neutral",     icon: "contrast" },
                    { name: "Rainbow",              value: "scheme-rainbow",     icon: "looks" }
                ]

                delegate: Button {
                    id: themeChip

                    implicitWidth: 60
                    implicitHeight: 60

                    property bool isSelected: Config.options.appearance.scheme === modelData.value

                    background: Rectangle {
                        color: themeChip.isSelected ? Appearance.colors.m3primaryContainer : Appearance.colors.m3surfaceVariant
                        radius: themeChip.implicitHeight / 2
                        border.width: themeChip.hovered ? 2 : 0
                        border.color: Appearance.colors.m3primary
                    }

                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: modelData.icon
                        iconSize: 30
                        color: themeChip.isSelected ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurfaceVariant
                    }

                    StyledToolTip {
                        text: modelData.name
                    }

                    onClicked: {
                        Config.options.appearance.scheme = modelData.value
                        Theme.generate()
                    }
                }
            }
        }
    }
}
