return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {
			{
				mode = { "n", "v" },
				{ "<leader>c", group = "code/cmake" },
				{ "<leader>cc", group = "copilot chat" },
				{ "<leader>d", group = "debug" },
				{ "<leader>e", group = "explorer" },
				{ "<leader>g", group = "git" },
				{ "<leader>ge", group = "git explorer" },
				{ "<leader>s", group = "search/spectre" },
				{ "<leader>u", group = "update" },
				{ "<leader>x", group = "diagnostics" },
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps",
				},
			},
		},
	},
}
