return {
	"romgrk/barbar.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	keys = {
		-- Tab navigation
		{ "<A-,>", "<Cmd>BufferPrevious<CR>", desc = "Buffer: Previous" },
		{ "<A-.>", "<Cmd>BufferNext<CR>", desc = "Buffer: Next" },

		-- Re-order to previous/next
		{ "<A-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Buffer: Move Previous" },
		{ "<A->>", "<Cmd>BufferMoveNext<CR>", desc = "Buffer: Move Next" },

		-- Goto buffer in position...
		{ "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "Buffer: Goto 1" },
		{ "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "Buffer: Goto 2" },
		{ "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "Buffer: Goto 3" },
		{ "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "Buffer: Goto 4" },
		{ "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "Buffer: Goto 5" },
		{ "<A-6>", "<Cmd>BufferGoto 6<CR>", desc = "Buffer: Goto 6" },
		{ "<A-7>", "<Cmd>BufferGoto 7<CR>", desc = "Buffer: Goto 7" },
		{ "<A-8>", "<Cmd>BufferGoto 8<CR>", desc = "Buffer: Goto 8" },
		{ "<A-9>", "<Cmd>BufferGoto 9<CR>", desc = "Buffer: Goto 9" },
		{ "<A-0>", "<Cmd>BufferLast<CR>", desc = "Buffer: Goto Last" },

		-- Pin/unpin buffer
		{ "<A-p>", "<Cmd>BufferPin<CR>", desc = "Buffer: Toggle Pin" },

		-- Close buffer
		{ "<A-c>", "<Cmd>BufferClose<CR>", desc = "Buffer: Close" },
		{ "<A-C>", "<Cmd>BufferClose!<CR>", desc = "Buffer: Close (Force)" },

		-- Close commands
		-- { "<C-p>", "<Cmd>BufferPick<CR>", desc = "Buffer: Pick" },
		{ "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "Buffer: Order by Number" },
		{ "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", desc = "Buffer: Order by Directory" },
		{ "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", desc = "Buffer: Order by Language" },
		{ "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "Buffer: Order by Window" },

		-- Close all but current or pinned
		{ "<leader>bc", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "Buffer: Close All But Current" },
		{ "<leader>bC", "<Cmd>BufferCloseAllButPinned<CR>", desc = "Buffer: Close All But Pinned" },
		{ "<leader>bl", "<Cmd>BufferCloseBuffersLeft<CR>", desc = "Buffer: Close All Left" },
		{ "<leader>br", "<Cmd>BufferCloseBuffersRight<CR>", desc = "Buffer: Close All Right" },
	},
	opts = {
		-- Enable/disable animations
		animation = true,

		-- Enable/disable auto-hiding the tab bar when there is a single buffer
		auto_hide = false,

		-- Enable/disable current/total tabpages indicator (top right corner)
		tabpages = true,

		-- Enables/disable clickable tabs
		clickable = true,

		-- Excludes buffers from the tabline
		exclude_ft = { "javascript" },
		exclude_name = { "package.json" },

		-- A buffer to this direction will be focused (if it exists) when closing the current buffer.
		focus_on_close = "left",

		-- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
		hide = { extensions = true, inactive = false },

		-- Disable highlighting alternate buffers
		highlight_alternate = false,

		-- Disable highlighting file icons in inactive buffers
		highlight_inactive_file_icons = false,

		-- Enable highlighting visible buffers
		highlight_visible = true,

		-- Enable/disable icons
		icons = {
			-- Configure the base icons on the bufferline.
			buffer_index = false,
			buffer_number = false,
			button = "",
			-- Enables / disables diagnostic symbols
			diagnostics = {
				[vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅚 " },
				[vim.diagnostic.severity.WARN] = { enabled = false },
				[vim.diagnostic.severity.INFO] = { enabled = false },
				[vim.diagnostic.severity.HINT] = { enabled = true },
			},
			gitsigns = {
				added = { enabled = true, icon = "+" },
				changed = { enabled = true, icon = "~" },
				deleted = { enabled = true, icon = "-" },
			},
			filetype = {
				-- Sets the icon's highlight group.
				custom_colors = false,
				-- Requires `nvim-web-devicons`
				enabled = true,
			},
			separator = { left = "▎", right = "" },
			-- If true, add an additional separator at the end of the buffer list
			separator_at_end = true,
			-- Configure the icons on the bufferline when modified or pinned.
			modified = { button = "●" },
			pinned = { button = "", filename = true },
			-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
			preset = "default",
			-- Configure the icons on the bufferline based on the visibility of a buffer.
			alternate = { filetype = { enabled = false } },
			current = { buffer_index = true },
			inactive = { button = "×" },
			visible = { modified = { buffer_number = false } },
		},

		-- If true, new buffers will be inserted at the start/end of the list.
		insert_at_end = false,
		insert_at_start = false,

		-- Sets the maximum padding width with which to surround each tab
		maximum_padding = 1,

		-- Sets the minimum padding width with which to surround each tab
		minimum_padding = 1,

		-- Sets the maximum buffer name length.
		maximum_length = 30,

		-- Sets the minimum buffer name length.
		minimum_length = 0,

		-- If set, the letters for each buffer in buffer-pick mode will be
		-- assigned based on their name. Otherwise or in case all letters are
		-- already assigned, the behavior is to assign letters in order of
		-- usability (see order below)
		semantic_letters = true,

		-- Set the filetypes which barbar will offset itself for
		sidebar_filetypes = {
			-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
			NvimTree = true,
			-- Or, specify the event
			undotree = {
				text = "undotree",
				align = "center", -- *optionally* specify an alignment (either 'left', 'center', or 'right')
			},
			-- Or, specify the event and the command
			["neo-tree"] = { event = "BufWipeout" },
		},

		-- New buffer letters are assigned in this order. This order is
		-- optimal for the qwerty keyboard layout.
		letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

		-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
		-- where X is the buffer number. But only a static string is accepted here.
		no_name_title = nil,
	},
	version = "^1.0.0",
}
