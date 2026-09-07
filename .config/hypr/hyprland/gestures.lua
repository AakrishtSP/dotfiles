local vars = require("variables")
local fn   = require("utils.functions")

hl.config({
    gestures = {
        workspace_swipe_distance                 = 300,
        workspace_swipe_cancel_ratio             = 0.30,
        workspace_swipe_min_speed_to_force       = 30,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new               = true,
        workspace_swipe_forever                  = true,
    },
})

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move"
})

-- hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "special" })
-- hl.gesture({
--     fingers   = 3,
--     direction = "down",
--     action    = fn.toggle("specialws"),
-- })
hl.gesture({
    fingers   = 4,
    direction = "down",
    action    = function()
        hl.exec_cmd(vars.sleepGestureCmd)
    end,
})
