return {
    -- Tool installation
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "stylua", "prettier", "black", "isort", "eslint_d",
                "clang-format", "codelldb", "cmakelang", "cpptools",
                "debugpy", "js-debug-adapter", "typescript-language-server"
            },
            auto_update = false, -- Disable auto-update to improve startup
            run_on_start = false, -- Don't run on startup
        },
    },
    
    -- Package manager for LSP servers
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        opts = {
            ui = {
                border = "rounded",
                width = 0.8,
                height = 0.8,
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        },
    },
    
    -- Auto-install LSP servers
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            ensure_installed = { 
                "lua_ls", "ts_ls", "pyright", "clangd", "cmake",
                "bashls", "jsonls", "yamlls", "html", "cssls", "rust_analyzer"
            },
            automatic_installation = false, -- Disable for faster startup
        },
    },
    
    -- C++ enhancements
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp", "objc", "objcpp" },
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            inlay_hints = {
                inline = true,
                only_current_line = false,
                show_parameter_hints = true,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "=> ",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
                priority = 100,
            },
            ast = {
                role_icons = {
                    type = "🄣",
                    declaration = "🄓",
                    expression = "🄔",
                    statement = ";",
                    specifier = "🄢",
                    ["template argument"] = "🆃",
                },
                kind_icons = {
                    Compound = "🄲",
                    Recovery = "🅁",
                    TranslationUnit = "🄿",
                    PackExpansion = "🄿",
                    TemplateTypeParm = "🅃",
                    TemplateTemplateParm = "🅃",
                    TemplateParamObject = "🅃",
                },
            },
        },
    },
    
    -- Modern formatting with conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                cmake = { "cmakelang" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },
    
    -- Main LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        keys = {
            -- Navigation
            { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
            { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
            { "gr", vim.lsp.buf.references, desc = "Go to References" },
            { "gI", vim.lsp.buf.implementation, desc = "Go to Implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
            
            -- Information
            { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
            { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = { "n", "i" } },
            
            -- Actions
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
            { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action", mode = { "n", "v" } },
            
            -- Diagnostics
            { "<leader>e", vim.diagnostic.open_float, desc = "Show Line Diagnostics" },
            { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
            { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
            { "<leader>q", vim.diagnostic.setloclist, desc = "Diagnostics to Location List" },
            
            -- Workspace
            { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
            { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
            { 
                "<leader>wl", 
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, 
                desc = "List Workspace Folders" 
            },
            
            -- Inlay hints
            { 
                "<leader>ih", 
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
                end, 
                desc = "Toggle Inlay Hints" 
            },
        },
        opts = {
            -- Global LSP settings
            inlay_hints = { enabled = true },
            capabilities = {},
            format = { formatting_options = nil, timeout_ms = nil },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            workspace = { 
                                checkThirdParty = false,
                                library = {
                                    vim.env.VIMRUNTIME,
                                    "${3rd}/luv/library",
                                },
                            },
                            telemetry = { enable = false },
                            diagnostics = { 
                                globals = { "vim" },
                                disable = { "missing-fields" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                        },
                    },
                },
                
                ts_ls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },
                
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = "strict",
                                autoImportCompletions = true,
                                diagnosticSeverityOverrides = {
                                    reportUnusedImport = "information",
                                    reportUnusedVariable = "information",
                                },
                            },
                        },
                    },
                },
                
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                        "--cross-file-rename",
                        "--all-scopes-completion",
                        "--suggest-missing-includes",
                        "--enable-config",
                        "--offset-encoding=utf-16",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
                
                cmake = {
                    filetypes = { "cmake", "CMakeLists.txt" },
                },
                
                bashls = {},
                jsonls = {
                    on_new_config = function(new_config)
                        local ok, schemastore = pcall(require, "schemastore")
                        if ok then
                            new_config.settings.json.schemas = schemastore.json.schemas()
                        end
                    end,
                    settings = {
                        json = {
                            schemas = {},
                            validate = { enable = true },
                        },
                    },
                },
                yamlls = {
                    on_new_config = function(new_config)
                        local ok, schemastore = pcall(require, "schemastore")
                        if ok then
                            new_config.settings.yaml.schemas = schemastore.yaml.schemas()
                        end
                    end,
                    settings = {
                        yaml = {
                            schemaStore = {
                                enable = false,
                                url = "",
                            },
                            schemas = {},
                        },
                    },
                },
                html = {},
                cssls = {},
            },
            setup = {},
        },
        config = function(_, opts)
            -- Configure diagnostics
            vim.diagnostic.config({
                underline = true,
                update_in_insert = true, -- Enable diagnostics in insert mode
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- Only show errors and warnings in insert mode to reduce noise
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "✘",
                        [vim.diagnostic.severity.WARN] = "▲",
                        [vim.diagnostic.severity.HINT] = "⚑",
                        [vim.diagnostic.severity.INFO] = "»",
                    },
                },
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    max_width = 80,
                    max_height = 20,
                },
            })
            
            -- Enhanced LSP handlers
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    border = "rounded",
                    max_width = 80,
                    max_height = 20,
                }
            )
            
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help, {
                    border = "rounded",
                    max_width = 80,
                    max_height = 20,
                }
            )
            
            -- Enhanced on_attach function
            local function on_attach(client, bufnr)
                -- Enable inlay hints if supported
                if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
                
                -- Highlight references under cursor
                if client.supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = highlight_augroup })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end
            
            -- Get capabilities from completion engine
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            
            -- Setup servers through mason-lspconfig (prevents duplicates)
            local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
            if mason_lspconfig_ok then
                -- Use mason-lspconfig's setup method with handlers
                mason_lspconfig.setup({
                    handlers = {
                        -- Default handler for all servers
                        function(server_name)
                            local server_opts = opts.servers[server_name] or {}
                            server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
                            server_opts.on_attach = on_attach
                            require("lspconfig")[server_name].setup(server_opts)
                        end,
                    }
                })
            else
                -- Fallback: setup servers manually if mason-lspconfig fails
                local lspconfig = require("lspconfig")
                for server_name, server_opts in pairs(opts.servers) do
                    server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
                    server_opts.on_attach = on_attach
                    lspconfig[server_name].setup(server_opts)
                end
            end
        end,
    },
    
    -- Add schema store for enhanced JSON/YAML support
    {
        "b0o/schemastore.nvim",
        ft = { "json", "yaml" },
    },
}