import QtQuick
import QtQuick.Layouts
import qs.common
import qs.common.widgets

ConfigTile {
    id: root

    property alias model: group.model
    property alias currentValue: group.currentValue
    property alias buttonSize: group.buttonSize

    signal choiceSelected(var value)

    control: StyledButtonGroup {
        id: group
        onChoiceSelected: (value) => root.choiceSelected(value)
    }
}
