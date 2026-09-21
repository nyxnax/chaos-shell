import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

Item {
    id: root
    property var model: []
    property var currentValue
    property int buttonSize: StyledButton.Size.M
    property bool collapsed: root.width < 400
    signal choiceSelected(var value)
    property int style: StyledButton.Style.Filled

    Layout.fillWidth: true
    implicitHeight: flowLayout.implicitHeight

    Flow {
        id: flowLayout

        populate: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }
        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: Appearance.animation.elementMoveFast.duration
                easing.type: Appearance.animation.elementMoveFast.type
                easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
            }
        }

        width: root.width
        Layout.maximumWidth: parent.width
        spacing: 2

        Repeater {
            model: root.model
            delegate: StyledButton {
                id: buttonDelegate
                size: root.buttonSize
                text: collapsed ? "" : modelData.name
                buttonIcon: modelData.icon
                style: root.style

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

                isSelected: root.currentValue === (modelData.value !== undefined ? modelData.value : index)
                onClicked: root.choiceSelected(modelData.value !== undefined ? modelData.value : index)

                StyledToolTip {
                    shown: parent.hovered && collapsed && text !== ""
                    text: modelData.name
                }
            }
        }
    }
}
