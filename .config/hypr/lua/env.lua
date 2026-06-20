-- Environment variables. Merged from the old env.conf + envs.conf (deduped).

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Defaults
hl.env("EDITOR", "nvim")
hl.env("BROWSER", "zen-browser")
hl.env("TERMINAL", "ghostty")

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- Cursor / scaling
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- GPU: AMD is primary (drives both displays), NVIDIA is secondary (offload only).
-- Aquamarine device order: primary first. Fixes the old `AQ_DRM_DEVICES=,...` bug
-- (the stray `=` made the variable name literally "AQ_DRM_DEVICES=").
-- NOTE: card1/card2 numbering is NOT stable across reboots. If the wrong GPU
-- becomes primary, switch to stable /dev/dri/by-path/* paths (ls -l /dev/dri/by-path).
hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1") -- AMD (card2) : NVIDIA (card1)

-- NVIDIA env is intentionally NOT global. Setting GBM_BACKEND=nvidia-drm /
-- __GLX_VENDOR_LIBRARY_NAME=nvidia / LIBVA_DRIVER_NAME=nvidia globally forces the
-- AMD-primary compositor onto NVIDIA and breaks rendering. For NVIDIA offload,
-- launch a specific app like this instead (per-app, not here):
--   __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only \
--   __GLX_VENDOR_LIBRARY_NAME=nvidia <command>
-- If NVIDIA later drives a display, uncomment the two lines below:
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
