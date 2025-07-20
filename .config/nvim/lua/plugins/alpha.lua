return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { 
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Custom ASCII art header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
      "    🚀 Blazingly Fast • 🎨 Beautiful • ⚡ Powerful   ",
      "                                                     ",
    }

    -- Menu buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
      dashboard.button("u", "  Update plugins", ":UpdateAll<CR>"),
      dashboard.button("l", "  Lazy", ":Lazy<CR>"),
      dashboard.button("m", "  Mason", ":Mason<CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }

    -- Footer with startup stats
    local function footer()
      local total_plugins = require("lazy").stats().count
      local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return "⚡ " .. total_plugins .. " plugins" .. nvim_version_info .. datetime
    end

    dashboard.section.footer.val = footer()

    -- Layout configuration
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Disable folding on alpha buffer
    dashboard.config.opts.noautocmd = true

    -- Setup alpha
    alpha.setup(dashboard.config)

    -- Auto-close alpha when opening file
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      desc = "Add Alpha dashboard",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ " .. stats.count .. " plugins loaded in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Don't show alpha on empty buffers when there are multiple windows
    vim.api.nvim_create_autocmd("BufWinEnter", {
      desc = "Hide alpha when opening file",
      pattern = "*",
      callback = function()
        if vim.fn.winnr("$") > 1 and vim.bo.filetype == "alpha" then
          vim.cmd("close")
        end
      end,
    })

    -- Custom highlight groups
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#a6e3a1" }) -- Green
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#cba6f7" })   -- Purple
    vim.api.nvim_set_hl(0, "AlphaHeaderLabel", { fg = "#fab387" }) -- Orange
    vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c7086" })   -- Gray
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })  -- Text
  end,
}
