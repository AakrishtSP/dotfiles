return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cond = function()
    -- Only load noice if we're not in a minimal setup
    return not vim.g.vscode
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- Required for notification backend
  },
  opts = {
    -- Command line configuration
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Modern popup instead of bottom line
      opts = {}, 
      format = {
        -- Customize command line appearance with icons
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        input = { view = "cmdline_input", icon = "󰥻 " },
      },
    },
    
    -- Message handling
    messages = {
      enabled = true,
      view = "notify", -- Use our notify setup for messages
      view_error = "notify",
      view_warn = "notify", 
      view_history = "messages",
      view_search = "virtualtext", -- Show search count as virtual text
    },
    
    -- Popup menu (completion menu)
    popupmenu = {
      enabled = true,
      backend = "nui", -- Use nui for better styling
      kind_icons = {}, -- Use default icons
    },
    
    -- Notification system (replaces vim.notify)
    notify = {
      enabled = true,
      view = "notify",
    },
    lsp = {
      -- Override markdown rendering for better docs
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = false, -- We use blink.cmp
      },
      -- LSP progress
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30,
        view = "mini", -- Minimal progress indicator
      },
      -- Hover and signature help
      hover = {
        enabled = true,
        silent = false,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
      },
    },
    
    -- Health checks
    health = {
      checker = true,
    },
    
    -- Presets for easier configuration
    presets = {
      bottom_search = true, -- Use classic bottom cmdline for search
      command_palette = true, -- Position cmdline and popupmenu together
      long_message_to_split = true, -- Long messages will be sent to a split
      inc_rename = false, -- We don't use inc-rename
      lsp_doc_border = false, -- Add border to hover docs
    },
    
    -- Routes for message filtering and routing
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini", -- Show file info in corner
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true }, -- Skip "written" messages
      },
      -- Filter out search count messages we show as virtual text
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      -- Skip recording messages
      {
        filter = {
          event = "msg_show",
          find = "recording @",
        },
        opts = { skip = true },
      },
      -- Show mode changes in mini view
      {
        filter = {
          event = "msg_show",
          find = "-- INSERT --",
        },
        opts = { skip = true },
      },
      -- Route LSP progress to mini view
      {
        filter = {
          event = "lsp",
          kind = "progress",
        },
        view = "mini",
      },
      -- Show git messages in mini
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "git" },
            { find = "branch" },
            { find = "commit" },
          },
        },
        view = "mini",
      },
    },
    
    -- Views configuration
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      mini = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 2000,
        reverse = true,
        focusable = false,
        position = {
          row = -2,
          col = "100%",
          -- col = -2, -- uncomment for right side
        },
        size = "auto",
        border = {
          style = "none",
        },
        win_options = {
          winblend = 30,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            Search = "",
          },
        },
      },
      split = {
        backend = "split",
        enter = true,
        relative = "editor",
        position = "bottom",
        size = "20%",
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
      vsplit = {
        backend = "split",
        enter = true,
        relative = "editor", 
        position = "right",
        size = "50%",
      },
    },
  },
  keys = {
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect Cmdline",
    },
    {
      "<leader>snl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Noice Last Message",
    },
    {
      "<leader>snh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Noice History",
    },
    {
      "<leader>sna",
      function()
        require("noice").cmd("all")
      end,
      desc = "Noice All",
    },
    {
      "<leader>snd",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss All",
    },
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>nh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Notification History",
    },
    {
      "<leader>snt",
      function()
        require("noice").cmd("pick")
      end,
      desc = "Noice Picker (Telescope/FzfLua)",
    },
    {
      "<leader>sne",
      function()
        require("noice").cmd("errors")
      end,
      desc = "Noice Errors",
    },
    {
      "<leader>sns",
      function()
        require("noice").cmd("stats")
      end,
      desc = "Noice Stats",
    },
    {
      "<leader>snn",
      "<cmd>Noice disable<cr>",
      desc = "Disable Noice",
    },
    {
      "<leader>snN",
      "<cmd>Noice enable<cr>",
      desc = "Enable Noice",
    },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Forward",
      mode = { "i", "n", "s" },
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll Backward", 
      mode = { "i", "n", "s" },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
    
    -- Configure nvim-notify for noice backend
    require("notify").setup({
      render = "compact",
      stages = "fade", 
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      top_down = true,
      background_colour = "Normal",
      minimum_width = 50,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    })
    
    -- Integration with telescope for noice
    pcall(require("telescope").load_extension, "noice")
    
    -- Add custom commands for better workflow
    vim.api.nvim_create_user_command("NoiceClear", function()
      require("noice").cmd("dismiss")
      require("notify").dismiss({ silent = true, pending = true })
    end, { desc = "Clear all noice and notify messages" })
    
    vim.api.nvim_create_user_command("NoiceToggle", function()
      if require("noice.config").options.cmdline.enabled then
        require("noice").cmd("disable")
        vim.notify("Noice disabled", vim.log.levels.INFO)
      else
        require("noice").cmd("enable") 
        vim.notify("Noice enabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle noice on/off" })
  end,
}
