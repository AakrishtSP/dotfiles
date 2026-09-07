-- Tags an array of window matches. If `field` is given, matches should be an
-- array of strings. Otherwise, it should be an array of tables.
local function assign_tag(tag, matches, field)
    for _, match in ipairs(matches) do
        if field then
            local table = {}
            table[field] = match
            match = table
        end
        hl.window_rule({ match = match, tag = "+" .. tag })
    end
end

local function rule_on_tag(tag, rules)
    local rule = { match = { tag = tag } }
    for k, v in pairs(rules) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

-- All tags
local opaque_tag = "opaque"
local float_tag = "float"
local float_60_70_tag = "float_60_70"
local float_70_80_tag = "float_70_80"
local float_50_60_tag = "float_50_60"
local game_tag = "game"
local game_launcher_tag = "game_launcher"
local xwl_popup_tag = "xwl_popup"
local system_monitor_tag = "system_monitor"
local music_player_tag = "music_player"
local communication_app_tag = "communication_app"
local todo_app_tag = "todo_app"


----------------------
---- Window rules ----
----------------------

-- Apply default opacity to all windows except fullscreen
hl.window_rule({ match = { fullscreen = false }, opacity = 1 .. " override" })

-- Center all floating windows except xwayland windows (xwayland popups count as windows)
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Picture in picture (move and resize done via resizer in execs.lua)
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)", -- Initial move so window doesn't jump so much
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})


----------------------
---- Assign Tags  ----
----------------------

-- Opaque apps
assign_tag(opaque_tag, {
    "com.mitchellh.ghostty",         -- Terminal
    "equibop",                       -- Discord client
    "org.quickshell",                -- Quickshell
    "feh|imv|swappy",                -- Image viewers
    "krita|gimp|inkscape|darktable", -- Image editors
    "resolve|kdenlive|shotcut",      -- Video editors
    "blender|godot",                 -- 3D editors
}, "class")


-- Floating apps
assign_tag(float_tag, {
    "guifetch",                           -- System info
    "yad|zenity",                         -- Dialogs
    "wev",                                -- Input detector
    "org.gnome.FileRoller|file-roller",   -- Archive manager
    "blueman-manager",                    -- Bluetooth GUI
    "com.github.GradienceTeam.Gradience", -- GTK themer (deprecated)
    "feh|imv|swappy",                     -- Image viewers
    "org.quickshell",                     -- Quickshell
}, "class")
assign_tag(float_tag, {
    "File (Operation|Upload)( Progress)?", -- File manager operation progress (upload, move, copy, etc)
    ".* Properties",                       -- File properties
}, "title")


-- Sized floaters
-- 60% x 70%
assign_tag(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?", -- File dialogs
    "Save As",                              -- Save dialogs
    "Library",                              -- * I don't remember what this matches...
}, "title")
assign_tag(float_60_70_tag, {
    { title = "(Save|Export) Image", class = "gimp" }, -- GIMP export/save
})
assign_tag(float_60_70_tag, {
    "org.pulseaudio.pavucontrol|com.saivert.pwvucontrol", -- Audio control
    "yad-icon-browser",                                   -- GTK icon browser
}, "class")

-- 70% x 80%
assign_tag(float_70_80_tag, {
    "org.gnome.Settings", -- System settings
}, "class")

-- 50% x 60%
assign_tag(float_50_60_tag, {
    "nwg-look",              -- GTK theme manager
    "system-config-printer", -- Printer config
}, "class")


-- Games
assign_tag(game_tag, {
    "steam_app_[0-9]+",  -- Steam games
    "steam_app_default", -- Lutris games
    "gamescope",         -- Gamescope
}, "class")



-- Xwayland popups
assign_tag(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "",         class = "", initial_title = "", initial_class = "" }
})

hl.window_rule({ match = { class = "^steam$" } })
-- Special workspaces
assign_tag(game_launcher_tag, { "steam" }, "class")
assign_tag(system_monitor_tag, { "btop" }, "class")
assign_tag(system_monitor_tag, { "System Monitor" }, "initial_title")
assign_tag(music_player_tag, {
    "feishin|Supersonic|Plexamp",                                  -- Self hosted
    "Spotify",                                                     -- Spotify
    "Cider",                                                       -- Apple music
    "com.github.th-ch.youtube-music|com-maxrave-simpmusic-MainKt", -- YouTube music
}, "class")
assign_tag(music_player_tag, {
    "Spotify|Spotify Free" -- Spotify wayland, it has no class for some reason
}, "initial_title")
assign_tag(communication_app_tag, {
    "discord|equibop|vesktop",   -- Discord clients
    "whatsapp|com.rtosta.zapzap" -- Whatsapp
}, "class")
assign_tag(todo_app_tag, {
    "todoist" -- Todoist
}, "class")


-----------------------
---- Per app rules ----
-----------------------

-- Steam
assign_tag(float_tag, { { class = "steam", title = "Friends List" } })
assign_tag(xwl_popup_tag, { { class = "steam", title = "" } })

-- Ueberzugpp
hl.window_rule({ match = { class = "ueberzugpp_.*" }, float = true, no_initial_focus = true })

-- Autodesk Fusion 360
hl.window_rule({ match = { class = "fusion360.exe", title = "Fusion360|(Marking Menu)" }, no_blur = true })

-- Minecraft launcher consoles
assign_tag(float_tag, {
    { class = "com-atlauncher-App", title = "ATLauncher Console" },
    { class = "PandoraLauncher",    title = "Minecraft Game Output" },
})


-------------------------
----  Rules on Tag   ----
-------------------------
-- These have to come after all uses of window tagging. Thank you Hyprland...

rule_on_tag(opaque_tag, { opaque = true })
rule_on_tag(float_tag, { float = true })
rule_on_tag(float_50_60_tag, { float = true, size = "(monitor_w*0.5) (monitor_h*0.6)", center = true })
rule_on_tag(float_60_70_tag, { float = true, size = "(monitor_w*0.6) (monitor_h*0.7)", center = true })
rule_on_tag(float_70_80_tag, { float = true, size = "(monitor_w*0.7) (monitor_h*0.8)", center = true })
rule_on_tag(game_tag, { opaque = true, immediate = true, idle_inhibit = "always" })
rule_on_tag(xwl_popup_tag, {
    no_dim = true,
    no_shadow = true,
    no_blur = true,
    opaque = true,
    rounding = math.min(10, 15), -- Popups are usually small, so we want to limit the rounding
})
rule_on_tag(system_monitor_tag, { workspace = "special:sysmon" })
rule_on_tag(music_player_tag, { workspace = "special:music" })
rule_on_tag(communication_app_tag, { workspace = "special:communication" })
rule_on_tag(game_launcher_tag, { workspace = "special:game_launcher" })

-------------------------
---- Workspace defaults ----
-------------------------
hl.workspace_rule({ workspace = "special:sysmon", on_created_empty = "dms ipc call processlist focusOrToggle" })
hl.workspace_rule({ workspace = "special:communication", on_created_empty = "equibop" })
hl.workspace_rule({ workspace = "special:game_launcher", on_created_empty = "steam" })

-------------------------
---- Workspace rules ----
-------------------------
local function bind_workspaces_to_monitor(name_pattern, first_id, last_id)
    for _, mon in ipairs(hl.get_monitors() or {}) do
        if mon.name:match(name_pattern) then
            for id = first_id, last_id do
                hl.workspace_rule({
                    workspace = tostring(id),
                    monitor = mon.name,
                    default = (id == first_id),
                })
            end
        end
    end
end

bind_workspaces_to_monitor("^eDP", 1, 10)
bind_workspaces_to_monitor("^HDMI", 11, 20)

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 5 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 55 })


---------------------
---- Layer rules ----
---------------------

hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })                 -- Colour picker out animation
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" })              -- wlogout
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })                  -- slurp
hl.layer_rule({ match = { namespace = "wayfreeze" }, animation = "fade" })                  -- wayfreeze
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%", blur = true }) -- Fuzzel

-- Shell
hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })

hl.layer_rule({
    match = { namespace = "dms:(bar|dock|tooltip|toast|osd|notification-popup|tray-menu-window|slideout)" },
    no_anim = true
})

-- Fade: full-screen modals
hl.layer_rule({
    match = { namespace = "dms:(clipboard|file-browser|settings|spotlight|bluetooth-pairing|color-picker|hyprkeybinds|network-info|network-info-wired|notification-center-modal|polkit|power-menu|process-list-modal|wifi-password|confirm-modal|modal)" },
    animation = "fade"
})

-- Slide right: bar-anchored popouts
hl.layer_rule({
    match = { namespace = "dms:(app-launcher|control-center|battery|dash|notification-center-popout|process-list-popout|popout)" },
    animation = "slide right"
})

-- Slide top: workspace overview (Hyprland only)
hl.layer_rule({
    match = { namespace = "dms:workspace-overview" },
    animation = "slide top"
})
hl.layer_rule({ match = { namespace = "quickshell" }, no_anim = true })
