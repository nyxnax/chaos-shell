import QtQuick
import QtQuick.Layouts
import qs.common

RowLayout {
    id: root
    default property alias content: infoLayout.data
    property color accentColor: Appearance.colors.m3secondary
    property string icon: ""
    property string text: ""

    spacing: 10
    uniformCellSizes: false

    Rectangle {
        color: root.accentColor
        Layout.fillHeight: true
        Layout.preferredWidth: 8
        radius: Appearance.rounding.normal
    }

    ColumnLayout {
        id:infoLayout
        Layout.fillWidth: true
        spacing: 0

        RowLayout {
            MaterialSymbol {
                fill: 1
                text: root.icon
                visible: root.icon !== ""
            }
            StyledText {
                text: root.text
                visible: root.text !== ""
            }
        }
    }
}
