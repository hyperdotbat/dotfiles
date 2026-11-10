-- Smart gaps
hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_out = 0,
    gaps_in = 0,
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_out = 0,
    gaps_in = 0,
})

-- Smart gaps: single tiled window
hl.window_rule({
    name = "smartgaps-1",
    border_size = 0,
    rounding = 0,

    match = {
        float = false,
        workspace = "w[tv1]",
    },
})

-- Smart gaps: fullscreen workspace
hl.window_rule({
    name = "smartgaps-2",
    border_size = 0,
    rounding = 0,

    match = {
        float = false,
        workspace = "f[1]",
    },
})
