-- Workspaces are laid out in fixed-size groups of 20 (e.g. one group per
-- monitor/output). A workspace id is 1-based and its group/position are
-- derived, not stored:
--   group    = floor((id - 1) / 20) + 1   (1, 2, 3, ...)
--   position = ((id - 1) % 20) + 1        (1..20, wraps every 20 ids)
--
-- wsaction builds a keybind handler for one (action, range, i) combo, where:
--   action = "move" | "focus"        -- what to do with the target workspace
--   range  = "group" | "" (workspace) -- which axis `i` selects
--   i      = 1..20                    -- the target group or position
--
-- range == "group":
--   Keep your position in the current group, jump to group i.
--   e.g. on id=45 (group 3, pos 5), i=1 -> id=5 (group 1, pos 5).
--   Used for "send me/this window to monitor i, same relative spot".
--
-- range == "" (plain workspace):
--   Keep your current group, jump to position i within it.
--   e.g. on id=45 (group 3, pos 5), i=7 -> id=47 (group 3, pos 7).
--   Used for "switch to workspace i on this monitor".
local function wsaction(action, range, i)
    return function()
        local activews = hl.get_active_workspace()
        if not activews then return end
        local id = activews.id

        -- ponytail: `id % 20` looks like the obvious way to get position-in-group,
        -- but it's wrong at group boundaries: id=20 -> 20 % 20 == 0, which would
        -- put you in group (i-1) instead of group i. `(id - 1) % 20 + 1` gives the
        -- correct 1..20 position with no zero case.
        local pos = (id - 1) % 20 + 1

        local z
        if range == "group" then
            z = (i - 1) * 20 + pos                 -- same position, jump to group i
        else
            z = math.floor((id - 1) / 20) * 20 + i -- same group, jump to position i
        end

        local dsp = (action == "move") and hl.dsp.window.move or hl.dsp.focus
        return hl.dispatch(dsp({ workspace = z }))
    end
end

local function resize_by_screen(x, y)
    local screen = hl.get_active_monitor()
    if not (screen and type(screen.width) == "number" and type(screen.height) == "number") then return end
    if x == 0 and y == 0 then return end
    local w = (x and x > 0) and math.floor(screen.width * x / 100) or screen.width
    local h = (y and y > 0) and math.floor(screen.height * y / 100) or screen.height
    return { x = w, y = h, relative = false }
end

local function resize_active_window(x, y)
    return function() -- returning the function so hl reloads everytime correctly
        local win = hl.get_active_window()
        if not (win and win.size) then
            return hl.dispatch(hl.dsp.no_op())
        end
        -- ponytail: no numeric fallback here — x/y are always percentages from
        -- config, and `win.size.x * (x/100)) or 800` used to look like a safety
        -- net but couldn't fire (arithmetic on nil errors before `or` runs).
        -- If x/y ever become optional, guard explicitly: `x and w*(x/100) or 800`.
        local w = win.size.x * (x / 100)
        local h = win.size.y * (y / 100)
        hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = true }))
    end
end

local function resizer(window, pattern, x_percent, y_percent, actions, exact, field)
    local value = window and window[field or "title"]
    if value and string.find(value, pattern, 1, exact) then
        local disp = (type(actions) == "table") and actions or { actions }
        for _, x in ipairs(disp) do
            hl.dispatch(x)
        end

        -- Target the matched window explicitly. Without window=, resize/set_prop
        -- act on the currently focused window instead, mangling whatever tiled
        -- window happened to be focused when this matched.
        local sz = resize_by_screen(x_percent, y_percent)
        if sz then
            sz.window = window
            hl.dispatch(hl.dsp.window.resize(sz))
        end
        hl.dispatch(hl.dsp.window.set_prop({ prop = "keep_aspect_ratio", value = "true", window = window }))
    end
end

local function move_actions(win)
    local screen = hl.get_active_monitor()

    if screen and screen.width and screen.height and win and win.size then
        local monitor_height = screen.height / screen.scale
        local monitor_width  = screen.width / screen.scale

        local scale_factor   = (monitor_height / 4) / win.size.y

        local target_width   = win.size.x * scale_factor
        local target_height  = win.size.y * scale_factor

        local x_resize       = math.floor(math.max(200, target_width))
        local y_resize       = math.floor(math.max(150, target_height))

        local offset         = math.min(monitor_width, monitor_height) * 0.03

        local move_x         = math.floor(screen.x + monitor_width - x_resize - offset)
        local move_y         = math.floor(screen.y + monitor_height - y_resize - offset)

        return {
            hl.dsp.window.resize({ x = x_resize, y = y_resize, window = win }),
            hl.dsp.window.move({ x = move_x, y = move_y, relative = false, window = win }),
        }
    end
end

local function toggle(special_workspace)
    return function()
        if special_workspace ~= "specialws" then
            return hl.dispatch(hl.dsp.workspace.toggle_special(special_workspace))
        end
        local active = hl.get_active_special_workspace()
        return hl.dispatch(hl.dsp.workspace.toggle_special(active and active.name:gsub("^special:", "") or "special"))
    end
end

return {
    resizer              = resizer,
    resize_by_screen     = resize_by_screen,
    resize_active_window = resize_active_window,
    wsaction             = wsaction,
    move_actions         = move_actions,
    toggle               = toggle,
}
