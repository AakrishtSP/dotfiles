return {
	"rcarriga/nvim-notify",
	event = "VeryLazy", -- Load after startup for better performance
	config = function()
		local notify = require("notify")

		-- Configure nvim-notify
		notify.setup({
			-- Animation style (fade_in_slide_out, fade, slide, static)
			stages = "fade_in_slide_out",

			-- Timeout for notifications in milliseconds
			timeout = 3000,

			-- Background colour
			background_colour = "#000000",

			-- Icons for different log levels
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},

			-- Minimum log level to show
			level = "INFO",

			-- Maximum width of notification window
			max_width = 50,
			max_height = 10,

			-- Render function (default, minimal, simple, compact)
			render = "default",

			-- Top down or bottom up
			top_down = true,
		})

		-- Set nvim-notify as the default notification handler
		vim.notify = notify
	end,
}

-- Alternative minimal configuration:
--[[
return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify")
  end,
}
--]]
