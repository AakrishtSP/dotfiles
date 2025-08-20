return {
	"nvim-pack/nvim-spectre",
	cmd = "Spectre", -- Lazy load only when commanded
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		color_devicons = true,
		live_update = true,
		open_cmd = "vnew",

		-- Minimal UI
		line_sep_start = "────────────────────────────────────────",
		result_padding = "  ",
		line_sep = "────────────────────────────────────────",

		-- Essential mappings only
		mapping = {
			["toggle_line"] = { map = "dd", cmd = "<cmd>lua require('spectre').toggle_line()<CR>" },
			["enter_file"] = { map = "<cr>", cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>" },
			["send_to_qf"] = { map = "<leader>q", cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>" },
			["run_replace"] = { map = "<leader>R", cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>" },
			["run_current_replace"] = {
				map = "<leader>r",
				cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
			},
		},

		-- Fast search engine (rg only)
		find_engine = {
			["rg"] = {
				cmd = "rg",
				args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
				options = {
					["ignore-case"] = { value = "--ignore-case", icon = "[I]" },
					["hidden"] = { value = "--hidden", icon = "[H]" },
				},
			},
		},

		-- Fast replace engine (sed only)
		replace_engine = {
			["sed"] = {
				cmd = "sed",
				args = nil,
			},
		},

		-- Simple defaults
		default = {
			find = { cmd = "rg", options = { "ignore-case" } },
			replace = { cmd = "sed" },
		},
	},

	keys = {
		{
			"<leader>sp",
			function()
				require("spectre").toggle()
			end,
			desc = "Toggle Spectre",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search Word",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual()
			end,
			mode = "v",
			desc = "Search Selection",
		},
		{
			"<leader>S",
			function()
				require("spectre").open_file_search()
			end,
			desc = "Search in File",
		},
	},
}
