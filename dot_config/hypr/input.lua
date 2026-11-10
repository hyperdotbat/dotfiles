-- https://wiki.hyprland.org/Configuring/Variables/#input
hl.config {
    input = {
        kb_layout = "pl",
        -- kb_variant = ,
        -- kb_model =
        kb_options = "fkeys:basic_13-24, altgr-intl,nodeadkeys",
        -- kb_rules =

        follow_mouse = 1,

        sensitivity = -0.4, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true
        },

        repeat_delay = 300,
        repeat_rate = 40,

        -- make Caps act as Super
        -- kb_options = caps:super
    },
}

-- https://wiki.hypr.land/Configuring/Gestures/
-- https://wiki.hyprland.org/Configuring/Variables/#gestures
hl.gesture {
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
}
hl.gesture {
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
}
hl.gesture {
    fingers = 2,
    direction = "pinch",
    mod = "SUPER",
    action = "resize",
}
hl.gesture {
    fingers = 4,
    direction = "pinch",
    action = "fullscreen",
}

-- https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
hl.device {
    name = "tpps/2-ibm-trackpoint",
    accel_profile = "adaptive",
    sensitivity = -0.5,
}
hl.device {
    name = "synaptics-tm3276-022",
    accel_profile = "adaptive",
    sensitivity = 0.0,
}
