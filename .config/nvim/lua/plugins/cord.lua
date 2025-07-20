return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
        usercmds = true,
        log_level = "error",
        timer = {
            interval = 1500,
            reset_on_idle = false,
            reset_on_change = false,
        },
        editor = {
            image = nil,
            client = "neovim",
            tooltip = "The Superior Text Editor",
        },
        display = {
            show_time = true,
            show_repository = true,
            show_cursor_position = false,
            swap_fields = false,
            swap_icons = false,
            workspace_blacklist = {},
        },
        lsp = {
            show_problem_count = false,
            severity = 1,
            scope = "workspace",
        },
        idle = {
            enable = true,
            show_status = true,
            timeout = 300000, -- 5 minutes
            disable_on_focus = true,
            text = "Idling",
            tooltip = "💤",
        },
        text = {
            viewing = function(opts) return "Viewing " .. opts.filename end,
            editing = function(opts) return "Editing " .. opts.filename end,
            file_browser = function(opts) return "Browsing files in " .. (opts.workspace or "directory") end,
            plugin_manager = function(opts) return "Managing plugins in " .. (opts.workspace or "workspace") end,
            lsp_manager = function(opts) return "Configuring LSP in " .. (opts.workspace or "workspace") end,
            vcs = function(opts) return "Committing changes in " .. (opts.workspace or "repository") end,
            workspace = function(opts) return "In " .. (opts.workspace or "workspace") end,
        },
        buttons = {
            -- Disabled problematic button
            -- {
            --     label = "View Repository",
            --     url = "git",
            -- },
        },
        assets = {
            lazy = {
                name = "Lazy",
                icon = "https://github.com/folke/lazy.nvim/blob/main/docs/logo.png",
                tooltip = "Lazy Plugin Manager",
                type = 2,
            },
            ["cargo.toml"] = "rust",
            ["go.mod"] = "go",
            ["package.json"] = "nodejs",
            ["tsconfig.json"] = "typescript",
            ["deno.json"] = "deno",
            ["bun.lockb"] = "bun",
            ["requirements.txt"] = "python",
            ["pyproject.toml"] = "python",
            ["Pipfile"] = "python",
            ["composer.json"] = "php",
            ["Gemfile"] = "ruby",
            ["pom.xml"] = "java",
            ["build.gradle"] = "kotlin",
            ["mix.exs"] = "elixir",
            ["Dockerfile"] = "docker",
            ["docker-compose.yml"] = "docker",
            [".gitignore"] = "git",
            [".gitattributes"] = "git",
            ["makefile"] = "makefile",
            ["cmakelists.txt"] = "cmake",
            ["flake.nix"] = "nix",
            ["shell.nix"] = "nix",
        },
    },
    keys = {
        { 
            "<leader>dc", 
            function()
                if require("cord").is_connected() then
                    require("cord").disconnect()
                    vim.notify("Discord Rich Presence disconnected", vim.log.levels.INFO)
                else
                    require("cord").connect()
                    vim.notify("Discord Rich Presence connected", vim.log.levels.INFO)
                end
            end, 
            desc = "Discord: Toggle Rich Presence" 
        },
        { 
            "<leader>dr", 
            function()
                require("cord").disconnect()
                vim.defer_fn(function()
                    require("cord").connect()
                    vim.notify("Discord Rich Presence reconnected", vim.log.levels.INFO)
                end, 1000)
            end, 
            desc = "Discord: Reconnect" 
        },
        { 
            "<leader>ds", 
            function()
                local connected = require("cord").is_connected()
                local status = connected and "Connected" or "Disconnected"
                vim.notify("Discord Rich Presence: " .. status, vim.log.levels.INFO)
            end, 
            desc = "Discord: Status" 
        },
    },
    init = function()
        -- Auto-commands for better integration
        local cord_group = vim.api.nvim_create_augroup("CordIntegration", { clear = true })
        
        -- Update presence when entering different types of buffers
        vim.api.nvim_create_autocmd("FileType", {
            group = cord_group,
            pattern = { "lazy", "mason", "lspinfo", "checkhealth" },
            callback = function()
                -- Just trigger a simple presence update
                pcall(function()
                    require("cord")
                end)
            end,
        })
        
        -- Update presence for Git operations
        vim.api.nvim_create_autocmd("TermOpen", {
            group = cord_group,
            pattern = "*",
            callback = function()
                -- Safely update cord presence without using manager
                pcall(function()
                    require("cord")
                end)
            end,
        })
    end,
}
