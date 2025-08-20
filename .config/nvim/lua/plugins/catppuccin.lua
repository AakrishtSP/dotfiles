return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
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
			telescope = true,
			treesitter = true,
			which_key = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}
