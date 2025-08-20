return {
	-- Copilot completion - fast load on insert
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_enabled = true
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = false
			vim.g.copilot_tab_fallback = ""

			-- VSCode-like behavior: Tab for Copilot, Enter for LSP completion
			vim.keymap.set("i", "<Tab>", function()
				-- Priority 1: Copilot suggestion (like VSCode)
				if vim.fn["copilot#GetDisplayedSuggestion"]() ~= "" then
					return vim.api.nvim_replace_termcodes("<Plug>(copilot-accept)", true, true, true)
				end

				-- Priority 2: If blink menu is visible, select next item
				local blink_ok, blink = pcall(require, "blink.cmp")
				if blink_ok and blink.is_visible() then
					return blink.select_next()
				end

				-- Priority 3: Regular tab (indentation)
				return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
			end, { expr = true, replace_keycodes = true, desc = "VSCode Tab: Copilot > Next > Tab" })

			-- Alternative accept methods
			vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept)", { desc = "Accept Copilot suggestion" })
			vim.keymap.set("i", "<Down>", "<Plug>(copilot-next)")
			vim.keymap.set("i", "<Up>", "<Plug>(copilot-previous)")
			vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)")
			vim.keymap.set("i", "<C-f>", "<Plug>(copilot-accept-word)")
			vim.keymap.set("i", "<M-e>", "<Plug>(copilot-accept-line)")
		end,
	},

	-- CopilotChat - load only when needed
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		build = "make tiktoken",
		cmd = {
			"CopilotChat",
			"CopilotChatToggle",
			"CopilotChatExplain",
			"CopilotChatTests",
			"CopilotChatReview",
			"CopilotChatRefactor",
			"CopilotChatBetterNamings",
			"CopilotChatCommit",
			"CopilotChatCommitStaged",
			"CopilotChatFixDiagnostic",
			"CopilotChatReset",
			"CopilotChatModels",
		},
		keys = {
			{ "<leader>cct", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
			{
				"<leader>ccq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "Quick chat",
			},
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
			{ "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
			{ "<leader>ccf", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix Diagnostic" },
			{ "<leader>ccm", "<cmd>CopilotChatCommit<cr>", desc = "Generate commit message" },
		},
		opts = {
			question_header = "## User ",
			answer_header = "## Copilot ",
			auto_follow_cursor = false,
			show_help = false, -- Disable for faster startup
			mappings = {
				complete = { insert = "<Tab>" },
				close = { normal = "q", insert = "<C-c>" },
				reset = { normal = "<C-l>" },
				submit_prompt = { normal = "<CR>", insert = "<C-s>" },
				accept_diff = { normal = "<C-y>" },
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			opts.selection = require("CopilotChat.select").unnamed
			chat.setup(opts)

			-- Custom commands
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = require("CopilotChat.select").visual })
			end, { nargs = "*", range = true })

			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = require("CopilotChat.select").buffer })
			end, { nargs = "*" })
		end,
	},
}
