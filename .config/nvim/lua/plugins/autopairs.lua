return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
			-- Simplified, stable configuration
			disable_in_macro = true,
			disable_in_visualblock = true,
			enable_moveright = true,
			enable_afterquote = true,
			enable_check_bracket_line = false,
			enable_bracket_in_quote = true,
			break_undo = true,
			check_comma = true,
			map_c_h = false,
			map_c_w = false,
		})
	end,
}
