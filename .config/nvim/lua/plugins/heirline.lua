return {
	"rebelot/heirline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lewis6991/gitsigns.nvim", -- for git integration
	},
	opts = function()
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Color palette inspired by VS Code
		local function get_highlight_safe(name)
			local hl = utils.get_highlight(name)
			return hl or {}
		end

		local colors = {
			bright_bg = get_highlight_safe("Folded").bg or "#3c3836",
			bright_fg = get_highlight_safe("Folded").fg or "#a89984",
			red = get_highlight_safe("DiagnosticError").fg or "#fb4934",
			dark_red = get_highlight_safe("DiffDelete").bg or "#cc241d",
			green = get_highlight_safe("String").fg or "#b8bb26",
			blue = get_highlight_safe("Function").fg or "#83a598",
			gray = get_highlight_safe("NonText").fg or "#928374",
			orange = get_highlight_safe("Constant").fg or "#fe8019",
			purple = get_highlight_safe("Statement").fg or "#d3869b",
			cyan = get_highlight_safe("Special").fg or "#8ec07c",
			diag_warn = get_highlight_safe("DiagnosticWarn").fg or "#fabd2f",
			diag_error = get_highlight_safe("DiagnosticError").fg or "#fb4934",
			diag_hint = get_highlight_safe("DiagnosticHint").fg or "#83a598",
			diag_info = get_highlight_safe("DiagnosticInfo").fg or "#8ec07c",
			git_del = get_highlight_safe("diffDeleted").fg or "#fb4934",
			git_add = get_highlight_safe("diffAdded").fg or "#b8bb26",
			git_change = get_highlight_safe("diffChanged").fg or "#fe8019",
		}

		-- Mode component with VS Code-like styling
		local ViMode = {
			init = function(self)
				self.mode = vim.fn.mode(1)
			end,
			static = {
				mode_names = {
					n = "NORMAL",
					no = "NORMAL",
					nov = "NORMAL",
					noV = "NORMAL",
					["no\22"] = "NORMAL",
					niI = "NORMAL",
					niR = "NORMAL",
					niV = "NORMAL",
					nt = "NORMAL",
					v = "VISUAL",
					vs = "VISUAL",
					V = "V-LINE",
					Vs = "V-LINE",
					["\22"] = "V-BLOCK",
					["\22s"] = "V-BLOCK",
					s = "SELECT",
					S = "S-LINE",
					["\19"] = "S-BLOCK",
					i = "INSERT",
					ic = "INSERT",
					ix = "INSERT",
					R = "REPLACE",
					Rc = "REPLACE",
					Rx = "REPLACE",
					Rv = "REPLACE",
					Rvc = "REPLACE",
					Rvx = "REPLACE",
					c = "COMMAND",
					cv = "Ex",
					r = "...",
					rm = "M",
					["r?"] = "?",
					["!"] = "!",
					t = "TERMINAL",
				},
				mode_colors = {
					n = "blue",
					i = "green",
					v = "cyan",
					V = "cyan",
					["\22"] = "cyan",
					c = "orange",
					s = "purple",
					S = "purple",
					["\19"] = "purple",
					R = "orange",
					r = "orange",
					["!"] = "red",
					t = "red",
				},
			},
			provider = function(self)
				return " %2(" .. self.mode_names[self.mode] .. "%) "
			end,
			hl = function(self)
				local mode = self.mode:sub(1, 1)
				return { fg = "black", bg = self.mode_colors[mode], bold = true }
			end,
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		-- File name component
		local FileName = {
			provider = function()
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
				if filename == "" then
					return "[No Name]"
				end
				return filename
			end,
			hl = { fg = "bright_fg" },
		}

		-- File icon component
		local FileIcon = {
			init = function(self)
				local filename = vim.api.nvim_buf_get_name(0)
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		-- Modified flag
		local FileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " ●",
				hl = { fg = "green" },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = " ",
				hl = { fg = "orange" },
			},
		}

		-- Git component
		local Git = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict or {}
				self.has_changes = (self.status_dict.added or 0) > 0
					or (self.status_dict.removed or 0) > 0
					or (self.status_dict.changed or 0) > 0
			end,
			hl = { fg = "orange" },
			{
				provider = function(self)
					return "  " .. (self.status_dict.head or "main") .. " "
				end,
				hl = { bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = "git_add" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = "git_del" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = "git_change" },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
			},
		}

		-- LSP diagnostics
		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = {
				error_icon = "",
				warn_icon = "",
				info_icon = "",
				hint_icon = "󰌶",
			},
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			{
				provider = function(self)
					return self.errors > 0 and (self.error_icon .. self.errors .. " ")
				end,
				hl = { fg = "diag_error" },
			},
			{
				provider = function(self)
					return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
				end,
				hl = { fg = "diag_warn" },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. " ")
				end,
				hl = { fg = "diag_info" },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = "diag_hint" },
			},
		}

		-- LSP server names
		local LSPActive = {
			condition = conditions.lsp_attached,
			update = { "LspAttach", "LspDetach" },
			provider = function()
				local names = {}
				for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					table.insert(names, server.name)
				end
				return "  " .. table.concat(names, " ") .. " "
			end,
			hl = { fg = "green", bold = true },
		}

		-- File type
		local FileType = {
			provider = function()
				return string.upper(vim.bo.filetype)
			end,
			hl = { fg = "bright_fg", bold = true },
		}

		-- Ruler (line:column)
		local Ruler = {
			provider = "%7(%l:%c%)",
		}

		-- Position percentage
		local Position = {
			provider = "%2p%%",
			hl = { fg = "bright_fg" },
		}

		-- Spacer component
		local Align = { provider = "%=" }
		local Space = { provider = " " }

		-- Left side of statusline
		local StatusLineLeft = {
			ViMode,
			Space,
			FileIcon,
			FileName,
			FileFlags,
			Space,
			Git,
		}

		-- Right side of statusline
		local StatusLineRight = {
			Diagnostics,
			Space,
			LSPActive,
			Space,
			FileType,
			Space,
			Ruler,
			Space,
			Position,
		}

		-- Complete statusline - single statusline for all windows
		local StatusLine = {
			StatusLineLeft,
			Align,
			StatusLineRight,
		}

		-- Return the configuration that will be passed to heirline.setup()
		return {
			statusline = StatusLine,
			opts = {
				colors = colors,
				disable_winbar = true,
			},
		}
	end,
	config = function(_, opts)
		local heirline = require("heirline")
		local utils = require("heirline.utils")

		-- Ensure global statusline (full width across all windows)
		vim.opt.laststatus = 3

		-- Setup heirline with the opts
		heirline.setup(opts)

		-- Auto-refresh colors when colorscheme changes
		vim.api.nvim_create_augroup("Heirline", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				utils.on_colorscheme(opts.opts.colors)
			end,
			group = "Heirline",
		})
	end,
}
