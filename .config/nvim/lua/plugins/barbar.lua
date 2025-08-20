return {
	-- Simple barbar config
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		-- Load only when UI is ready and we have multiple buffers
		event = "VeryLazy",
		keys = {
			{ "<A-,>", "<cmd>BufferPrevious<cr>", desc = "Previous Buffer" },
			{ "<A-.>", "<cmd>BufferNext<cr>", desc = "Next Buffer" },
			{ "<A-c>", "<cmd>BufferClose<cr>", desc = "Close Buffer" },
			{ "<A-1>", "<cmd>BufferGoto 1<cr>", desc = "Goto Buffer 1" },
			{ "<A-2>", "<cmd>BufferGoto 2<cr>", desc = "Goto Buffer 2" },
			{ "<A-3>", "<cmd>BufferGoto 3<cr>", desc = "Goto Buffer 3" },
			{ "<A-4>", "<cmd>BufferGoto 4<cr>", desc = "Goto Buffer 4" },
			{ "<A-5>", "<cmd>BufferGoto 5<cr>", desc = "Goto Buffer 5" },
		},
		opts = {
			animation = false, -- Faster
			auto_hide = false,
			clickable = true,
			focus_on_close = "left",
			icons = {
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = true, icon = "●" },
					[vim.diagnostic.severity.WARN] = { enabled = false },
				},
				filetype = { enabled = true },
				modified = { button = "●" },
				separator = { left = "▎", right = "" },
			},
			maximum_padding = 1,
			minimum_padding = 1,
			maximum_length = 30,
		},
	},

	-- Navigation breadcrumbs in statusline
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		opts = {
			lsp = { auto_attach = true },
			highlight = true,
			separator = " > ",
			depth_limit = 5,
			icons = {
				File = "󰈙 ",
				Module = " ",
				Namespace = "󰌗 ",
				Package = " ",
				Class = "󰌗 ",
				Method = "󰆧 ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "󰕘",
				Interface = "󰕘",
				Function = "󰊕 ",
				Variable = "󰆧 ",
				Constant = "󰏿 ",
				String = " ",
				Number = "󰎠 ",
				Boolean = "◩ ",
				Array = "󰅪 ",
				Object = "󰅩 ",
				Key = "󰌋 ",
				Null = "󰟢 ",
			},
		},
	},

	-- Code navigation popup
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Navbuddy",
		keys = {
			{ "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Nav Buddy" },
		},
		opts = {
			lsp = { auto_attach = true },
		},
	},
}
