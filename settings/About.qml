import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets
import qs.services

ColumnLayout {
    id: root
    spacing: 15

    anchors.centerIn: parent

    RowLayout {
        Layout.alignment: Qt.AlignHCenter

        Rectangle {
            id: pictureContainer
            color: Appearance.colors.m3surfaceContainer
            height: 250
            width: 250
            radius: Appearance.rounding.large
            ColumnLayout{
                anchors.centerIn: parent
                Rectangle {width: 200; height: 50; color: Appearance.colors.m3primary; radius: Appearance.rounding.normal}
                Rectangle {width: 200; height: 50; color: Appearance.colors.m3secondary; radius: Appearance.rounding.normal}
                Rectangle {width: 200; height: 50; color: Appearance.colors.m3tertiary; radius: Appearance.rounding.normal}
                StyledText {text: "fancy image goes here"}
                StyledText {text: "eventually, probably"; opacity: 0.7}
            }
        }

        ColumnLayout {
            spacing: 8

            ColumnLayout {

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 100
                    Layout.preferredWidth: 250
                    color: Appearance.colors.m3surfaceContainer
                    radius: Appearance.rounding.large

                    ColumnLayout {

                        anchors.centerIn: parent

                        RowLayout {
                            StyledText {
                                id: title
                                text: "Chaos Shell"
                                font.pixelSize: Appearance.font.pixelSize.large + 2
                            }
                            StyledText {
                                text: "0.5"
                                opacity: 0.7
                                font.pixelSize: title.font.pixelSize
                            }
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: Appearance.font.pixelSize.small
                            text: "No light reaches me here."
                            opacity: 0.7
                        }
                    }
                }

                Rectangle {
                    id: fetchBackground

                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 150
                    Layout.preferredWidth: 250
                    color: Appearance.colors.m3surfaceContainer
                    radius: Appearance.rounding.large

                    ColumnLayout {
                        anchors.centerIn: parent
                        RowLayout {StyledText {text: "OS: "} StyledText {text: DeviceService.distroName; opacity: 0.7}}
                        RowLayout {StyledText {text: "Version: "} StyledText {text: DeviceService.kernelVersion; opacity: 0.7}}
                        RowLayout {StyledText {text: "User: "} StyledText {text: DeviceService.userName; opacity: 0.7}}
                        RowLayout {StyledText {text: "Host: "} StyledText {text: DeviceService.hostName; opacity: 0.7}}
                    }
                }
            }
        }
    }
}
