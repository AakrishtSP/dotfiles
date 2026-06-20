-- Hyprland config (Lua, 0.55+). Entry point.
-- Hyprland loads this instead of hyprland.conf when present.
-- The old .conf files are now inert and can be deleted once this is verified.
-- hypridle.conf / hyprlock.conf stay as-is: those tools still use hyprlang.

require("lua/env")
require("lua/monitors")
require("lua/settings")
require("lua/animations")
require("lua/rules")
require("lua/binds")
require("lua/autostart")
require("lua/permissions")
