import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

ConfigTile {
    id: root

    property alias model: group.model
    property alias currentValue: group.currentValue
    property alias buttonSize: group.buttonSize
    property alias fullWidth: group.fullWidth
    property int style: StyledButton.Style.Filled

    signal choiceSelected(var value)

    control: StyledButtonGroup {
        id: group
        style: root.style
        onChoiceSelected: (value) => root.choiceSelected(value)
    }
}
