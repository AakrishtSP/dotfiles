vim.cmd("set number")
vim.cmd("set expandtab")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set tabstop=4")
vim.g.mapleader = " "

-- Enhanced file type detection for git-related files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { 
        "*.gitignore", 
        ".gitignore*", 
        "gitignore", 
        ".gitattributes*", 
        "gitattributes",
        ".gitmodules*", 
        "gitmodules",
        ".dockerignore*", 
        "dockerignore",
        "*.ignore",
        ".ignore*"
    },
    callback = function(args)
        local filename = vim.fn.fnamemodify(args.file, ":t")
        if filename:match("gitignore") then
            vim.bo[args.buf].filetype = "gitignore"
        elseif filename:match("gitattributes") then
            vim.bo[args.buf].filetype = "gitattributes"  
        elseif filename:match("gitmodules") then
            vim.bo[args.buf].filetype = "gitmodules"
        elseif filename:match("dockerignore") then
            vim.bo[args.buf].filetype = "dockerignore"
        elseif filename:match("%.ignore") or filename == ".ignore" then
            vim.bo[args.buf].filetype = "ignore"
        end
    end,
})

-- Enhanced undo/redo configuration
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo" -- Set undo directory
vim.opt.undolevels = 10000 -- Maximum number of changes that can be undone
vim.opt.undoreload = 10000 -- Maximum number of lines to save for undo on buffer reload
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before overwriting
vim.opt.swapfile = false -- Disable swap files

-- Create undo directory if it doesn't exist
local undo_dir = vim.fn.stdpath("cache") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

-- Better editing experience
vim.opt.updatetime = 250 -- Faster completion
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence to complete

-- Cursor visibility settings - natural colors
vim.opt.guicursor = {
  "n-v-c:block", -- Normal, visual, command-line: block cursor
  "i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor (25% width)
  "r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor (20% height)
  "o:hor50", -- Operator-pending: horizontal bar cursor (50% height)
  "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blink settings
}

-- Additional cursor settings
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorcolumn = false -- Don't highlight current column (can be distracting)
vim.opt.ruler = true -- Show cursor position in status line
-- vim.opt.colorcolumn = "80" -- Show column guide at 80 characters

-- Performance monitoring
vim.api.nvim_create_user_command("StartupProfile", function()
  vim.cmd("Lazy profile")
end, { desc = "Show startup profile" })

vim.api.nvim_create_user_command("MemUsage", function()
  local mem = collectgarbage("count")
  print(string.format("Memory usage: %.2f MB", mem / 1024))
end, { desc = "Show memory usage" })

-- Comprehensive update command
vim.api.nvim_create_user_command("UpdateAll", function()
  local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO, { title = "UpdateAll" })
  end
  
  notify("🔄 Starting comprehensive update process...")
  
  -- Update Lazy plugins
  notify("📦 Updating Lazy plugins...")
  vim.cmd("Lazy sync")
  
  -- Wait a bit for Lazy to finish
  vim.defer_fn(function()
    -- Update Mason packages
    notify("🔧 Updating Mason packages...")
    vim.cmd("MasonUpdate")
    
    -- Update Mason tools
    vim.defer_fn(function()
      notify("🛠️  Installing/updating Mason tools...")
      vim.cmd("MasonToolsUpdate")
      
      -- Update Treesitter parsers
      vim.defer_fn(function()
        notify("🌳 Updating Treesitter parsers...")
        vim.cmd("TSUpdate")
        
        -- Final notification
        vim.defer_fn(function()
          notify("✅ All updates completed! Consider restarting Neovim.", vim.log.levels.WARN)
        end, 2000)
      end, 3000)
    end, 2000)
  end, 2000)
end, { 
  desc = "Update all plugins, LSP servers, formatters, and tools",
  bang = true 
})

-- Quick update commands for individual components
vim.api.nvim_create_user_command("UpdatePlugins", function()
  vim.notify("📦 Updating plugins...", vim.log.levels.INFO, { title = "UpdatePlugins" })
  vim.cmd("Lazy sync")
end, { desc = "Update Lazy plugins only" })

vim.api.nvim_create_user_command("UpdateMason", function()
  vim.notify("🔧 Updating Mason tools...", vim.log.levels.INFO, { title = "UpdateMason" })
  vim.cmd("MasonUpdate")
  vim.defer_fn(function()
    vim.cmd("MasonToolsUpdate")
  end, 1000)
end, { desc = "Update Mason and Mason tools" })

vim.api.nvim_create_user_command("UpdateTreesitter", function()
  vim.notify("🌳 Updating Treesitter parsers...", vim.log.levels.INFO, { title = "UpdateTreesitter" })
  vim.cmd("TSUpdate")
end, { desc = "Update Treesitter parsers" })

