return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			typescriptreact = { "eslint" },
			jsx = { "eslint" },
			json = { "jsonlint" },
			yaml = { "yamllint" },
			rust = { "clippy" },
			c = { "clangtidy" },
			cpp = { "clangtidy" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
