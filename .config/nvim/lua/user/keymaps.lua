-- Enhanced undo/redo keymaps
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" }) -- Make U redo (more intuitive)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" }) -- Ctrl+Z for undo (standard)
vim.keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" }) -- Ctrl+Shift+Z for redo (standard)
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo in Insert Mode" })
vim.keymap.set("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo in Insert Mode" })

-- Break undo sequence on certain characters (better granular undo)
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", "!", "!<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", "?", "?<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ":", ":<C-g>u", { desc = "Break undo sequence" })

-- Add keymaps for C++ specific features
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.keymap.set("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", { desc = "Switch Header/Source" })
        vim.keymap.set("n", "<leader>ci", ":ClangdAST<CR>", { desc = "Show AST" })
        vim.keymap.set("n", "<leader>ct", ":ClangdTypeHierarchy<CR>", { desc = "Type Hierarchy" })
        vim.keymap.set("n", "<leader>cm", ":ClangdMemoryUsage<CR>", { desc = "Memory Usage" })
    end,
})

-- Update system keymaps
vim.keymap.set("n", "<leader>uu", ":UpdateAll<CR>", { desc = "Update All (Plugins, LSP, Tools)" })
vim.keymap.set("n", "<leader>up", ":UpdatePlugins<CR>", { desc = "Update Plugins Only" })
vim.keymap.set("n", "<leader>um", ":UpdateMason<CR>", { desc = "Update Mason Tools" })
vim.keymap.set("n", "<leader>ut", ":UpdateTreesitter<CR>", { desc = "Update Treesitter Parsers" })

-- CMake build keymaps (non-debugging)
vim.keymap.set("n", "<F9>", function()
    -- Quick CMake build (common shortcut)
    vim.cmd("CMakeBuild")
end, { desc = "CMake: Build" })

vim.keymap.set("n", "<C-F5>", function()
    -- Build and run (without debugging)
    vim.cmd("CMakeBuild")
    vim.defer_fn(function()
        if vim.v.shell_error == 0 then
            vim.cmd("CMakeRun")
        end
    end, 1000)
end, { desc = "CMake: Build & Run" })
