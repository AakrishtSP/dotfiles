return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			enabled = vim.fn.executable("make") == 1,
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- Simple prompt
				prompt_prefix = "> ",
				selection_caret = " ",
				multi_icon = " ",
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				file_ignore_patterns = {
					"^.git/",
					"node_modules/",
					"__pycache__/",
					"%.pyc$",
					"%.so$",
				},

				-- Simple layout
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.5,
					},
					width = 0.8,
					height = 0.8,
				},

				-- Essential mappings only
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<Esc>"] = actions.close,
					},
					n = {
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["q"] = actions.close,
					},
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
				buffers = {
					theme = "dropdown",
					previewer = false,
					mappings = {
						i = { ["<C-d>"] = actions.delete_buffer },
						n = { ["dd"] = actions.delete_buffer },
					},
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- Load extensions
		if vim.fn.executable("make") == 1 then
			telescope.load_extension("fzf")
		end
	end,

	keys = {
		-- Essential file navigation
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },

		-- -- Git essentials
		-- { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		-- { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
		-- { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },

		-- LSP essentials
		{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
		{ "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
		{ "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },

		-- Quick access shortcuts
		{ "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<C-g>", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer" },
	},
}
