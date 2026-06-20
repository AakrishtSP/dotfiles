return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = true,
	priority = 1000,
	opts = {
		flavour = "mocha",
		transparent_background = false,
		term_colors = true,
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
		},
		integrations = {
			blink_cmp = true,
			gitsigns = true,
			mason = true,
			native_lsp = { enabled = true },
			neotree = true,
			noice = true,
			treesitter = true,
			trouble = true,
			which_key = true,
			harpoon = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
	end,
}
