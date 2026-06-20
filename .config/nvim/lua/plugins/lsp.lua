return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	ft = { "lua", "javascript", "typescript", "c", "cpp", "rust", "zig", "html", "css", "json", "yaml" },
	dependencies = {
		{ "williamboman/mason.nvim", cmd = "Mason", opts = { ui = { border = "rounded" } } },
		{ "williamboman/mason-lspconfig.nvim", lazy = true },
	},
	keys = {
		{ "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
		{ "gr", vim.lsp.buf.references, desc = "References" },
		{
			"K",
			function()
				vim.lsp.buf.hover({ border = "rounded" })
			end,
			desc = "Hover",
		},
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
		{ "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
		{ "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
		{
			"<leader>ih",
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
			end,
			desc = "Toggle Inlay Hints",
		},
	},
	config = function()
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			virtual_text = { spacing = 4, prefix = "●" },
			severity_sort = true,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		-- Auto-enable inlay hints when LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspInlayHints", {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
				end
			end,
		})

		vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment", italic = true })
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
			clangd = {},
			rust_analyzer = {},
			zls = {},
			html = {},
			cssls = {},
			jsonls = {},
			yamlls = {},
		}

		local ensure_installed = { "lua_ls", "clangd", "rust_analyzer", "zls" }

		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			automatic_installation = true,
			handlers = {
				function(server_name)
					if servers[server_name] then
						local config = vim.tbl_deep_extend("force", {
							capabilities = capabilities,
						}, servers[server_name])
						require("lspconfig")[server_name].setup(config)
					else
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end
				end,
			},
		})

		vim.api.nvim_create_user_command("LspInstall", function()
			local ft_servers = {
				lua = "lua_ls",
				javascript = "ts_ls",
				typescript = "ts_ls",
				c = "clangd",
				cpp = "clangd",
				rust = "rust_analyzer",
				zig = "zls",
				html = "html",
				css = "cssls",
				json = "jsonls",
				yaml = "yamlls",
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
}
