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
            Layout.maximumWidth: 700
            Layout.minimumWidth: 100
            implicitHeight: width * (9 / 18.5)
            radius: Appearance.rounding.large
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

                sourceSize.width: 800
                sourceSize.height: 450

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
            }
        }

        ColumnLayout { // Mode switcher
            id: modeSwitcher
            spacing: 5

            StyledButton { // Light Mode
                Layout.fillHeight: true
                Layout.fillWidth: true
                buttonColor: "white"
                border: Config.options.appearance.light ? 5 : 0
                radius: Appearance.rounding.large

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
                border: !Config.options.appearance.light ? 5 : 0
                radius: Appearance.rounding.large

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
            snapMode: ListView.SnapToItem
            boundsBehavior: Flickable.StopAtBounds
            preferredHighlightBegin: 20
            preferredHighlightEnd: parent.width - 20
            anchors.margins: 12
            clip: true
            cacheBuffer: 100
            reuseItems: true

            delegate: Item {
                id: wallpapers
                readonly property bool isSelected: Config.options.appearance.wallpaper === model.path

                width: isSelected ? 320 : 140
                height: carouselContainer.height - carouselContainer.radius
                Behavior on width {animation: Appearance.animation.elementMove.numberAnimation.createObject(root)}

                Item { // Frame / Background
                    id: wallpaperFrame
                    anchors.fill: parent
                    anchors.margins: 6
                    width: parent.width
                    height: parent.height

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: wallpaperFrame.width
                            height: wallpaperFrame.height
                            radius: Appearance.rounding.small
                        }
                    }

                    Image { // Image
                        id: wallpapersImage
                        anchors.fill: parent
                        source: model.path
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        sourceSize.width: 320
                        sourceSize.height: 180
                        smooth: true
                        cache: true
                    }

                    Desaturate { // Desaturation
                        anchors.fill: parent
                        source: wallpapersImage
                        desaturation: wallpapers.isSelected ? 0.0 : 0.7
                        Behavior on desaturation {NumberAnimation {duration: 500}}
                    }

                    Rectangle { // Darkening
                        anchors.fill: parent
                        color: "black"
                        opacity: wallpapers.isSelected ? 0 : 0.1
                        Behavior on opacity {NumberAnimation {duration: 500}}
                    }

                    Rectangle { // Border
                        anchors.fill: wallpaperFrame
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

                delegate: StyledButton {

                    id: themeChip
                    size: StyledButton.Size.L
                    text: modelData.name
                    property bool isSelected: Config.options.appearance.scheme === modelData.value
                    buttonIcon: modelData.icon
                    buttonColor: isSelected ? Appearance.colors.m3primaryContainer
                            : Appearance.colors.m3secondaryContainer
                    border: isSelected ? 2 : 0

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
    ConfigGroup {
        icon: "settings"
        title: "Preferences"
        ConfigSlider {
            text: "Transition duration"
            buttonIcon: "transition_fade"
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
            buttonIcon: "blur_linear"
            //description: ""
            //liveUpdate: false
            defaultValue: 120
            valueSuffix: "fps"
            from: 20; to: 240; stepSize: 10
            value: Config.options.appearance.transitionFPS
            onMoved: (newValue) => {Config.options.appearance.transitionFPS = newValue;}
        }
    }
    ConfigGroup {
        icon: "transition_chop"
        title: "Transiton Types"

        Flow {
            id: transitionTypes
            width: parent.width
            spacing: 5
            padding: 10
            Layout.fillWidth: true

            Repeater {
                model: [
                    { name: "Any",    value: "any",     icon: "shuffle" },
                    { name: "Grow",   value: "grow",    icon: "arrows_outward" },
                    { name: "Outer",  value: "outer",   icon: "filter_center_focus" },
                    { name: "Wipe",   value: "wipe",    icon: "south_west" },
                    { name: "Wave",   value: "wave",    icon: "waves" },
                    { name: "Center", value: "center",  icon: "align_center" },
                ]

                delegate: StyledButton {

                    id: transitionChip
                    size: StyledButton.Size.L
                    text: modelData.name
                    property bool isSelected: Config.options.appearance.transitionType === modelData.value
                    buttonIcon: modelData.icon
                    buttonColor: isSelected ? Appearance.colors.m3primaryContainer
                            : Appearance.colors.m3secondaryContainer
                    border: isSelected ? 2 : 0

                    StyledToolTip {
                        text: modelData.name
                    }

                    onClicked: {
                        Config.options.appearance.transitionType = modelData.value
                    }
                }
            }
        }
    }
}
