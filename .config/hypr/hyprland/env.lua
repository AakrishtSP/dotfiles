local vars = require("variables")

-- From uwsm
-- -- Themes
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("QT_QUICK_CONTROLS_STYLE", "Material")
-- hl.env("QT_QUICK_CONTROLS_MATERIAL_THEME", "Dark")
-- hl.env("QT_QUICK_CONTROLS_MATERIAL_ACCENT", "Pink")
-- hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
-- hl.env("XCURSOR_THEME", vars.cursorTheme)
-- hl.env("XCURSOR_SIZE", vars.cursorSize)
-- -- hl.env("GTK_THEME", "")

-- -- Toolkit backends
-- hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
-- hl.env("CLUTTER_BACKEND", "wayland")
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- -- XDG specifications
-- hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("XDG_SESSION_DESKTOP", "Hyprland")
-- hl.env("XDG_MENU_PREFIX", "plasma-")

hl.env("TERM", "kitty")
-- Others
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")
hl.env("AQ_MGPU_NO_EXPLICIT", "1")
hl.env("AQ_FORCE_LINEAR_BLIT", "0")
