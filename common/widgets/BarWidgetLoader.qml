import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    required property var modelData
    required property var widgetScreen
    readonly property bool isVertical: bar.isVertical
    readonly property real barThickness: bar.barThickness

    implicitWidth: (loader.item && loader.item.visible) ? Math.round(loader.item.implicitWidth) : 0
    implicitHeight: (loader.item && loader.item.visible) ? Math.round(loader.item.implicitHeight) : 0

    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    visible: modelData !== ""

    function getImplicitSize(item, prop) {
        return (item && item.visible) ? Math.round(item[prop]) : 0
    }

    function loadWidget() {
        if (modelData === "") return;

        loader.setSource(Qt.resolvedUrl(`../../modules/bar/widgets/${modelData}.qml`), {
        });
    }

    Loader {
        id: loader
        anchors.fill: parent

        onLoaded: {
            if (!item) return;
        }
    }

    Component.onCompleted: loadWidget()
    onModelDataChanged: loadWidget()
}
