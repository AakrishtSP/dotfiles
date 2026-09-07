local vars = require("variables")
local fn   = require("utils.functions")

-- Launcher
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("dms ipc call spotlight toggle"),
    { release = true, description = "Default Launcher: Toggle" })


-- Misc
-- Kill/restart the shell (not Hyprland itself)
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd(vars.shell .. " kill"), { release = true })
hl.bind(
    "CTRL + SUPER + ALT + R",
    hl.dsp.exec_cmd(vars.shell .. " kill; sleep .1; " .. vars.shell .. " -d"),
    { release = true }
)

-- Workspaces 1-20: focus/move a window into a workspace or workspace group
for i = 1, 20 do
    local mod = i <= 10 and "" or "ALT + "
    local key = i % 10 -- 10/20 map to key 0
    hl.bind("SUPER + " .. mod .. key, fn.wsaction("focus", "", i))
    hl.bind("SUPER + " .. mod .. "SHIFT + " .. key, fn.wsaction("move", "", i))
    hl.bind("CTRL + SUPER + " .. mod .. key, fn.wsaction("focus", "group", i))
    hl.bind("CTRL + SUPER + " .. mod .. "SHIFT + " .. key, fn.wsaction("move", "group", i))
end


-- Window groups (tabbed stacks of windows sharing a slot)
-- Alt+Tab (standard MRU)
hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod alt"))

hl.bind("CTRL + ALT + TAB", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + TAB", hl.dsp.group.prev(), { repeating = true })
hl.bind("SUPER + Comma", hl.dsp.group.toggle())
hl.bind("SUPER + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

-- Window actions: directional focus/move
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

-- Resize submap: SUPER+R enters, arrows resize by 10px/step, Escape or R exits.
hl.define_submap("resize", function()
    hl.bind("left", fn.resize_active_window(-10, 0), { repeating = true })
    hl.bind("right", fn.resize_active_window(10, 0), { repeating = true })
    hl.bind("up", fn.resize_active_window(0, -10), { repeating = true })
    hl.bind("down", fn.resize_active_window(0, 10), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("SUPER + R", hl.dsp.submap("reset"))
end)
hl.bind("SUPER + R", hl.dsp.submap("resize"))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
    hl.dispatch(hl.dsp.window.center())
end)

-- Picture-in-picture: float (if not already) and pin the active window on top
hl.bind("SUPER + ALT + Backslash", function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)

hl.bind("SUPER + P", hl.dsp.window.pin())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + ALT + Space", hl.dsp.window.float())
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Special workspace toggles
hl.bind("SUPER + S", fn.toggle("game_launcher"))
hl.bind("CTRL + SHIFT + Escape", fn.toggle("sysmon"))
hl.bind("SUPER + M", fn.toggle("music"))
hl.bind("SUPER + D", fn.toggle("communication"))

-- Apps
hl.bind("SUPER + T", hl.dsp.exec_cmd(vars.terminalFresh))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(vars.terminal))
hl.bind("SUPER + W", hl.dsp.exec_cmd(vars.browser))
hl.bind("SUPER + C", hl.dsp.exec_cmd(vars.editor))
hl.bind("SUPER + E", hl.dsp.exec_cmd(vars.fileExplorer))

-- Utilities
hl.bind("Print", hl.dsp.exec_cmd(vars.screenshotOutput), { locked = true })
hl.bind("SUPER + Print", hl.dsp.exec_cmd(vars.screenshotWindow), { locked = true })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(vars.screenshotRegion), { locked = true })
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd(vars.screenshotFull), { locked = true })
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(vars.screenshotRegion), { locked = true })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Volume
hl.bind(
    "SUPER + SHIFT + M",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true }
)
-- Unmute-then-raise: prevents "volume up" from silently doing nothing while muted
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"
    ),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
    ),
    { locked = true, repeating = true }
)

-- Sleep
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd(vars.sleepGestureCmd), { locked = true })
