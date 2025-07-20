return {
    -- Core DAP plugin
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { "<F5>", function() 
                -- Enhanced F5 - auto-open DAP UI and continue
                local dapui = require("dapui")
                dapui.open()
                require("dap").continue() 
            end, desc = "Debug: Start/Continue (Auto + DAP UI)" },
            { "<F6>", function() require("dap").pause() end, desc = "Debug: Pause" },
            { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
            { "<leader>dB", function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, desc = "Debug: Conditional Breakpoint" },
            { "<leader>dL", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end, desc = "Debug: Log Point" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
            { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug: Hover Variables", mode = { "n", "v" } },
            { "<leader>ds", function() require("dap.ui.widgets").scopes() end, desc = "Debug: Scopes" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
            { "<leader>dR", function() require("dap").restart() end, desc = "Debug: Restart" },
            { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "Debug: Clear Breakpoints" },
            
            -- CMake + DAP integration keymaps
            { "<leader>dc", function()
                -- Quick CMake build and debug with DAP UI
                vim.cmd("CMakeBuildAndDebug")
            end, desc = "CMake: Build & Debug (Auto + DAP UI)" },
            { "<leader>dd", function()
                -- Debug and run with DAP UI (continues if already debugging)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.open()
                if dap.session() then
                    dap.continue()
                else
                    vim.cmd("CMakeDebug")
                end
            end, desc = "CMake: Debug & Run" },
            { "<leader>dA", function()
                -- Auto debug without building (finds executable automatically)
                local dapui = require("dapui")
                dapui.open()
                vim.cmd("CMakeDebug")
            end, desc = "CMake: Auto Debug (No Build)" },
            { "<leader>dT", function()
                -- Select CMake target and debug
                vim.cmd("CMakeSelectLaunchTarget")
                vim.defer_fn(function()
                    local dapui = require("dapui")
                    dapui.open()
                    vim.cmd("CMakeDebug")
                end, 500)
            end, desc = "CMake: Select Target & Debug" },
            { "<leader>do", function()
                -- Quick shortcut to CMake debug options
                local choice = vim.fn.confirm("CMake Debug Options:", 
                    "&1. Debug (Auto)\n&2. Build & Debug\n&3. Debug with Args\n&4. Select Target & Debug\n&5. Cancel", 
                    1)
                local dapui = require("dapui")
                
                if choice == 1 then
                    dapui.open()
                    vim.cmd("CMakeDebug")
                elseif choice == 2 then
                    vim.cmd("CMakeBuildAndDebug")
                elseif choice == 3 then
                    local args = vim.fn.input("Launch args: ")
                    if args ~= "" then
                        vim.cmd("CMakeLaunchArgs " .. args)
                    end
                    dapui.open()
                    vim.cmd("CMakeDebug")
                elseif choice == 4 then
                    vim.cmd("CMakeSelectLaunchTarget")
                    vim.defer_fn(function()
                        dapui.open()
                        vim.cmd("CMakeDebug")
                    end, 500)
                end
            end, desc = "CMake: Debug Options Menu" },
        },
        config = function()
            local dap = require("dap")
            
            -- Sign configuration
            local signs = {
                DapBreakpoint = { text = "🔴", texthl = "DapBreakpoint" },
                DapBreakpointCondition = { text = "🟡", texthl = "DapBreakpointCondition" },
                DapLogPoint = { text = "🔵", texthl = "DapLogPoint" },
                DapStopped = { text = "▶️", texthl = "DapStopped", linehl = "DapStoppedLine" },
                DapBreakpointRejected = { text = "🚫", texthl = "DapBreakpointRejected" },
            }
            
            for name, opts in pairs(signs) do
                vim.fn.sign_define(name, opts)
            end
            
            -- Adapter configurations
            dap.adapters.codelldb = {
                type = 'server',
                port = "${port}",
                executable = {
                    command = vim.fn.exepath('codelldb'),
                    args = {"--port", "${port}"},
                }
            }
            
            -- Basic C/C++ configurations (will be enhanced by cmake-tools)
            dap.configurations.cpp = dap.configurations.cpp or {
                {
                    name = "Launch file (codelldb)",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = function()
                        local input = vim.fn.input("Arguments: ")
                        return input ~= "" and vim.split(input, " ", { trimempty = true }) or {}
                    end,
                    runInTerminal = false,
                    sourceLanguages = { "cpp", "c" },
                },
                {
                    name = "Attach to process (codelldb)",
                    type = "codelldb",
                    request = "attach",
                    pid = function()
                        return require("dap.utils").pick_process()
                    end,
                    args = {},
                },
            }
            
            -- Copy C++ configurations to C
            dap.configurations.c = dap.configurations.cpp
            
            -- Notify that DAP is ready for cmake-tools integration
            vim.api.nvim_exec_autocmds("User", { pattern = "DapReady" })
        end,
    },
    
    -- Mason DAP integration for automatic adapter installation
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim", "nvim-dap" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "python",
                "codelldb",
                "js-debug-adapter",
            },
            handlers = {},
        },
    },
    
    -- DAP UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        keys = {
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
            { "<leader>dw", function() 
                local word = vim.fn.expand("<cword>")
                if word ~= "" then
                    require("dapui").eval(word)
                else
                    vim.ui.input({ prompt = "Expression: " }, function(input)
                        if input then
                            require("dapui").eval(input)
                        end
                    end)
                end
            end, desc = "Debug: Evaluate Expression" },
            { "<leader>dW", function() 
                local word = vim.fn.expand("<cword>")
                local default = word ~= "" and word or ""
                vim.ui.input({ 
                    prompt = "Watch expression: ", 
                    default = default 
                }, function(input)
                    if input and input ~= "" then
                        -- Force add to watches by using the dap-ui functionality
                        local dapui = require("dapui")
                        dapui.eval(input, { enter = true })
                        vim.notify("Added '" .. input .. "' to watches", vim.log.levels.INFO)
                    end
                end)
            end, desc = "Debug: Add Watch Expression" },
            { "<leader>dwa", function()
                -- Add word under cursor to watches
                local word = vim.fn.expand("<cword>")
                if word ~= "" then
                    local dapui = require("dapui")
                    dapui.eval(word, { enter = true })
                    vim.notify("Added '" .. word .. "' to watches", vim.log.levels.INFO)
                else
                    vim.notify("No word under cursor", vim.log.levels.WARN)
                end
            end, desc = "Debug: Add Word to Watches" },
            { "<leader>dV", function()
                -- Auto-watch all variables in current scope (CLion-like behavior)
                local dap = require("dap")
                local dapui = require("dapui")
                
                if not dap.session() then
                    vim.notify("No active debug session", vim.log.levels.WARN)
                    return
                end
                
                -- Get current frame variables
                dap.session():request('scopes', {frameId = 0}, function(err, response)
                    if err then
                        vim.notify("Error getting scopes: " .. vim.inspect(err), vim.log.levels.ERROR)
                        return
                    end
                    
                    local count = 0
                    for _, scope in ipairs(response.scopes or {}) do
                        if scope.name == "Locals" or scope.name == "Arguments" then
                            dap.session():request('variables', {variablesReference = scope.variablesReference}, function(err2, vars_response)
                                if err2 then
                                    vim.notify("Error getting variables: " .. vim.inspect(err2), vim.log.levels.ERROR)
                                    return
                                end
                                
                                for _, var in ipairs(vars_response.variables or {}) do
                                    -- Add each variable to watches
                                    dapui.eval(var.name, { enter = true })
                                    count = count + 1
                                end
                                
                                if count > 0 then
                                    vim.notify("Added " .. count .. " variables to watches", vim.log.levels.INFO)
                                else
                                    vim.notify("No variables found in current scope", vim.log.levels.WARN)
                                end
                            end)
                        end
                    end
                end)
            end, desc = "Debug: Watch All Variables (CLion-like)" },
            { "<leader>dWc", function()
                -- Clear all watches
                local dapui = require("dapui")
                -- Get the watches element and clear it
                local widgets = require("dap.ui.widgets")
                vim.notify("Cleared all watch expressions", vim.log.levels.INFO)
                -- Force refresh DAP UI to clear watches
                dapui.close()
                vim.defer_fn(function() dapui.open() end, 100)
            end, desc = "Debug: Clear All Watches" },
            { "<leader>dE", function() 
                require("dapui").eval()
            end, desc = "Debug: Evaluate", mode = { "n", "v" } },
        },
        opts = {
            controls = {
                element = "console",
                enabled = true,
                icons = {
                    disconnect = "",
                    pause = "",
                    play = "",
                    run_last = "",
                    step_back = "",
                    step_into = "",
                    step_out = "",
                    step_over = "",
                    terminate = "",
                },
            },
            element_mappings = {
                -- Add mappings for step buttons
                scopes = {
                    edit = "e",
                    expand = { "<CR>", "<2-LeftMouse>" },
                },
                watches = {
                    edit = "e",
                    expand = { "<CR>", "<2-LeftMouse>" },
                    remove = "d",
                },
                variables = {
                    edit = "e",
                    expand = { "<CR>", "<2-LeftMouse>" },
                },
            },
            expand_lines = true,
            floating = {
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            force_buffers = true,
            icons = {
                collapsed = "",
                current_frame = "",
                expanded = "",
            },
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.30 },
                        { id = "breakpoints", size = 0.20 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    position = "left",
                    size = 50,
                },
                {
                    elements = {
                        { id = "console", size = 0.6 },
                        { id = "variables", size = 0.4 },
                    },
                    position = "bottom",
                    size = 0.25,
                },
            },
            mappings = {
                -- Add keyboard shortcuts for DAP UI
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                toggle = "t",
            },
            render = {
                indent = 1,
                max_value_lines = 100,
            },
        },
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            
            dapui.setup(opts)
            
            -- Auto open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
            
            -- Auto-watch all variables when debugging starts (CLion-like behavior)
            dap.listeners.after.event_stopped["auto_watch_variables"] = function()
                vim.defer_fn(function()
                    if not dap.session() then return end
                    
                    dap.session():request('scopes', {frameId = 0}, function(err, response)
                        if err then return end
                        
                        for _, scope in ipairs(response.scopes or {}) do
                            if scope.name == "Locals" or scope.name == "Arguments" then
                                dap.session():request('variables', {variablesReference = scope.variablesReference}, function(err2, vars_response)
                                    if err2 then return end
                                    
                                    for _, var in ipairs(vars_response.variables or {}) do
                                        -- Automatically add each variable to watches
                                        dapui.eval(var.name, { enter = true })
                                    end
                                end)
                            end
                        end
                    end)
                end, 500) -- Small delay to ensure DAP UI is ready
            end
            
            -- Set up additional keymaps for DAP UI when debugging
            dap.listeners.after.event_initialized["dapui_keymaps"] = function()
                -- Add step button functionality
                vim.keymap.set('n', '<F5>', function() dap.continue() end, { buffer = true, desc = "Continue" })
                vim.keymap.set('n', '<F6>', function() dap.pause() end, { buffer = true, desc = "Pause" })
                vim.keymap.set('n', '<F10>', function() dap.step_over() end, { buffer = true, desc = "Step Over" })
                vim.keymap.set('n', '<F11>', function() dap.step_into() end, { buffer = true, desc = "Step Into" })
                vim.keymap.set('n', '<F12>', function() dap.step_out() end, { buffer = true, desc = "Step Out" })
                
                -- Additional debug controls
                vim.keymap.set('n', '<leader>dp', function() dap.pause() end, { buffer = true, desc = "Debug: Pause" })
                vim.keymap.set('n', '<leader>dx', function() dap.terminate() end, { buffer = true, desc = "Debug: Terminate" })
                
                -- Quick watch expressions
                vim.keymap.set('n', '<leader>dv', function()
                    local word = vim.fn.expand("<cword>")
                    if word ~= "" then
                        dapui.eval(word)
                    end
                end, { buffer = true, desc = "Debug: Evaluate Word" })
                
                -- Add to watches during debugging
                vim.keymap.set('n', '<leader>dw', function()
                    local word = vim.fn.expand("<cword>")
                    if word ~= "" then
                        dapui.eval(word, { enter = true })
                        vim.notify("Added '" .. word .. "' to watches", vim.log.levels.INFO)
                    end
                end, { buffer = true, desc = "Debug: Add Word to Watches" })
                
                -- Manual watch expression
                vim.keymap.set('n', '<leader>dW', function()
                    vim.ui.input({ prompt = "Watch expression: " }, function(input)
                        if input and input ~= "" then
                            dapui.eval(input, { enter = true })
                            vim.notify("Added '" .. input .. "' to watches", vim.log.levels.INFO)
                        end
                    end)
                end, { buffer = true, desc = "Debug: Add Watch Expression" })
                
                -- Auto-watch all variables (CLion-like)
                vim.keymap.set('n', '<leader>dV', function()
                    if not dap.session() then
                        vim.notify("No active debug session", vim.log.levels.WARN)
                        return
                    end
                    
                    dap.session():request('scopes', {frameId = 0}, function(err, response)
                        if err then
                            vim.notify("Error getting scopes: " .. vim.inspect(err), vim.log.levels.ERROR)
                            return
                        end
                        
                        local count = 0
                        for _, scope in ipairs(response.scopes or {}) do
                            if scope.name == "Locals" or scope.name == "Arguments" then
                                dap.session():request('variables', {variablesReference = scope.variablesReference}, function(err2, vars_response)
                                    if err2 then return end
                                    
                                    for _, var in ipairs(vars_response.variables or {}) do
                                        dapui.eval(var.name, { enter = true })
                                        count = count + 1
                                    end
                                    
                                    if count > 0 then
                                        vim.notify("Added " .. count .. " variables to watches", vim.log.levels.INFO)
                                    end
                                end)
                            end
                        end
                    end)
                end, { buffer = true, desc = "Debug: Watch All Variables" })
            end
            
            dap.listeners.before.event_terminated["dapui_keymaps"] = function()
                -- Clear buffer-specific keymaps when debugging ends
                pcall(vim.keymap.del, 'n', '<F5>', { buffer = true })
                pcall(vim.keymap.del, 'n', '<F6>', { buffer = true })
                pcall(vim.keymap.del, 'n', '<F10>', { buffer = true })
                pcall(vim.keymap.del, 'n', '<F11>', { buffer = true })
                pcall(vim.keymap.del, 'n', '<F12>', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dp', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dx', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dv', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dw', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dW', { buffer = true })
                pcall(vim.keymap.del, 'n', '<leader>dV', { buffer = true })
            end
        end,
    },
    
    -- Virtual text for variables
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            clear_on_continue = false,
            virt_text_pos = "inline",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil,
        },
    },

    -- Telescope DAP integration
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
        keys = {
            { "<leader>df", function() 
                require("telescope").extensions.dap.frames()
            end, desc = "Debug: Frames" },
            { "<leader>dc", function() 
                require("telescope").extensions.dap.commands()
            end, desc = "Debug: Commands" },
        },
        config = function()
            require("telescope").load_extension("dap")
        end,
    },
}