return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = function(colors)
            return {
                -- Enhanced cursor and selection - natural colors
                Cursor = { bg = colors.text, fg = colors.base },
                CursorLine = { bg = colors.surface0 },
                CursorColumn = { bg = colors.surface0 },
                Visual = { bg = colors.surface1, style = { "bold" } },
                
                -- Better diff colors
                DiffAdd = { bg = colors.green, fg = colors.base },
                DiffChange = { bg = colors.yellow, fg = colors.base },
                DiffDelete = { bg = colors.red, fg = colors.base },
                DiffText = { bg = colors.blue, fg = colors.base },
                
                -- Enhanced search highlighting
                Search = { bg = colors.yellow, fg = colors.base },
                IncSearch = { bg = colors.rosewater, fg = colors.base },
                CurSearch = { bg = colors.red, fg = colors.base },
                
                -- Better fold colors
                Folded = { bg = colors.surface0, fg = colors.overlay1 },
                FoldColumn = { bg = colors.base, fg = colors.surface2 },
                
                -- Enhanced diagnostic colors
                DiagnosticError = { fg = colors.red },
                DiagnosticWarn = { fg = colors.yellow },
                DiagnosticInfo = { fg = colors.sky },
                DiagnosticHint = { fg = colors.teal },
                DiagnosticOk = { fg = colors.green },
                
                -- Better popup menu
                Pmenu = { bg = colors.surface0, fg = colors.overlay2 },
                PmenuSel = { bg = colors.surface1, fg = colors.text },
                PmenuSbar = { bg = colors.surface1 },
                PmenuThumb = { bg = colors.overlay0 },
                
                -- Enhanced borders
                FloatBorder = { fg = colors.blue },
                NormalFloat = { bg = colors.mantle },
                
                -- Better tab line
                TabLine = { bg = colors.mantle, fg = colors.surface2 },
                TabLineSel = { bg = colors.surface0, fg = colors.text },
                TabLineFill = { bg = colors.crust },
                
                -- Enhanced UI elements
                WinSeparator = { fg = colors.surface2 },
                LineNr = { fg = colors.surface2 },
                CursorLineNr = { fg = colors.rosewater, style = { "bold" } },
                
                -- Enhanced LSP highlighting
                LspReferenceText = { bg = colors.surface1 },
                LspReferenceRead = { bg = colors.surface1 },
                LspReferenceWrite = { bg = colors.surface1 },
                
                -- Better telescope highlights
                TelescopeSelection = { bg = colors.surface1, fg = colors.text },
                TelescopeMultiSelection = { bg = colors.red, fg = colors.base },
                
                -- Enhanced completion menu
                CmpItemAbbrMatch = { fg = colors.yellow, style = { "bold" } },
                CmpItemAbbrMatchFuzzy = { fg = colors.yellow, style = { "bold" } },
                CmpItemKindSnippet = { fg = colors.rosewater },
                CmpItemKindKeyword = { fg = colors.mauve },
                CmpItemKindText = { fg = colors.teal },
                CmpItemKindMethod = { fg = colors.blue },
                CmpItemKindConstructor = { fg = colors.blue },
                CmpItemKindFunction = { fg = colors.blue },
                CmpItemKindFolder = { fg = colors.blue },
                CmpItemKindModule = { fg = colors.yellow },
                CmpItemKindConstant = { fg = colors.peach },
                CmpItemKindField = { fg = colors.blue },
                CmpItemKindProperty = { fg = colors.blue },
                CmpItemKindEnum = { fg = colors.yellow },
                CmpItemKindUnit = { fg = colors.yellow },
                CmpItemKindClass = { fg = colors.yellow },
                CmpItemKindVariable = { fg = colors.text },
                CmpItemKindFile = { fg = colors.blue },
                CmpItemKindInterface = { fg = colors.yellow },
                CmpItemKindColor = { fg = colors.rosewater },
                CmpItemKindReference = { fg = colors.rosewater },
                CmpItemKindEnumMember = { fg = colors.yellow },
                CmpItemKindStruct = { fg = colors.yellow },
                CmpItemKindValue = { fg = colors.peach },
                CmpItemKindEvent = { fg = colors.yellow },
                CmpItemKindOperator = { fg = colors.blue },
                CmpItemKindTypeParameter = { fg = colors.yellow },
                CmpItemKindCopilot = { fg = colors.overlay1 },
                CmpItemKindCodeium = { fg = colors.green },
                CmpItemKindTabNine = { fg = colors.red },
                
                -- Blink.cmp specific highlights
                BlinkCmpMenu = { bg = colors.surface0, fg = colors.overlay2 },
                BlinkCmpMenuBorder = { fg = colors.blue },
                BlinkCmpMenuSelection = { bg = colors.surface1, fg = colors.text },
                BlinkCmpScrollBarThumb = { bg = colors.overlay0 },
                BlinkCmpScrollBarGutter = { bg = colors.surface1 },
                BlinkCmpLabel = { fg = colors.text },
                BlinkCmpLabelDetail = { fg = colors.overlay1 },
                BlinkCmpLabelDescription = { fg = colors.overlay0 },
                BlinkCmpKind = { fg = colors.subtext1 },
                BlinkCmpSource = { fg = colors.overlay1 },
                BlinkCmpGhostText = { fg = colors.overlay1 },
                BlinkCmpDoc = { bg = colors.mantle },
                BlinkCmpDocBorder = { fg = colors.blue },
                BlinkCmpSignatureHelp = { bg = colors.mantle },
                BlinkCmpSignatureHelpBorder = { fg = colors.blue },
            }
        end,
        integrations = {
            alpha = true,
            barbecue = {
                dim_dirname = true,
                bold_basename = true,
                dim_context = false,
                alt_background = false,
            },
            blink_cmp = true,
            cmp = true,
            dap = true,
            dap_ui = true,
            dashboard = true,
            dropbar = {
                enabled = true,
                color_mode = false,
            },
            fidget = true,
            flash = true,
            gitsigns = true,
            harpoon = true,
            headlines = true,
            illuminate = {
                enabled = true,
                lsp = false,
            },
            indent_blankline = {
                enabled = true,
                scope_color = "",
                colored_indent_levels = false,
            },
            leap = true,
            lsp_trouble = true,
            mason = true,
            markdown = true,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            navic = {
                enabled = true,
                custom_bg = "NONE",
            },
            neotest = true,
            neotree = true,
            noice = true,
            notify = true,
            nvimtree = true,
            octo = true,
            overseer = true,
            rainbow_delimiters = true,
            render_markdown = true,
            sandwich = true,
            semantic_tokens = true,
            telescope = {
                enabled = true,
                style = "nvchad",
            },
            treesitter = true,
            treesitter_context = true,
            ufo = true,
            vim_sneak = true,
            vimwiki = true,
            which_key = true,
        },
    },
    init = function()
        vim.cmd.colorscheme("catppuccin")
    end,
    keys = {
        {
            "<leader>tt",
            function()
                local current = vim.g.catppuccin_flavour or "mocha"
                local flavours = { "latte", "frappe", "macchiato", "mocha" }
                local current_index = 1
                
                for i, flavour in ipairs(flavours) do
                    if flavour == current then
                        current_index = i
                        break
                    end
                end
                
                local next_index = (current_index % #flavours) + 1
                local next_flavour = flavours[next_index]
                
                require("catppuccin").setup({ flavour = next_flavour })
                vim.g.catppuccin_flavour = next_flavour
                vim.cmd.colorscheme("catppuccin")
                vim.notify("Switched to " .. next_flavour, vim.log.levels.INFO)
            end,
            desc = "Toggle Catppuccin Flavour",
        },
        {
            "<leader>tb",
            function()
                local current_bg = vim.o.background
                local new_bg = current_bg == "dark" and "light" or "dark"
                local new_flavour = new_bg == "dark" and "mocha" or "latte"
                
                vim.o.background = new_bg
                require("catppuccin").setup({ flavour = new_flavour })
                vim.g.catppuccin_flavour = new_flavour
                vim.cmd.colorscheme("catppuccin")
                vim.notify("Switched to " .. new_bg .. " mode", vim.log.levels.INFO)
            end,
            desc = "Toggle Background",
        },
    },
}
 
