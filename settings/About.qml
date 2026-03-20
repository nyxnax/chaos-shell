import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.common
import qs.common.widgets

ColumnLayout {
    id: root
    spacing: 10

    anchors.centerIn: parent

    ConfigRow {
        Layout.alignment: Qt.AlignHCenter
        StyledText {
            id: title
            text: "Chaos Shell"
            font.pixelSize: Appearance.font.pixelSize.huge
        }
        StyledText {
            text: "v0.5"
            opacity: 0.6
            font.pixelSize: title.font.pixelSize
        }
    }
    StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "No light reaches me here."
        color: "white"
    }
}
