-- Monitors. 2-display setup: eDP-2 (laptop, HDR-capable) + DP-2 (external).
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Internal panel. 10-bit + auto HDR: desktop stays accurate SDR, and HDR engages
-- automatically for fullscreen content (paired with render.cm_auto_hdr in settings).
hl.monitor({
    output  = "eDP-2",
    mode    = "2560x1600@165",
    position = "0x0",
    scale   = 1.25,
    bitdepth = 10,
    cm      = "auto",          -- srgb for SDR, wide for 10bpc; HDR on demand
    supports_hdr = 1,
    supports_wide_color = 1,
})

-- External monitor, auto-placed to the right of eDP-2.
hl.monitor({
    output  = "DP-2",
    mode    = "1440x900@75",
    position = "auto",
    scale   = 1,
})

-- Fallback for any other monitor that gets plugged in.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
