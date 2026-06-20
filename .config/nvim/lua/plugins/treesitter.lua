return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = "VeryLazy",
	cmd = { "TSUpdate", "TSInstall" },
	opts = {
		ensure_installed = {
			"lua",
			"typescript",
			"javascript",
			"python",
			"rust",
			"c",
			"cpp",
			"zig",
			"bash",
			"html",
			"css",
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
			disable = { "python", "yaml" },
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				node_decremental = "<bs>",
			},
		},
	},
	config = function(_, opts)
		local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
		if not ok then
			return
		end
		ts_configs.setup(opts)
	end,
}
