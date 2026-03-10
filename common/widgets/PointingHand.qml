import QtQuick

// Pointing hand cursor

MouseArea {
    anchors.fill: parent
    onPressed: (mouse) => mouse.accepted = false
    cursorShape: Qt.PointingHandCursor
}
