return {
    {
        "Civitasv/cmake-tools.nvim",
        ft = { "c", "cpp", "cmake" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            cmake_command = "cmake",
            cmake_build_directory = function()
                if vim.fn.has("win32") == 1 then
                    return "build"
                else
                    return "build"
                end
            end,
            cmake_build_directory_prefix = "",
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
            cmake_build_options = {},
            cmake_console_size = 10,
            cmake_console_position = "belowright",
            cmake_show_console = "always",
            cmake_dap_configuration = {
                name = "CMake Auto Debug",
                type = "codelldb",
                request = "launch",
                program = function()
                    local cmake = require("cmake-tools")
                    
                    -- First try to get CMake launch target
                    local target = cmake.get_launch_target()
                    if target and target ~= "" and vim.fn.filereadable(target) == 1 then
                        return target
                    end
                    
                    -- Fallback: find executable in build directory
                    local build_dir = cmake.get_build_directory() or "build"
                    local executables = vim.fn.glob(build_dir .. "/**/*", false, true)
                    
                    for _, file in ipairs(executables) do
                        if vim.fn.executable(file) == 1 and 
                           not file:match("%.so$") and 
                           not file:match("%.a$") and 
                           not file:match("%.dylib$") and
                           not file:match("/CMakeFiles/") then
                            return file
                        end
                    end
                    
                    -- Last resort: prompt user
                    return vim.fn.input("Path to executable: ", build_dir .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                runInTerminal = false,
                args = {},  -- No arguments by default
                env = function()
                    local variables = {}
                    for k, v in pairs(vim.fn.environ()) do
                        variables[k] = v
                    end
                    return variables
                end,
            },
            cmake_executor = {
                name = "quickfix",
                opts = {},
                default_opts = {
                    quickfix = {
                        show = "always",
                        position = "belowright",
                        size = 10,
                        encoding = "utf-8",
                        auto_close_when_success = true,
                    },
                    toggleterm = {
                        direction = "float",
                        close_on_exit = false,
                        auto_scroll = true,
                    },
                    overseer = {
                        new_task_opts = {
                            strategy = {
                                "toggleterm",
                                direction = "horizontal",
                                autos_croll = true,
                                quit_on_exit = "success"
                            }
                        },
                    },
                    terminal = {
                        name = "Main Terminal",
                        prefix_name = "[CMakeTools]: ",
                        split_direction = "horizontal",
                        split_size = 11,
                    },
                },
            },
            cmake_runner = {
                name = "terminal",
                opts = {},
                default_opts = {
                    quickfix = {
                        show = "only_on_error",
                        position = "belowright",
                        size = 10,
                        encoding = "utf-8",
                        auto_close_when_success = true,
                    },
                    toggleterm = {
                        direction = "float",
                        close_on_exit = true,
                        auto_scroll = true,
                    },
                    overseer = {
                        new_task_opts = {
                            strategy = {
                                "toggleterm",
                                direction = "horizontal",
                                auto_scroll = true,
                                quit_on_exit = "success"
                            }
                        },
                    },
                    terminal = {
                        name = "Main Terminal",
                        prefix_name = "[CMakeTools]: ",
                        split_direction = "horizontal",
                        split_size = 11,
                    },
                },
            },
            cmake_notifications = {
                runner = { enabled = true },
                executor = { enabled = true },
                spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            },
            cmake_virtual_text_support = true,
            cmake_soft_link_compile_commands = true,
            cmake_compile_commands_from_lsp = false,
            cmake_kits_path = nil,
            cmake_variants_message = {
                short = { show = true },
                long = { show = true, max_length = 40 },
            },
        },
        keys = {
            -- Core CMake operations
            { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake: Generate" },
            { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake: Build" },
            { "<leader>cr", "<cmd>CMakeRun<cr>", desc = "CMake: Run" },
            { "<leader>cR", function()
                -- Build and run
                vim.cmd("CMakeBuild")
                vim.defer_fn(function()
                    if vim.v.shell_error == 0 then
                        vim.cmd("CMakeRun")
                    else
                        vim.notify("Build failed, cannot run", vim.log.levels.ERROR)
                    end
                end, 1000)
            end, desc = "CMake: Build & Run" },
            { "<leader>cd", function()
                -- Debug with auto DAP UI opening
                local dapui = require("dapui")
                dapui.open()
                vim.cmd("CMakeDebug")
            end, desc = "CMake: Debug" },
            { "<leader>cD", function()
                -- Build and debug with auto DAP UI opening
                vim.cmd("CMakeBuild")
                vim.defer_fn(function()
                    if vim.v.shell_error == 0 then
                        local dapui = require("dapui")
                        dapui.open()
                        vim.cmd("CMakeDebug")
                    else
                        vim.notify("Build failed, cannot debug", vim.log.levels.ERROR)
                    end
                end, 1000)
            end, desc = "CMake: Build & Debug" },
            { "<leader>cl", "<cmd>CMakeLaunchArgs<cr>", desc = "CMake: Launch Args" },
            
            -- Target management
            { "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake: Select Build Target" },
            { "<leader>cT", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake: Select Launch Target" },
            
            -- Build configuration
            { "<leader>cB", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake: Select Build Type" },
            { "<leader>ck", "<cmd>CMakeSelectKit<cr>", desc = "CMake: Select Kit" },
            { "<leader>cv", "<cmd>CMakeSelectConfigurePreset<cr>", desc = "CMake: Select Configure Preset" },
            { "<leader>cV", "<cmd>CMakeSelectBuildPreset<cr>", desc = "CMake: Select Build Preset" },
            
            -- Cleaning and maintenance
            { "<leader>cc", "<cmd>CMakeClean<cr>", desc = "CMake: Clean" },
            { "<leader>cC", "<cmd>CMakeClose<cr>", desc = "CMake: Close Console" },
            { "<leader>cx", "<cmd>CMakeStop<cr>", desc = "CMake: Stop" },
            
            -- Information and settings
            { "<leader>ci", "<cmd>CMakeInfo<cr>", desc = "CMake: Info" },
            { "<leader>cs", "<cmd>CMakeSettings<cr>", desc = "CMake: Settings" },
            { "<leader>co", "<cmd>CMakeOpen<cr>", desc = "CMake: Open Console" },
            
            -- Quick actions
            { "<leader>cq", "<cmd>CMakeQuickBuild<cr>", desc = "CMake: Quick Build" },
            { "<leader>cQ", "<cmd>CMakeQuickRun<cr>", desc = "CMake: Quick Run" },
            { "<leader>cE", "<cmd>CMakeQuickDebug<cr>", desc = "CMake: Quick Debug" },
            
            -- Advanced
            { "<leader>cw", "<cmd>CMakeSelectCwd<cr>", desc = "CMake: Select Working Directory" },
            { "<leader>cm", "<cmd>CMakeShowTargetFiles<cr>", desc = "CMake: Show Target Files" },
        },
        config = function(_, opts)
            require("cmake-tools").setup(opts)
            
            -- Auto-commands for CMake integration
            local cmake_group = vim.api.nvim_create_augroup("CMakeTools", { clear = true })
            
            -- Auto-generate on CMakeCache.txt change
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = cmake_group,
                pattern = "CMakeCache.txt",
                callback = function()
                    vim.notify("CMakeCache.txt changed, consider regenerating", vim.log.levels.INFO)
                end,
            })
            
            -- Auto-set build type based on git branch
            vim.api.nvim_create_autocmd("User", {
                group = cmake_group,
                pattern = "CMakeGenerate",
                callback = function()
                    local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
                    if branch:match("debug") or branch:match("dev") then
                        vim.notify("Debug branch detected, using Debug build type", vim.log.levels.INFO)
                    elseif branch:match("release") or branch:match("main") or branch:match("master") then
                        vim.notify("Release branch detected, consider Release build type", vim.log.levels.INFO)
                    end
                end,
            })
            
            -- Statusline integration
            vim.api.nvim_create_user_command("CMakeStatus", function()
                local cmake = require("cmake-tools")
                local status = cmake.get_build_type() or "None"
                local target = cmake.get_build_target() or "None"
                local launch_target = cmake.get_launch_target() or "None"
                local kit = cmake.get_kit() or "None"
                local build_dir = cmake.get_build_directory() or "None"
                
                print("CMake Status:")
                print("  Build Type: " .. status)
                print("  Build Target: " .. target)
                print("  Launch Target: " .. launch_target)
                print("  Kit: " .. kit)
                print("  Build Directory: " .. build_dir)
            end, { desc = "Show CMake status" })
            
            -- Utility commands for debugging
            vim.api.nvim_create_user_command("CMakeDebugTarget", function(opts)
                local cmake = require("cmake-tools")
                if opts.args and opts.args ~= "" then
                    -- Set the target if provided
                    cmake.select_launch_target(opts.args)
                end
                vim.cmd("CMakeDebug")
            end, { 
                desc = "Debug specific CMake target",
                nargs = "?",
                complete = function()
                    local cmake = require("cmake-tools")
                    return cmake.get_targets() or {}
                end,
            })
            
            vim.api.nvim_create_user_command("CMakeBuildAndDebug", function()
                vim.cmd("CMakeBuild")
                vim.defer_fn(function()
                    if vim.v.shell_error == 0 then
                        local dapui = require("dapui")
                        dapui.open()
                        vim.cmd("CMakeDebug")
                    else
                        vim.notify("Build failed, cannot debug", vim.log.levels.ERROR)
                    end
                end, 1000)
            end, { desc = "Build and debug CMake project with DAP UI" })
        end,
    },
    
    -- CMake language support
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = {
            servers = {
                cmake = {
                    filetypes = { "cmake" },
                    init_options = {
                        buildDirectory = "build",
                    },
                },
            },
        },
    },
    
    -- Enhanced CMake syntax
    {
        "peterhoeg/vim-qml",
        ft = { "qml" },
        enabled = function()
            return vim.fn.executable("qmake") == 1
        end,
    },
    
    -- CMake integration with nvim-dap
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function(_, opts)
            -- Ensure configurations table exists
            opts.configurations = opts.configurations or {}
            opts.configurations.cpp = opts.configurations.cpp or {}
            opts.configurations.c = opts.configurations.c or {}
            
            -- Add CMake-specific debug configurations that integrate with cmake-tools
            local cmake_configs = {
                {
                    name = "CMake: Auto Debug (No Args)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local cmake_tools = require("cmake-tools")
                        
                        -- First try CMake launch target
                        local target = cmake_tools.get_launch_target()
                        if target and target ~= "" and vim.fn.filereadable(target) == 1 then
                            return target
                        end
                        
                        -- Find executable in build directory
                        local build_dir = cmake_tools.get_build_directory() or "build"
                        local executables = vim.fn.glob(build_dir .. "/**/*", false, true)
                        
                        for _, file in ipairs(executables) do
                            if vim.fn.executable(file) == 1 and 
                               not file:match("%.so$") and 
                               not file:match("%.a$") and 
                               not file:match("%.dylib$") and
                               not file:match("/CMakeFiles/") then
                                return file
                            end
                        end
                        
                        return vim.fn.input("Path to executable: ", build_dir .. "/", "file")
                    end,
                    cwd = function()
                        local cmake_tools = require("cmake-tools")
                        return cmake_tools.get_build_directory() or "${workspaceFolder}"
                    end,
                    stopOnEntry = false,
                    args = {},  -- No arguments by default
                    runInTerminal = false,
                    sourceLanguages = { "cpp", "c" },
                },
                {
                    name = "CMake: Debug with Args",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local cmake_tools = require("cmake-tools")
                        local target = cmake_tools.get_launch_target()
                        if target and target ~= "" then
                            return target
                        end
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    end,
                    cwd = function()
                        local cmake_tools = require("cmake-tools")
                        return cmake_tools.get_build_directory() or "${workspaceFolder}"
                    end,
                    stopOnEntry = false,
                    args = function()
                        local cmake_tools = require("cmake-tools")
                        local args = cmake_tools.get_launch_args()
                        if args and #args > 0 then
                            return args
                        end
                        local input = vim.fn.input("Arguments: ")
                        return input ~= "" and vim.split(input, " ", { trimempty = true }) or {}
                    end,
                    runInTerminal = false,
                    sourceLanguages = { "cpp", "c" },
                },
                {
                    name = "CMake: Attach to Process (codelldb)",
                    type = "codelldb",
                    request = "attach",
                    pid = function()
                        return require("dap.utils").pick_process()
                    end,
                    args = {},
                    cwd = "${workspaceFolder}",
                },
            }
            
            -- Add configurations to both C and C++
            vim.list_extend(opts.configurations.cpp, cmake_configs)
            vim.list_extend(opts.configurations.c, cmake_configs)
            
            return opts
        end,
    },
}
