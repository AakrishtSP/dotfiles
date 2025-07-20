return {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
        { "<leader>gc", "<cmd>LazyGitConfig<cr>", desc = "LazyGit Config" },
        { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
        { "<leader>gF", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit Filter Current File" },
        
        -- Quick Git operations
        { 
            "<leader>ga", 
            function()
                vim.cmd("silent !git add %")
                vim.notify("Staged current file", vim.log.levels.INFO)
            end, 
            desc = "Git Add Current File" 
        },
        { 
            "<leader>gA", 
            function()
                vim.cmd("silent !git add -A")
                vim.notify("Staged all files", vim.log.levels.INFO)
            end, 
            desc = "Git Add All" 
        },
        { 
            "<leader>gr", 
            function()
                vim.cmd("silent !git reset HEAD %")
                vim.notify("Unstaged current file", vim.log.levels.INFO)
            end, 
            desc = "Git Reset Current File" 
        },
        { 
            "<leader>gR", 
            function()
                vim.cmd("silent !git reset HEAD")
                vim.notify("Unstaged all files", vim.log.levels.INFO)
            end, 
            desc = "Git Reset All" 
        },
        { 
            "<leader>gm", 
            function()
                local message = vim.fn.input("Commit message: ")
                if message ~= "" then
                    vim.cmd("silent !git commit -m '" .. message .. "'")
                    vim.notify("Committed: " .. message, vim.log.levels.INFO)
                end
            end, 
            desc = "Quick Git Commit" 
        },
        { 
            "<leader>gn", 
            function()
                local branch = vim.fn.input("New branch name: ")
                if branch ~= "" then
                    vim.cmd("silent !git checkout -b " .. branch)
                    vim.notify("Created and switched to branch: " .. branch, vim.log.levels.INFO)
                end
            end, 
            desc = "Create New Branch" 
        },
        { 
            "<leader>gw", 
            function()
                local handle = io.popen("git branch --show-current")
                if handle then
                    local branch = handle:read("*a"):gsub("%s+", "")
                    handle:close()
                    vim.notify("Current branch: " .. branch, vim.log.levels.INFO)
                end
            end, 
            desc = "Show Current Branch" 
        },
        { 
            "<leader>gd", 
            function()
                local filename = vim.fn.expand("%")
                if filename ~= "" then
                    vim.cmd("split")
                    vim.cmd("terminal git diff " .. filename)
                    vim.cmd("startinsert")
                else
                    vim.notify("No file to diff", vim.log.levels.WARN)
                end
            end, 
            desc = "Git Diff Current File" 
        },
    },
    init = function()
        -- LazyGit configuration
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_floating_window_border_chars = { "╭", "╮", "╰", "╯" }
        vim.g.lazygit_floating_window_use_plenary = 1
        vim.g.lazygit_use_neovim_remote = 1
        vim.g.lazygit_use_custom_config_file_path = 0
        
        -- Auto-refresh buffers after LazyGit operations
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyGitEnterBuffer",
            callback = function()
                vim.cmd("checktime")
            end,
        })
    end,
}
