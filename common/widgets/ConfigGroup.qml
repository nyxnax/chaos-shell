import QtQuick
import QtQuick.Layouts
import qs.common

ColumnLayout {
    id: root

    property string title
    property string icon
    default property alias content: column.data

    Layout.fillWidth: true
    implicitHeight: column.implicitHeight


    ConfigRow {
        MaterialSymbol {
            text: root.icon
            visible: text !== ""
        }

        StyledText {
            text: root.title
            visible: text !== ""
        }
    }


    ColumnLayout {
        id: column
        spacing: 4

        Component.onCompleted: {
            let items = [];
            for (let i = 0; i < column.children.length; i++) {
                let child = column.children[i];
                if (child.hasOwnProperty("position")) { // Check if it's a ConfigSwitch (has the position property)
                    items.push(child);
                }
            }

            for (let i = 0; i < items.length; i++) {
                if (items.length === 1) items[i].position = 3;          // Only
                else if (i === 0) items[i].position = 1;                // Top
                else if (i === items.length - 1) items[i].position = 2; // Bottom
                else items[i].position = 0;                             // Mid
            }
        }
    }
}
