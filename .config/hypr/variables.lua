local scheme            = require("scheme.current")

local config            = {
    -- shell                      = "quickshell -c caelestia",
    shell           = "dms",
    shellSpawner    = "systemctl --user start dms.service",
    screenshotTool  = "dms screenshot",

    -- Apps
    terminal        = "ghostty",
    browser         = "vivaldi",
    editor          = "zededitor",
    -- fileExplorer    = "ghostty -e tmux new-session -A -s fileExplorer -n yazi yazi",
    fileExplorer    = "kitty -e yazi",
    -- Misc
    sleepGestureCmd = "dms ipc call lock lock",
}

-- Screenshot commands
config.screenshotWindow = config.screenshotTool .. " window"
config.screenshotRegion = config.screenshotTool .. " region"
config.screenshotOutput = config.screenshotTool .. " full"
config.screenshotFull   = config.screenshotTool .. " all"


-- Terminal
config.terminalFresh = config.terminal .. " -e tmux new-session"
return config
