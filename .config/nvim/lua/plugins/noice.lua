return {
	"folke/noice.nvim",
	event = "VeryLazy",
	cond = function()
		return not vim.g.vscode
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		-- Centered command line
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
		},

		-- Basic message handling
		messages = {
			enabled = true,
			view = "mini", -- Faster than notify
		},

		-- Disable everything else for speed
		popupmenu = { enabled = false },
		notify = { enabled = true, view = "mini" },

		lsp = {
			progress = { enabled = false },
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = false,
				["vim.lsp.util.stylize_markdown"] = false,
				["cmp.entry.get_documentation"] = false,
			},
			hover = { enabled = false },
			signature = { enabled = false },
		},

		-- Minimal presets
		presets = {
			bottom_search = false,
			command_palette = false,
			long_message_to_split = false,
			inc_rename = false,
			lsp_doc_border = false,
		},

		-- Simple routes - skip common noise
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "written" },
						{ find = "recording @" },
						{ find = "-- INSERT --" },
					},
				},
				opts = { skip = true },
			},
		},

		-- Simplified views
		views = {
			cmdline_popup = {
				position = { row = 5, col = "50%" },
				size = { width = 60, height = "auto" },
				border = { style = "rounded" },
			},
			mini = {
				position = { row = -2, col = "100%" },
				timeout = 2000,
			},
		},
	},
}
