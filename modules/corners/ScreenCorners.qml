import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.common
import qs.common.widgets

Variants {
    id: screenCorners
    model: Quickshell.screens

    delegate: Scope {
        id: monitorScope

        required property var modelData
        component CornerWindow: PanelWindow {
            id: win
            visible: Config.options.appearance.showScreenRounding
            property var cornerType: RoundCorner.CornerEnum.TopLeft

            screen: monitorScope.modelData
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell:screenCorners"
            color: "transparent"

            anchors {
                top: (cornerType === RoundCorner.CornerEnum.TopLeft || cornerType === RoundCorner.CornerEnum.TopRight)
                bottom: (cornerType === RoundCorner.CornerEnum.BottomLeft || cornerType === RoundCorner.CornerEnum.BottomRight)
                left: (cornerType === RoundCorner.CornerEnum.TopLeft || cornerType === RoundCorner.CornerEnum.BottomLeft)
                right: (cornerType === RoundCorner.CornerEnum.TopRight || cornerType === RoundCorner.CornerEnum.BottomRight)
            }

            RoundCorner {
                anchors.fill: parent
                corner: win.cornerType
                implicitSize: Appearance.rounding.screenRounding
                color: "black"
            }
        }

        CornerWindow { cornerType: RoundCorner.CornerEnum.TopLeft }
        CornerWindow { cornerType: RoundCorner.CornerEnum.TopRight }
        CornerWindow { cornerType: RoundCorner.CornerEnum.BottomLeft }
        CornerWindow { cornerType: RoundCorner.CornerEnum.BottomRight }
    }
}
