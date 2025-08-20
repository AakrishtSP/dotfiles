return {
	-- LSP configuration - lazy loaded
	{
		"neovim/nvim-lspconfig",
		event = "LspAttach", -- Only load when LSP actually attaches
		ft = { "lua", "python", "javascript", "typescript", "c", "cpp", "rust", "go" }, -- Load on specific filetypes
		dependencies = {
			{ "williamboman/mason.nvim", cmd = "Mason", opts = { ui = { border = "rounded" } } },
			{ "williamboman/mason-lspconfig.nvim", lazy = true },
		},
		keys = {
			{ "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
			{ "gr", vim.lsp.buf.references, desc = "References" },
			{ "K", vim.lsp.buf.hover, desc = "Hover" },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
			{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
		},
		config = function()
			-- Setup diagnostics
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			})

			-- Handlers with borders
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Server configs (only essentials)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				ts_ls = {},
				pyright = {},
			}

			-- Setup mason-lspconfig with auto-install
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" }, -- Only guarantee lua_ls for nvim config
				automatic_installation = true, -- Auto-install servers when opening files
				handlers = {
					function(server_name)
						if servers[server_name] then
							local config = vim.tbl_deep_extend("force", {
								capabilities = capabilities,
							}, servers[server_name])
							require("lspconfig")[server_name].setup(config)
						end
					end,
				},
			})

			-- Quick install command (fallback for manual installs)
			vim.api.nvim_create_user_command("LspInstall", function()
				local ft_servers = {
					lua = "lua_ls",
					javascript = "ts_ls",
					typescript = "ts_ls",
					python = "pyright",
					c = "clangd",
					cpp = "clangd",
					rust = "rust_analyzer",
					go = "gopls",
					html = "html",
					css = "cssls",
					json = "jsonls",
				}
				local server = ft_servers[vim.bo.filetype]
				if server then
					require("mason-lspconfig").install({ server })
					vim.notify("Installing " .. server)
				else
					vim.notify("No LSP for " .. vim.bo.filetype)
				end
			end, { desc = "Install LSP for current filetype" })
		end,
	},

	-- Fast formatting
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				desc = "Format",
			},
		},
		opts = {
			formatters_by_ft = {
				rust = { "rustfmt" },
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				c = { "clang_format" },
				cpp = { "clang_format" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		},
	},
}
