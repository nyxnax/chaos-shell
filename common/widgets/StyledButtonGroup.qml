import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

GridLayout {
    id: root

    property var model: []
    property var currentValue
    property int buttonSize: StyledButton.Size.M
    readonly property real colWidth: width / columns
    property bool collapsed: colWidth < 100
    signal choiceSelected(var value)

    columns: 4
    columnSpacing: 2
    rowSpacing: 2

    Repeater {
        model: root.model
        delegate: StyledButton {
            id: buttonDelegate
            size: root.buttonSize
            text: collapsed ? "" : modelData.name
            Layout.fillWidth: true
            buttonIcon: modelData.icon

            Behavior on width {
                animation: Appearance.animation.clickBounce.numberAnimation.createObject(this)
            }

            Behavior on text {
                SequentialAnimation {
                    NumberAnimation { target: buttonDelegate; property: "opacity"; from: 1.0; to: 0.5; duration: 50 }
                    PropertyAction { target: buttonDelegate; property: "text" }
                    NumberAnimation { target: buttonDelegate; property: "opacity"; from: 0.5; to: 1.0; duration: 50 }
                }
            }

            position: {
                if (isSelected || hovered || root.model.length === 1) return 3;
                if (index === 0) return 1;
                if (index === root.model.length - 1) return 2;
                return 0;
            }

            isSelected: root.currentValue === modelData.value
            onClicked: root.choiceSelected(modelData.value)

            StyledToolTip {
                shown: parent.hovered && collapsed && text !== ""
                text: modelData.name
            }
        }
    }
}
