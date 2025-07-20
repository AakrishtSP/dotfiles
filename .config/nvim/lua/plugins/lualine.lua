return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
        "catppuccin/nvim",
    },
    opts = function()
        -- Icons configuration
        local icons = {
            git = {
                added = " ",
                modified = " ",
                removed = " ",
            },
            diagnostics = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
            },
            separators = {
                left = "",
                right = "",
            },
            powerline = {
                left = "",
                right = "",
            },
            noice = {
                command = "󰘳",
                search = "",
                message = "󰍩",
                mode = "",
            },
        }

        -- Custom components
        local function diff_source()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                }
            end
        end

        local function get_lsp_client()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return "No LSP"
            end
            
            local client_names = {}
            for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
            end
            return table.concat(client_names, ", ")
        end

        local function get_encoding()
            local encoding = vim.bo.fileencoding or vim.bo.encoding
            return encoding ~= "utf-8" and encoding:upper() or ""
        end

        local function get_fileformat()
            local format = vim.bo.fileformat
            return format ~= "unix" and format:upper() or ""
        end

        return {
            options = {
                theme = "catppuccin",
                globalstatus = true,
                disabled_filetypes = { 
                    statusline = { "dashboard", "alpha", "starter" },
                    winbar = { "help", "startify", "dashboard", "lazy", "neo-tree", "neogitstatus", "NvimTree", "Trouble", "alpha", "lir", "Outline", "spectre_panel", "toggleterm" },
                },
                component_separators = { left = "", right = "" },
                section_separators = { left = icons.powerline.left, right = icons.powerline.right },
                always_divide_middle = true,
                ignore_focus = {},
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        fmt = function(str)
                            return str:sub(1, 1)
                        end,
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        color = { gui = "bold" },
                    },
                    {
                        "diff",
                        source = diff_source,
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                        colored = true,
                        diff_color = {
                            added = { fg = "#98be65" },
                            modified = { fg = "#ECBE7B" },
                            removed = { fg = "#ec5f67" },
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = {
                            error = icons.diagnostics.error,
                            warn = icons.diagnostics.warn,
                            info = icons.diagnostics.info,
                            hint = icons.diagnostics.hint,
                        },
                        colored = true,
                        update_in_insert = false,
                        always_visible = false,
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        newfile_status = true,
                        path = 1, -- Relative path
                        shorting_target = 40,
                        symbols = {
                            modified = " ●",
                            readonly = " ",
                            unnamed = "[No Name]",
                            newfile = " ",
                        },
                    },
                    {
                        function()
                            local navic = require("nvim-navic")
                            return navic.get_location()
                        end,
                        cond = function()
                            local ok, navic = pcall(require, "nvim-navic")
                            return ok and navic.is_available()
                        end,
                        color = { fg = "#6c7086" },
                    },
                },
                lualine_x = {
                    -- Noice status components
                    {
                        function()
                            local ok, noice = pcall(require, "noice")
                            if not ok then return "" end
                            local status = require("noice.api").status
                            if status.command and status.command.has() then
                                return icons.noice.command .. " " .. status.command.get()
                            end
                            return ""
                        end,
                        color = { fg = "#fab387" },
                    },
                    {
                        function()
                            local ok, noice = pcall(require, "noice")
                            if not ok then return "" end
                            local status = require("noice.api").status
                            if status.search and status.search.has() then
                                return icons.noice.search .. " " .. status.search.get()
                            end
                            return ""
                        end,
                        color = { fg = "#a6e3a1" },
                    },
                    {
                        function()
                            local ok, dap = pcall(require, "dap")
                            if not ok then
                                return ""
                            end
                            local session = dap.session()
                            if session then
                                return " " .. (session.config.name or "Debug")
                            end
                            return ""
                        end,
                        color = { fg = "#f38ba8" },
                    },
                    {
                        "searchcount",
                        maxcount = 999,
                        timeout = 500,
                    },
                    {
                        get_lsp_client,
                        icon = " ",
                        color = { fg = "#94e2d5" },
                    },
                    {
                        get_encoding,
                        color = { fg = "#6c7086" },
                    },
                    {
                        get_fileformat,
                        color = { fg = "#6c7086" },
                    },
                    {
                        "filetype",
                        colored = true,
                        icon_only = false,
                        icon = { align = "right" },
                    },
                },
                lualine_y = {
                    {
                        "progress",
                        color = { gui = "bold" },
                    },
                    {
                        "selectioncount",
                        color = { fg = "#f9e2af" },
                    },
                },
                lualine_z = {
                    {
                        "location",
                        color = { gui = "bold" },
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        path = 1,
                        color = { fg = "#6c7086" },
                    },
                },
                lualine_x = {
                    {
                        "location",
                        color = { fg = "#6c7086" },
                    },
                },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {
                "neo-tree",
                "lazy",
                "toggleterm",
                "trouble",
                "mason",
                "nvim-dap-ui",
            },
        }
    end,
}
