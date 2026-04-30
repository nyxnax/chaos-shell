import qs.common.widgets

// Material Design 3 style settings tile and switch

ConfigTile {
    id: root
    checkable: true
    PointingHand {}

    control: StyledSwitch {
        scale: 1
        checked: root.checked
        enabled: false
    }
}
