import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services
import qs.common
import qs.common.widgets

ColumnLayout {
    id: pageRoot
    spacing: 24

    GridLayout {
        columns: root.isCompact || root.isMedium || root.isExpanded ? 1 : 2
        columnSpacing: 40
        rowSpacing: 20

        ColumnLayout {
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredWidth: 600
            spacing: 24

            RowLayout {
                spacing: 8
                Rectangle { // Current Wallpaper
                    id: wallpaperPreview
                    Layout.fillWidth: true
                    Layout.minimumWidth: 100
                    implicitHeight: root.isCompact ? 700
                                : isMedium ? width * (4 / 3)
                                : isExpanded ? width * (9 / 16)
                                : isLarge ? width * (9 / 16)
                                : isExtraLarge ? width * (9 / 21)
                                : width * (4 / 3)
                    radius: Appearance.rounding.large
                    color: Appearance.colors.m3surfaceContainer

                    Behavior on implicitHeight { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

                    Rectangle {
                        id: wallpaperMaskFrame
                        anchors.fill: parent
                        radius: Appearance.rounding.large
                        visible: false
                        layer.enabled: true
                    }

                    MultiEffect {
                        anchors.fill: wallpaperPreview
                        source: previewImage
                        maskEnabled: true
                        maskSource: wallpaperMaskFrame

                        opacity: previewImage.status === Image.Ready ? 1.0 : 0.0

                        Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                    }

                    Image {
                        id: previewImage
                        anchors.fill: parent
                        source: Config.options.appearance.wallpaper ? "file://" + Config.options.appearance.wallpaper : ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: false
                        sourceSize.width: 800
                        sourceSize.height: 700
                        visible: false
                    }
                }

                Rectangle { // Primary container color preview
                    id: colorPreview
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumWidth: 80
                    Layout.maximumWidth: 80
                    color: Appearance.colors.m3primaryContainer
                    radius: Appearance.rounding.large
                }
                Rectangle { // Secondary color preview
                    id: colorPreviewTwo
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumWidth: 40
                    Layout.maximumWidth: 40
                    color: Appearance.colors.m3secondaryContainer
                    radius: Appearance.rounding.large
                }
            }

            ListModel { id: wallpaperModel }

            Process {
                id: wallpaperScanner
                command: ["find", Directories.wallpapers, "-type", "f"]
                running: true

                stdout: StdioCollector {
                    onStreamFinished: {
                        if (!text || text.trim().length === 0) return;
                        wallpaperModel.clear();
                        let lines = text.trim().split("\n");

                        lines.forEach(line => {

                            if (line.match(/\.(jpg|jpeg|png|webp|gif)$/i)) {
                                let fileName = line.substring(line.lastIndexOf('/') + 1);

                                wallpaperModel.append({
                                    "name": fileName,
                                    "path": line
                                });
                            }
                        });
                        console.info(`Chaos: Loaded ${wallpaperModel.count} wallpapers from ${Directories.wallpapers}`);
                    }
                }
            }

            Rectangle { // Wallpaper Selector
                id: carouselContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                height: 225
                color: Appearance.colors.m3secondaryContainer
                radius: Appearance.rounding.large

                ListView {
                    id: carousel
                    anchors.fill: parent
                    orientation: ListView.Horizontal
                    model: wallpaperModel
                    snapMode: ListView.NoSnap
                    boundsBehavior: Flickable.StopAtBounds
                    preferredHighlightBegin: 20
                    preferredHighlightEnd: parent.width - 20
                    anchors.margins: 12
                    clip: true
                    cacheBuffer: 100
                    reuseItems: true

                    highlightMoveDuration: 50
                    currentIndex: {
                        for (var i = 0; i < count; i++) {
                            if (model.get(i).path === Config.options.appearance.wallpaper) return i;
                        }
                        return 0;
                    }

                    delegate: Item {
                        id: wallpapers
                        width: targetWidth
                        height: carouselContainer.height - carouselContainer.radius

                        readonly property bool isSelected: Config.options.appearance.wallpaper === model.path
                        readonly property int indexDistance: Math.abs(index - carousel.currentIndex)

                        property real targetWidth: {
                            if (isSelected) return 320;
                            if (indexDistance === 1) return 160;
                            if (indexDistance === 2) return 120;
                            return 100;
                        }

                        Behavior on targetWidth {
                            enabled: wallpapers.Component.completed
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                        }

                        Item { // Frame / Background
                            id: wallpaperFrame
                            anchors.fill: parent
                            anchors.margins: 6

                            Rectangle {
                                id: wallpapersMaskFrame
                                anchors.fill: parent
                                radius: Appearance.rounding.small
                                visible: false
                                layer.enabled: true
                            }

                            Image { // Image
                                id: wallpapersImage
                                anchors.fill: parent
                                source: model.path
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                sourceSize: Qt.size(320, 180)
                                cache: true
                                visible: false
                            }

                            MultiEffect {
                                anchors.fill: wallpapersImage
                                source: wallpapersImage

                                maskEnabled: true
                                maskSource: wallpapersMaskFrame
                                maskThresholdMin: 0.5
                                maskSpreadAtMin: 1.0

                                opacity: wallpapersImage.status === Image.Ready ? 1.0 : 0.0
                                brightness: wallpapers.isSelected ? 0.0 : -0.02
                                saturation: wallpapers.isSelected ? 0.0 : -0.70

                                Behavior on brightness { NumberAnimation { duration: 500 } }
                                Behavior on saturation { NumberAnimation { duration: 300 } }
                                Behavior on opacity { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                            }

                            Rectangle { // Border
                                anchors.fill: parent
                                color: "transparent"
                                border.color: Appearance.colors.m3primary
                                border.width: wallpapers.isSelected ? 3 : 0
                                radius: Appearance.rounding.small
                                Behavior on border.width { NumberAnimation { duration: 200 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    Config.options.appearance.wallpaper = model.path;
                                    Theme.generate(model.path, Config.options.appearance.light);
                                    carousel.currentIndex = index;
                                }
                                PointingHand{}
                            }
                        }
                    }
                }
            }

            ConfigGroup{
                id: scheme

                readonly property var schemeModel: [
                    { name: "Tonal Spot",   value: "scheme-tonal-spot",  icon: "palette" },
                    { name: "Content",      value: "scheme-content",     icon: "filter_center_focus" },
                    { name: "Expressive",   value: "scheme-expressive",  icon: "auto_awesome" },
                    { name: "Fidelity",     value: "scheme-fidelity",    icon: "high_quality" },
                    { name: "Fruit Salad",  value: "scheme-fruit-salad", icon: "nutrition" },
                    { name: "Monochrome",   value: "scheme-monochrome",  icon: "lens_blur" },
                    { name: "Neutral",      value: "scheme-neutral",     icon: "contrast" },
                    { name: "Rainbow",      value: "scheme-rainbow",     icon: "looks" }
                ]

                ConfigButtonFlow {
                    text: "Material colour scheme"
                    buttonIcon: "palette"
                    model: scheme.schemeModel
                    currentValue: Config.options.appearance.scheme
                    onChoiceSelected: (value) => {
                        Config.options.appearance.scheme = value;
                        Theme.generate();
                    }
                }

                ConfigSwitch {
                    buttonIcon: "moon_stars"
                    text: "Dark theme"
                    //description: ""
                    checked: !Config.options.appearance.light
                    onCheckedChanged: {
                        Config.options.appearance.light = !checked;
                    }
                }
            }
        }

        ColumnLayout {
            id: supportingPane
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: false
            spacing: 24

            ConfigGroup {
                id: transition

                readonly property var transitionTypeModel: [
                    { name: "Any",    value: "any",     icon: "shuffle" },
                    { name: "Grow",   value: "grow",    icon: "arrows_outward" },
                    { name: "Outer",  value: "outer",   icon: "filter_center_focus" },
                    { name: "Wipe",   value: "wipe",    icon: "south_west" },
                    { name: "Wave",   value: "wave",    icon: "waves" },
                    { name: "Center", value: "center",  icon: "align_center" },
                ]

                ConfigSlider {
                    text: "Transition duration"
                    buttonIcon: "timer"
                    //description: "Control how long it takes to switch the wallpaper"
                    //liveUpdate: false
                    defaultValue: 1
                    valueSuffix: "s"
                    from: 0; to: 10; stepSize: 1
                    value: Config.options.appearance.transitionDuration
                    onMoved: (newValue) => {Config.options.appearance.transitionDuration = newValue;}
                }

                ConfigSlider {
                    text: "Transition framerate"
                    buttonIcon: "shutter_speed"
                    //description: ""
                    //liveUpdate: false
                    defaultValue: 120
                    valueSuffix: "fps"
                    from: 30; to: 240; stepSize: 30
                    value: Config.options.appearance.transitionFPS
                    onMoved: (newValue) => {Config.options.appearance.transitionFPS = newValue;}
                }

                ConfigButtonFlow {
                    text: "Transition type"
                    buttonIcon: "transition_chop"
                    model: transition.transitionTypeModel
                    currentValue: Config.options.appearance.transitionType
                    onChoiceSelected: (value) => Config.options.appearance.transitionType = value
                }
            }
        }
    }
}
