import QtQuick
import QtQuick.Layouts
import qs.common

ColumnLayout {
    id: root

    property string title
    property string icon
    property bool shouldShow: true
    default property alias content: column.data

    Layout.fillWidth: true
    implicitHeight: column.implicitHeight
    visible: opacity > 0

    states: [
        State {
            name: "visible"
            when: root.shouldShow
            PropertyChanges { target: root; opacity: 1.0 }
            PropertyChanges { target: root; Layout.preferredHeight: root.implicitHeight }
        },
        State {
            name: "hidden"
            when: !root.shouldShow
            PropertyChanges { target: root; opacity: 0.0 }
            PropertyChanges { target: root; Layout.preferredHeight: 0 }
        }
    ]

    transitions: [
        Transition {
            from: "hidden"; to: "visible"

            NumberAnimation {
                properties: "Layout.preferredHeight"
                duration: Appearance.animation.elementResize.duration
                easing.type: Appearance.animation.elementResize.type
                easing.bezierCurve: Appearance.animation.elementResize.bezierCurve
            }

            NumberAnimation {
                properties: "opacity"
                duration: Appearance.animation.elementMoveEnter.duration
                easing.type: Appearance.animation.elementMoveEnter.type
                easing.bezierCurve: Appearance.animation.elementMoveEnter.bezierCurve
            }
        },
        Transition {
            from: "visible"; to: "hidden"

            NumberAnimation {
                properties: "Layout.preferredHeight"
                duration: Appearance.animation.elementResize.duration
                easing.type: Appearance.animation.elementResize.type
                easing.bezierCurve: Appearance.animation.elementResize.bezierCurve
            }
            NumberAnimation {
                properties: "opacity"
                duration: Appearance.animation.elementMoveExit.duration
                easing.type: Appearance.animation.elementMoveExit.type
                easing.bezierCurve: Appearance.animation.elementMoveExit.bezierCurve
            }
        }
    ]

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

        function updatePositions() {
            let items = [];
            for (let i = 0; i < column.children.length; i++) {
                let child = column.children[i];
                if (child.hasOwnProperty("position") && child.visible) {
                    items.push(child);
                }
            }

            for (let i = 0; i < items.length; i++) {
                if (items.length === 1) items[i].position = 3;          // Single
                else if (i === 0) items[i].position = 1;                // Top
                else if (i === items.length - 1) items[i].position = 2; // Bottom
                else items[i].position = 0;                             // Mid
            }
        }

        Timer {
            id: debounceTimer
            interval: 1
            onTriggered: column.updatePositions()
        }

        onChildrenChanged: {
            for (let i = 0; i < column.children.length; i++) {
                let child = column.children[i];
                if (child.hasOwnProperty("position")) {
                    child.visibleChanged.connect(updatePositions);
                }
            }
            debounceTimer.restart()
        }

        Component.onCompleted: debounceTimer.restart()
    }
}
