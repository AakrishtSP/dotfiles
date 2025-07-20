return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "nvim-lua/plenary.nvim",
    },
    opts = function()
        local null_ls = require("null-ls")
        
        return {
            sources = {
                -- Formatting (reliable built-ins)
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.clang_format,

                -- Diagnostics from none-ls-extras (modern approach)
                require("none-ls.diagnostics.eslint"),
                require("none-ls.diagnostics.flake8"),

                -- Code actions from none-ls-extras
                require("none-ls.code_actions.eslint"),

                -- Completion
                null_ls.builtins.completion.spell.with({
                    filetypes = { "markdown", "text", "gitcommit" },
                }),
            },
        }
    end,
}
