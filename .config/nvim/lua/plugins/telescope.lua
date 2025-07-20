return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = vim.fn.executable("make") == 1,
            config = function()
                require("telescope").load_extension("fzf")
            end,
        },
        {
            "nvim-telescope/telescope-ui-select.nvim",
            config = function()
                require("telescope").load_extension("ui-select")
            end,
        },
        "nvim-tree/nvim-web-devicons",
    },
    opts = function()
        local actions = require("telescope.actions")
        
        -- Safe trouble integration
        local trouble_telescope = nil
        pcall(function()
            trouble_telescope = require("trouble.sources.telescope")
        end)
        
        return {
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                multi_icon = " ",
                path_display = { "truncate" },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_ignore_patterns = {
                    "^.git/",
                    "node_modules/",
                    "__pycache__/",
                    "%.pyc$",
                    "%.pyo$",
                    "%.o$",
                    "%.so$",
                    "%.dylib$",
                    "%.class$",
                    "%.jar$",
                    "%.war$",
                    "%.ear$",
                    "%.zip$",
                    "%.tar%.gz$",
                    "%.tar%.bz2$",
                    "%.rar$",
                    "%.7z$",
                    "%.jpg$",
                    "%.jpeg$",
                    "%.png$",
                    "%.gif$",
                    "%.bmp$",
                    "%.ico$",
                    "%.svg$",
                    "%.webp$",
                    "%.mp3$",
                    "%.mp4$",
                    "%.avi$",
                    "%.mov$",
                    "%.mkv$",
                    "%.wmv$",
                    "%.flv$",
                    "%.webm$",
                    "%.pdf$",
                    "%.doc$",
                    "%.docx$",
                    "%.xls$",
                    "%.xlsx$",
                    "%.ppt$",
                    "%.pptx$",
                },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-c>"] = actions.close,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,
                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<C-l>"] = actions.complete_tag,
                        ["<C-_>"] = actions.which_key,
                        ["<C-w>"] = { "<c-s-w>", type = "command" },
                        ["<C-s>"] = actions.cycle_previewers_next,
                        ["<C-a>"] = actions.cycle_previewers_prev,
                        ["<C-f>"] = actions.to_fuzzy_refine,
                        ["<C-h>"] = trouble_telescope and trouble_telescope.open or actions.send_to_qflist + actions.open_qflist,
                    },
                    n = {
                        ["<esc>"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["gg"] = actions.move_to_top,
                        ["G"] = actions.move_to_bottom,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<PageUp>"] = actions.results_scrolling_up,
                        ["<PageDown>"] = actions.results_scrolling_down,
                        ["?"] = actions.which_key,
                        ["<C-s>"] = actions.cycle_previewers_next,
                        ["<C-a>"] = actions.cycle_previewers_prev,
                        ["<C-h>"] = trouble_telescope and trouble_telescope.open or actions.send_to_qflist + actions.open_qflist,
                    },
                },
            },
            pickers = {
                find_files = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom",
                            preview_width = 0.6,
                            results_width = 0.4,
                        },
                        width = 0.9,
                        height = 0.8,
                    },
                    previewer = true,
                    hidden = true,
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
                git_files = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom",
                            preview_width = 0.6,
                            results_width = 0.4,
                        },
                        width = 0.9,
                        height = 0.8,
                    },
                    previewer = true,
                    show_untracked = true,
                },
                live_grep = {
                    additional_args = function(opts)
                        return {"--hidden"}
                    end,
                },
                grep_string = {
                    additional_args = function(opts)
                        return {"--hidden"}
                    end,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                        n = {
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                },
                planets = {
                    show_pluto = true,
                    show_moon = true,
                },
                colorscheme = {
                    enable_preview = true,
                },
                lsp_references = {
                    theme = "dropdown",
                    initial_mode = "normal",
                },
                lsp_definitions = {
                    theme = "dropdown",
                    initial_mode = "normal",
                },
                lsp_declarations = {
                    theme = "dropdown",
                    initial_mode = "normal",
                },
                lsp_implementations = {
                    theme = "dropdown",
                    initial_mode = "normal",
                },
                current_buffer_fuzzy_find = {
                    theme = "dropdown",
                    previewer = false,
                },
                diagnostics = {
                    theme = "ivy",
                    initial_mode = "normal",
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({
                        width = 0.5,
                        height = 0.4,
                        previewer = false,
                        prompt_title = false,
                        results_title = false,
                        layout_config = {
                            width = 0.5,
                            height = 0.4,
                        },
                    }),
                },
            },
        }
    end,
    keys = {
        -- File navigation
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
        { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>ft", "<cmd>Telescope filetypes<cr>", desc = "File Types" },
        { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Search" },
        
        -- Git
        { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
        { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
        { "<leader>gh", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
        
        -- LSP
        { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
        { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP Definitions" },
        { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP Implementations" },
        { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
        { "<leader>le", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        
        -- Search
        { "<leader>s\"", "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
        { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
        { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Search Select" },
        { "<leader>st", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word (root dir)" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "v", desc = "Selection (root dir)" },
        { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with preview" },
        
        -- Modern shortcuts (keeping your originals)
        { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<C-g>", "<cmd>Telescope git_files<cr>", desc = "Find Git Files" },
        { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
        { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer" },
        
        -- Quick access
        { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
        { "<leader>.", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },
    },
}
