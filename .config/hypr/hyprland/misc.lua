local scheme = require("scheme.current")

hl.config({
    xwayland = {
        force_zero_scaling = true
    },
    misc = {
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,

        disable_hyprland_logo        = true,
        force_default_wallpaper      = 0,

        on_focus_under_fullscreen    = 2,
        allow_session_lock_restore   = true,
        middle_click_paste           = false,
        focus_on_activate            = true,
        session_lock_xray            = true,

        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,

        background_color             = "rgb(" .. scheme.surfaceContainer .. ")",
    },
    opengl = {
        nvidia_anti_flicker = true,
    },
    render = {
        direct_scanout = 2,
    },
    quirks = {
        -- prefer_hdr = 1,
    },
    ecosystem = {
        no_donation_nag = true,
        enforce_permissions = true,
    },
    debug = {
        error_position = 1
    }
})
