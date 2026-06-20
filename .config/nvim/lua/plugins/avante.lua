return {
	"yetone/avante.nvim",
	enabled = false,
	event = "VeryLazy",
	version = false, -- always track latest; never set "*"
	build = "make BUILD_FROM_SOURCE=true",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		{ "zbirenbaum/copilot.lua", opts = {} },
	},
	opts = {
		-- primary provider for chat/edits
		provider = "claude",
		-- fast model for auto-suggestions (copilot is cheaper/faster here)
		auto_suggestions_provider = "copilot",
		-- agentic mode: lets avante use tools autonomously (file read, grep, etc.)
		mode = "agentic",

		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-20250514", -- updated: 3.5-sonnet is outdated
				timeout = 30000,
				extra_request_body = {
					temperature = 0, -- 0 is better for code; 1 produces noisy diffs
					max_tokens = 8192, -- sonnet 4 supports much larger outputs
				},
			},
		},

		behaviour = {
			auto_suggestions = true,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false, -- always review diffs manually
			support_paste_from_clipboard = true, -- useful for pasting error logs
		},

		windows = {
			wrap = true,
			width = 35, -- slightly wider is more readable
			side_by_side = true,
			ask = {
				floating = false,
				start_insert = true,
				focus_on_apply = "ours", -- cursor returns to your buffer after apply
			},
		},

		highlights = {
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},

		diff = {
			autojump = true,
			list_opener = "copen",
		},

		-- project-specific instructions: drop an avante.md in repo root
		-- avante injects it into every prompt automatically
		project_context = {
			enabled = true,
		},

		file_selector = {
			provider = "fzf", -- matches your fzf-lua setup
		},
	},

	keys = {
		{
			"<leader>aa",
			function()
				require("avante.api").ask()
			end,
			desc = "avante: ask",
		},
		{
			"<leader>ar",
			function()
				require("avante.api").refresh()
			end,
			desc = "avante: refresh",
		},
		{
			"<leader>ae",
			function()
				require("avante.api").edit()
			end,
			mode = "v",
			desc = "avante: edit",
		},
		{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "avante: toggle sidebar" },
		{ "<leader>am", "<cmd>AvanteModels<cr>", desc = "avante: switch model" },
	},
}
