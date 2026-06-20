return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		search = {
			multi_window = true,
			forward = true,
			wrap = false,
			incremental = false,
		},
		label = {
			uppercase = false,
			before = true,
			after = true,
			reuse = "lowercase",
		},
		char = {
			enabled = false,
			autohide = true,
			jump_labels = false,
		},
		modes = {
			search = { enabled = true },
			char = { enabled = false },
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "x", "o" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				require("flash").toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
