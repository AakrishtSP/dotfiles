-- General settings. Merged general/decoration/input/misc/binds/cursor/group/etc.

hl.config({
	general = {
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		layout = "master",
		resize_on_border = true,
		allow_tearing = false,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(8f00ffee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	dwindle = {
		-- pseudotile = true,
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	decoration = {
		rounding = 10,
		blur = {
			enabled = true,
			popups = true,
		},
		shadow = {
			enabled = true,
			color = 0xee1a1a1a, -- was rgba(1a1a1aee)
		},
	},

	input = {
		kb_layout = "us",
		numlock_by_default = true,
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 0.5,
			middle_button_emulation = true,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
		key_press_enables_dpms = true,
		mouse_move_enables_dpms = true,
		disable_autoreload = true,
		focus_on_activate = true,
		initial_workspace_tracking = 2,
		size_limits_tiled = true,
	},

	debug = {
		vfr = true,
	},

	binds = {
		workspace_back_and_forth = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	cursor = {
		no_hardware_cursors = true,
		inactive_timeout = 30,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	-- Auto HDR: switch eDP into HDR for fullscreen content without forcing the
	-- whole desktop into PQ. Requires the monitor's supports_hdr (see monitors.lua).
	render = {
		cm_auto_hdr = 1,
	},

	group = {
		col = {
			border_active = { colors = { "rgba(33ccffee)", "rgba(8f00ffee)" }, angle = 45 },
			border_inactive = "rgba(595959aa)",
		},
	},
})

-- Touchpad gesture: 3-finger horizontal swipe -> switch workspace (both directions).
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
