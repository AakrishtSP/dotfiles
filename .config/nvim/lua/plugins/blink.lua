return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "rafamadriz/friendly-snippets",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = { 
            preset = "default",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },

        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            per_filetype = {
                lua = { "lsp", "path", "snippets", "buffer" },
                gitignore = { "path", "buffer" },
                gitattributes = { "path", "buffer" },
                gitmodules = { "path", "buffer" },
                gitconfig = { "path", "buffer" },
                dockerignore = { "path", "buffer" },
                ignore = { "path", "buffer" },
            },
        },

        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind" },
                    },
                },
                auto_show = true,
                border = "rounded",
                winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
                cycle = {
                    from_bottom = true,
                    from_top = true,
                },
            },
        },

        sources = {
            providers = {
                path = {
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(ctx) return vim.fn.expand(('#%d:p:h'):format(ctx.bufnr)) end,
                        show_hidden_files_by_default = true,
                    },
                },
            },
        },

        signature = { enabled = true },
        
        snippets = { preset = "luasnip" },
    },

    opts_extend = { "sources.default" },
}
