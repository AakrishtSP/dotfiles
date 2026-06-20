-- Window / workspace / layer rules.

local mon1 = "eDP-2"
local mon2 = "DP-2"

-- Workspaces 1-5 on the laptop, 6-10 on the external. ws1/ws6 are defaults.
for i = 1, 10 do
    local mon = (i <= 5) and mon1 or mon2
    local rule = { workspace = tostring(i), monitor = mon }
    if i == 1 or i == 6 then rule.default = true end
    hl.workspace_rule(rule)
end

-- Special (scratchpad-style) workspaces, spawn an app when first opened.
hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "ghostty" })
hl.workspace_rule({ workspace = "special:discord",    on_created_empty = "discord" })
hl.workspace_rule({ workspace = "special:spotify",    on_created_empty = "spotify-launcher" })
hl.workspace_rule({ workspace = "special:terminal",   on_created_empty = "ghostty", decorate = false, no_shadow = true })

-- Smart gaps: drop gaps/border/rounding when a workspace has a single tiled
-- window (ignoring special workspaces).
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" },   border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" },   rounding = 0 })

-- App -> special workspace routing.
hl.window_rule({
    name  = "discord",
    match = { initial_title = "(.*)(Discord)(.*)" },
    workspace = "special:discord silent",
})
hl.window_rule({
    name  = "spotify",
    match = { class = "Spotify" },
    workspace = "special:spotify silent",
})

-- Hide xwaylandvideobridge.
hl.window_rule({
    name  = "xwaylandvideobridge",
    match = { class = "xwaylandvideobridge" },
    no_initial_focus = true,
    no_focus = true,
    no_anim  = true,
    no_blur  = true,
    max_size = { 1, 1 },
    opacity  = "0.0",
})

-- Blur the waybar layer.
hl.layer_rule({ name = "blur-waybar", match = { namespace = "waybar" }, blur = true })
