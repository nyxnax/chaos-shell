import QtQuick
import QtQuick.Controls

TabButton {
    id: root

    PointingHand {}

    font {
        weight: ((root.checked)) ? 1000 : 400
        pixelSize: ((root.checled)) ? 22 : 20
        capitalization: Font.Capitalize
    }

    background: Rectangle {
        color: "#00000000"
    }
}
