return {
	-- DAP (Debug Adapter Protocol)
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			-- DAP UI for better debugging experience
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				opts = {
					layouts = {
						{
							elements = {
								{ id = "scopes", size = 0.25 },
								{ id = "breakpoints", size = 0.25 },
								{ id = "stacks", size = 0.25 },
								{ id = "watches", size = 0.25 },
							},
							position = "left",
							size = 40,
						},
						{
							elements = {
								{ id = "repl", size = 0.5 },
								{ id = "console", size = 0.5 },
							},
							position = "bottom",
							size = 10,
						},
					},
				},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")

					dapui.setup(opts)

					-- Auto open/close DAP UI
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},

			-- Telescope integration
			{
				"nvim-telescope/telescope-dap.nvim",
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
		},
		keys = {
			-- VSCode-like keymaps
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<S-F11>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<F9>",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<S-F9>",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Conditional Breakpoint",
			},

			-- Additional useful keymaps
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Debug: Terminate",
			},
			{
				"<leader>dr",
				function()
					require("dap").restart()
				end,
				desc = "Debug: Restart",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: Toggle UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Debug: Evaluate",
			},

			-- Telescope integration
			{
				"<leader>db",
				function()
					require("telescope").extensions.dap.list_breakpoints()
				end,
				desc = "Debug: List Breakpoints",
			},
			{
				"<leader>dc",
				function()
					require("telescope").extensions.dap.commands()
				end,
				desc = "Debug: Commands",
			},
			{
				"<leader>dv",
				function()
					require("telescope").extensions.dap.variables()
				end,
				desc = "Debug: Variables",
			},
		},
		config = function()
			local dap = require("dap")

			-- Set up signs
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▶️", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "❌", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
			)

			-- Basic configurations for common languages
			-- Add more as needed for your specific languages

			-- Example: Node.js/JavaScript debugging
			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
			}

			dap.configurations.javascript = {
				{
					name = "Launch Node.js",
					type = "node2",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
			}

			dap.configurations.typescript = dap.configurations.javascript

			-- Rust debugging with codelldb
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Launch Rust",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch Rust (cargo build)",
					type = "codelldb",
					request = "launch",
					program = function()
						vim.fn.system("cargo build")
						local metadata = vim.fn.system("cargo metadata --format-version 1 --no-deps")
						local json = vim.fn.json_decode(metadata)
						local target_name = json.packages[1].targets[1].name
						return json.target_directory .. "/debug/" .. target_name
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- C/C++ debugging with codelldb
			dap.configurations.c = {
				{
					name = "Launch C",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch C++",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
				{
					name = "Launch C++ (CMake Debug)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- CMake specific configuration (uses same adapter as C++)
			dap.configurations.cmake = dap.configurations.cpp
		end,
	},
}

