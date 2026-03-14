import Quickshell
import QtQuick
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    property QtObject colors
    property QtObject font
    property QtObject animationCurves
    property QtObject animation

    colors: QtObject {
        // Primary
        property color m3primary: "#cd2a6c"
        property color m3onPrimary: "#ffffff"
        property color m3primaryContainer: "#ffd8e8"
        property color m3onPrimaryContainer: "#3d0023"
        property color m3primaryFixed: "#ffd8e8"
        property color m3primaryFixedDim: "#fdb0d4"
        property color m3onPrimaryFixed: "#3d0023"
        property color m3onPrimaryFixedVariant: "#884b6a"
        // Secondary
        property color m3secondary: "#725763"
        property color m3onSecondary: "#ffffff"
        property color m3secondaryContainer: "#fdd9e7"
        property color m3onSecondaryContainer: "#29151f"
        property color m3secondaryFixed: "#fdd9e7"
        property color m3secondaryFixedDim: "#e0bdcb"
        property color m3onSecondaryFixed: "#29151f"
        property color m3onSecondaryFixedVariant: "#59404b"
        // Tertiary
        property color m3tertiary: "#7f553a"
        property color m3onTertiary: "#ffffff"
        property color m3tertiaryContainer: "#ffdbc8"
        property color m3onTertiaryContainer: "#301401"
        property color m3tertiaryFixed: "#ffdbc8"
        property color m3tertiaryFixedDim: "#f2bb9a"
        property color m3onTertiaryFixed: "#301401"
        property color m3onTertiaryFixedVariant: "#643e25"
        // Error
        property color m3error: "#ba1a1a"
        property color m3onError: "#ffffff"
        property color m3errorContainer: "#ffdad6"
        property color m3onErrorContainer: "#410002"
        // Background & Surface
        property color m3background: "#000000"
        property color m3onBackground: "#21191d"
        property color m3surface: "#fff8f8"
        property color m3onSurface: "#21191d"
        property color m3surfaceVariant: "#f1dee4"
        property color m3onSurfaceVariant: "#504348"
        property color m3surfaceTint: "#cd2a6c"
        // Surface Containers
        property color m3surfaceDim: "#e5d6db"
        property color m3surfaceBright: "#fff8f8"
        property color m3surfaceContainerLowest: "#ffffff"
        property color m3surfaceContainerLow: "#fff0f4"
        property color m3surfaceContainer: "#f9eaee"
        property color m3surfaceContainerHigh: "#f4e4e9"
        property color m3surfaceContainerHighest: "#eedfe3"
        // Inverse & Utils
        property color m3inverseSurface: "#372e31"
        property color m3inverseOnSurface: "#fcedf1"
        property color m3inversePrimary: "#fdb0d4"
        property color m3outline: "#827379"
        property color m3outlineVariant: "#d4c2c8"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"

// Primary
    Behavior on m3primary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onPrimary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3primaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onPrimaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3primaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3primaryFixedDim { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onPrimaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onPrimaryFixedVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Secondary
    Behavior on m3secondary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSecondary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3secondaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSecondaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3secondaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3secondaryFixedDim { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSecondaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSecondaryFixedVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Tertiary
    Behavior on m3tertiary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onTertiary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3tertiaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onTertiaryContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3tertiaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3tertiaryFixedDim { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onTertiaryFixed { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onTertiaryFixedVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Error
    Behavior on m3error { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onError { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3errorContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onErrorContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Background & Surface
    Behavior on m3background { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onBackground { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surface { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSurface { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3onSurfaceVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceTint { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Surface Containers
    Behavior on m3surfaceDim { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceBright { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceContainerLowest { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceContainerLow { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceContainer { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceContainerHigh { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3surfaceContainerHighest { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }

    // Inverse & Utils
    Behavior on m3inverseSurface { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3inverseOnSurface { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3inversePrimary { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3outline { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3outlineVariant { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3shadow { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    Behavior on m3scrim { animation: root.animation.elementMoveFast.colorAnimation.createObject(this) }
    }

    font: QtObject {
        property QtObject family: QtObject {
            property string main: Config.options.appearance.fonts.main
            property string numbers: Config.options.appearance.fonts.numbers
            property string title: Config.options.appearance.fonts.title
            property string iconMaterial: "Material Symbols Rounded"
            property string iconNerd: Config.options.appearance.fonts.iconNerd
            property string monospace: Config.options.appearance.fonts.monospace
            property string reading: Config.options.appearance.fonts.reading
            property string expressive: Config.options.appearance.fonts.expressive
        }
        property QtObject variableAxes: QtObject {
            property var main: ({
                "wght": 450,
                "wdth": 100,
            })
            property var numbers: ({
                "wght": 450,
            })
            property var title: ({ // Slightly bold weight for title
                "wght": 550, // Weight (Lowered to compensate for increased grade)
            })
        }
        property QtObject pixelSize: QtObject {
            property int smallest: 10 * (Config.options.appearance.fontScale / 100)
            property int smaller: 12 * (Config.options.appearance.fontScale / 100)
            property int small: 15 * (Config.options.appearance.fontScale / 100)
            property int normal: 18 * (Config.options.appearance.fontScale / 100)
            property int large: 20 * (Config.options.appearance.fontScale / 100)
            property int larger: 22 * (Config.options.appearance.fontScale / 100)
            property int huge: 30 * (Config.options.appearance.fontScale / 100)
            property int title: huge * (Config.options.appearance.fontScale / 100)
        }
    }

    animationCurves: QtObject {
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.90, 1, 1] // Default, 350ms
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1.00, 1, 1] // Default, 500ms
        readonly property list<real> expressiveSlowSpatial: [0.39, 1.29, 0.35, 0.98, 1, 1] // Default, 650ms
        readonly property list<real> expressiveEffects: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedFirstHalf: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82]
        readonly property list<real> emphasizedLastHalf: [5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property real expressiveFastSpatialDuration: 350
        readonly property real expressiveDefaultSpatialDuration: 500
        readonly property real expressiveSlowSpatialDuration: 650
        readonly property real expressiveEffectsDuration: 200
    }

    animation: QtObject {
        property QtObject elementMove: QtObject {
            property int duration: animationCurves.expressiveDefaultSpatialDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    duration: root.animation.elementMove.duration
                    easing.type: root.animation.elementMove.type
                    easing.bezierCurve: root.animation.elementMove.bezierCurve
                }
            }
        }

            property QtObject elementMoveEnter: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedDecel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementMoveEnter.duration
                    easing.type: root.animation.elementMoveEnter.type
                    easing.bezierCurve: root.animation.elementMoveEnter.bezierCurve
                }
            }
        }

        property QtObject elementMoveExit: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasizedAccel
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementMoveExit.duration
                    easing.type: root.animation.elementMoveExit.type
                    easing.bezierCurve: root.animation.elementMoveExit.bezierCurve
                }
            }
        }

        property QtObject elementMoveFast: QtObject {
            property int duration: animationCurves.expressiveEffectsDuration
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveEffects
            property int velocity: 850
            property Component colorAnimation: Component { ColorAnimation {
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
            property Component numberAnimation: Component { NumberAnimation {
                alwaysRunToEnd: true
                duration: root.animation.elementMoveFast.duration
                easing.type: root.animation.elementMoveFast.type
                easing.bezierCurve: root.animation.elementMoveFast.bezierCurve
            }}
        }

        property QtObject elementResize: QtObject {
            property int duration: 300
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.emphasized
            property int velocity: 650
            property Component numberAnimation: Component {
                NumberAnimation {
                    alwaysRunToEnd: true
                    duration: root.animation.elementResize.duration
                    easing.type: root.animation.elementResize.type
                    easing.bezierCurve: root.animation.elementResize.bezierCurve
                }
            }
        }

        property QtObject clickBounce: QtObject {
            property int duration: 400
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.expressiveDefaultSpatial
            property int velocity: 850
            property Component numberAnimation: Component { NumberAnimation {
                alwaysRunToEnd: true
                duration: root.animation.clickBounce.duration
                easing.type: root.animation.clickBounce.type
                easing.bezierCurve: root.animation.clickBounce.bezierCurve
            }}
        }

        property QtObject scroll: QtObject {
            property int duration: 200
            property int type: Easing.BezierSpline
            property list<real> bezierCurve: animationCurves.standardDecel
        }

        property QtObject menuDecel: QtObject {
            property int duration: 350
            property int type: Easing.OutExpo
        }
    }
}
