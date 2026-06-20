return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",      function() require("dap").continue() end,                                        desc = "Debug: start/continue" },
      { "<F10>",     function() require("dap").step_over() end,                                       desc = "Debug: step over" },
      { "<F11>",     function() require("dap").step_into() end,                                       desc = "Debug: step into" },
      { "<S-F11>",   function() require("dap").step_out() end,                                        desc = "Debug: step out" },
      { "<F9>",      function() require("dap").toggle_breakpoint() end,                               desc = "Debug: toggle breakpoint" },
      { "<S-F9>",    function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,       desc = "Debug: conditional breakpoint" },
      { "<leader>dt", function() require("dap").terminate() end,                                      desc = "Debug: terminate" },
      { "<leader>dr", function() require("dap").restart() end,                                        desc = "Debug: restart" },
      { "<leader>du", function() require("dapui").toggle() end,                                       desc = "Debug: toggle UI" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" },                   desc = "Debug: evaluate" },
      -- fzf-lua dap pickers (replaces telescope-dap)
      { "<leader>db", function() require("fzf-lua").dap_breakpoints() end,                           desc = "Debug: breakpoints" },
      { "<leader>dc", function() require("fzf-lua").dap_commands() end,                              desc = "Debug: commands" },
      { "<leader>dv", function() require("fzf-lua").dap_variables() end,                             desc = "Debug: variables" },
      { "<leader>df", function() require("fzf-lua").dap_frames() end,                                desc = "Debug: frames" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- virtual text: shows variable values inline while stepping
      require("nvim-dap-virtual-text").setup({
        commented = true, -- append as comment
      })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- auto open/close UI with session lifecycle
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

      -- signs
      vim.fn.sign_define("DapBreakpoint",         { text = "B",  texthl = "DapBreakpoint",         linehl = "",              numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition",{ text = "C",  texthl = "DapBreakpointCondition", linehl = "",             numhl = "" })
      vim.fn.sign_define("DapLogPoint",           { text = "L",  texthl = "DapLogPoint",            linehl = "",             numhl = "" })
      vim.fn.sign_define("DapStopped",            { text = "->", texthl = "DapStopped",             linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "X",  texthl = "DapBreakpointRejected",  linehl = "",             numhl = "" })

      -- ── codelldb (C / C++ / Rust / Zig) ──────────────────────────────
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name    = "launch C",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd          = "${workspaceFolder}",
          stopOnEntry  = false,
        },
      }

      dap.configurations.cpp = {
        {
          name    = "launch C++",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name    = "launch C++ (cmake debug build)",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.cmake = dap.configurations.cpp

      -- Zig compiles to an ELF the same as C; codelldb handles it fine
      dap.configurations.zig = {
        {
          name    = "launch Zig",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name    = "launch Zig (zig build debug)",
          type    = "codelldb",
          request = "launch",
          program = function()
            vim.fn.system("zig build")
            -- derive binary name from cwd folder name
            local bin = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return vim.fn.getcwd() .. "/zig-out/bin/" .. bin
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.rust = {
        {
          name    = "launch Rust",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name    = "launch Rust (cargo build)",
          type    = "codelldb",
          request = "launch",
          program = function()
            vim.fn.system("cargo build")
            local metadata = vim.fn.system("cargo metadata --format-version 1 --no-deps")
            local json     = vim.fn.json_decode(metadata)
            local name     = json.packages[1].targets[1].name
            return json.target_directory .. "/debug/" .. name
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- ── node-debug2 (JS / TS) ─────────────────────────────────────────
      dap.adapters.node2 = {
        type    = "executable",
        command = "node",
        args    = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
      }

      dap.configurations.javascript = {
        {
          name     = "launch Node.js",
          type     = "node2",
          request  = "launch",
          program  = "${file}",
          cwd      = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console  = "integratedTerminal",
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
    end,
  },
}