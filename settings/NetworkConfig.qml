import QtQuick
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
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 600
            spacing: 24

            ConfigGroup {
                title: ""
                ConfigSwitch {
                    text: "Use Wi-Fi"
                    buttonIcon: "wifi"
                    checked: Network.wifi
                    onPressed: {
                        Network.toggleWifi()
                    }
                }
                ConfigTile {
                    buttonIcon: Network.materialSymbol
                    text: Network?.active?.ssid

                    control: MaterialSymbol {
                        //text: "arrow_downward"
                    }
                }


                ConfigGroup {
                    title: "Available Networks: "
                    shouldShow: Network.wifiEnabled

                    RowLayout {
                        StyledCallout {
                            visible: Network.wifiScanning
                            text: "Scanning..."
                        }
                        Item {Layout.fillWidth: true}
                        StyledButton {
                            buttonIcon: "sync"
                            text: "Scan Wi-Fi"
                            onPressed: {
                                Network.rescanWifi()
                            }
                        }
                    }

                    Repeater {
                        model: Network.friendlyWifiNetworks

                        delegate: ConfigTile {
                            visible: !modelData.active

                            buttonIcon: (modelData?.strength ?? 0) > 67 ? "wifi"
                                : (modelData?.strength ?? 0) > 33 ? "wifi_2_bar"
                                : "wifi_1_bar"
                            text: modelData.ssid

                            control: RowLayout {
                                MaterialSymbol {
                                    text: "lock"
                                }
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: supportingPane
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: false
            Layout.preferredWidth: 300
            spacing: 24

            ConfigGroup {
                id: info

                StyledCallout {
                    icon: "info"
                    text: "Network Info"
                }

                StyledCallout {
                    opacity: 0.8
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "lightbulb"
                        }
                        StyledText {
                            text: "SSID: " + Network.active?.ssid
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                        }
                    }
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "link"
                        }
                        StyledText {
                            text: "Wi-Fi Status: " + Network.wifiStatus
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                        }
                    }
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "download"
                            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3primary : Appearance.colors.m3outline
                            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                        }
                        StyledText {
                            text: "Download speed: " + Network.downloadSpeedText ?? "0 B/s"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            color: Network.downloadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
                            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                        }
                    }
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "upload"
                            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3secondary : Appearance.colors.m3outline
                            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                        }
                        StyledText {
                            text: "Upload Speed: " + Network.uploadSpeedText ?? "0 B/s"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                            color: Network.uploadSpeedBytes > 1 ? Appearance.colors.m3onSurface : Appearance.colors.m3outline
                            Behavior on color { animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this) }
                        }
                    }
                }
                StyledCallout {
                    opacity: 0.8
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "location_on"
                        }
                        StyledText {
                            text: "Local IPv4: PH"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                        }
                    }
                    RowLayout {
                        MaterialSymbol {
                            fill: 1
                            text: "location_on"
                        }
                        StyledText {
                            text: "Local IPv6: PH"
                            Layout.fillWidth: true
                            Layout.preferredWidth: 0
                        }
                    }
                }
                StyledCallout {
                    icon: "info"
                    text: "Note"
                }
                StyledCallout {
                    text: "This page is very much still WIP, I'll be adding missing stuff and functions over time <3"
                    opacity: 0.8
                }
            }
        }
    }
}
