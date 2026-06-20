-- Keybinds. See https://wiki.hypr.land/Configuring/Basics/Binds/

local mod = "SUPER"

local terminal      = "ghostty +new-window"
local fileManager   = "dolphin"
local browser       = "zen-browser"
local launcher      = "rofi -show drun"
local powerMenu     = "nwgbar"
local changeWall    = "waypaper --random"
local lock          = "hyprlock"
local restartWaybar = "killall waybar && waybar"

-- Core
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"),        { description = "Reload config" })
hl.bind(mod .. " + Return",    hl.dsp.exec_cmd(terminal),                { description = "Terminal" })
hl.bind(mod .. " + T",         hl.dsp.exec_cmd(terminal),                { description = "Terminal" })
hl.bind(mod .. " + Q",         hl.dsp.window.close(),                    { description = "Close window" })
hl.bind(mod .. " + E",         hl.dsp.exec_cmd(fileManager),             { description = "File manager" })
hl.bind(mod .. " + B",         hl.dsp.exec_cmd(browser),                 { description = "Browser" })
hl.bind(mod .. " + space",     hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen(),               { description = "Fullscreen" })
hl.bind(mod .. " + P",         hl.dsp.window.pseudo(),                    { description = "Toggle pseudo (dwindle)" })
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd(powerMenu),               { description = "Power menu" })
hl.bind(mod .. " + Home",      hl.dsp.exec_cmd(restartWaybar),           { description = "Restart waybar" })
hl.bind(mod .. " + escape",    hl.dsp.exec_cmd(lock),                    { description = "Lock screen" })
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd(changeWall),              { description = "Random wallpaper" })
hl.bind(mod .. " + V",         hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"), { description = "Clipboard history" })
hl.bind(mod .. " + Super_L",   hl.dsp.exec_cmd(launcher),                { release = true, description = "App launcher" })

-- Focus (arrows + vim keys)
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind(mod .. " + H",     hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(mod .. " + L",     hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(mod .. " + K",     hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "d" }), { description = "Focus down" })
hl.bind(mod .. " + J",     hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Move window (arrows + vim keys)
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(mod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(mod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(mod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
hl.bind(mod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

-- Resize (was a submap; now direct repeating binds on mod+CTRL)
hl.bind(mod .. " + CTRL + right", hl.dsp.window.resize({ x = 50,  y = 0, relative = true }), { repeating = true, description = "Resize wider" })
hl.bind(mod .. " + CTRL + L",     hl.dsp.window.resize({ x = 50,  y = 0, relative = true }), { repeating = true, description = "Resize wider" })
hl.bind(mod .. " + CTRL + left",  hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true, description = "Resize narrower" })
hl.bind(mod .. " + CTRL + H",     hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true, description = "Resize narrower" })
hl.bind(mod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true, description = "Resize shorter" })
hl.bind(mod .. " + CTRL + K",     hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true, description = "Resize shorter" })
hl.bind(mod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0, y = 50,  relative = true }), { repeating = true, description = "Resize taller" })
hl.bind(mod .. " + CTRL + J",     hl.dsp.window.resize({ x = 0, y = 50,  relative = true }), { repeating = true, description = "Resize taller" })

-- Workspaces 1-10 (switch / move-silent)
for i = 1, 10 do
    local key = i % 10 -- 10 -> key 0
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }),                      { description = "Workspace " .. i })
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }), { description = "Move to workspace " .. i })
end

-- Special workspaces
hl.bind(mod .. " + minus",         hl.dsp.workspace.toggle_special("scratchpad"),                      { description = "Toggle scratchpad" })
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", silent = true }), { description = "Move to scratchpad" })
hl.bind(mod .. " + D",             hl.dsp.workspace.toggle_special("discord"),                         { description = "Toggle Discord" })
hl.bind(mod .. " + S",             hl.dsp.workspace.toggle_special("spotify"),                         { description = "Toggle Spotify" })

-- Workspace scroll + mouse drag/resize
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }), { description = "Next workspace" })
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }), { description = "Previous workspace" })
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true, description = "Drag window" })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Audio (locked = works on lockscreen)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd('pamixer --decrease 5; notify-send " Volume: "$(pamixer --get-volume) -t 500'), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd('pamixer --increase 5; notify-send " Volume: "$(pamixer --get-volume) -t 500'), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd('pamixer --toggle-mute; notify-send " Volume: Toggle-mute" -t 500'),           { locked = true, description = "Toggle mute" })

-- Brightness
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -c backlight set 5%-"), { locked = true, repeating = true, description = "Brightness down" })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -c backlight set +5%"), { locked = true, repeating = true, description = "Brightness up" })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "Previous track" })

-- Screenshots (scripts/screenshot.sh)
local shot = os.getenv("HOME") .. "/.config/hypr/scripts/screenshot.sh"
hl.bind("SHIFT + Print",        hl.dsp.exec_cmd(shot .. " screen"), { description = "Screenshot all outputs" })
hl.bind("Print",                hl.dsp.exec_cmd(shot .. " area"),   { description = "Screenshot area" })
hl.bind(mod .. " + SHIFT + S",  hl.dsp.exec_cmd(shot .. " area"),   { description = "Screenshot area" })
hl.bind(mod .. " + Print",      hl.dsp.exec_cmd(shot .. " active"), { description = "Screenshot active window" })
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd(shot .. " output"), { description = "Screenshot output" })
