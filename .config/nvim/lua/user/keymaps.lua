-- Set default yank to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Enhanced undo/redo keymaps
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" }) -- Make U redo (more intuitive)
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" }) -- Ctrl+Z for undo (standard)
vim.keymap.set("n", "<C-S-z>", "<C-r>", { desc = "Redo" }) -- Ctrl+Shift+Z for redo (standard)
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo in Insert Mode" })
vim.keymap.set("i", "<C-S-z>", "<C-o><C-r>", { desc = "Redo in Insert Mode" })

-- System clipboard keymaps
vim.keymap.set("n", "<C-S-c>", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("v", "<C-S-c>", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("i", "<C-S-c>", '<C-o>"+y', { desc = "Copy to system clipboard (Insert)" })

-- Break undo sequence on certain characters (better granular undo)
vim.keymap.set("i", ",", ",<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ".", ".<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", "!", "!<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", "?", "?<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ";", ";<C-g>u", { desc = "Break undo sequence" })
vim.keymap.set("i", ":", ":<C-g>u", { desc = "Break undo sequence" })

-- Update system keymaps
vim.keymap.set("n", "<leader>uu", ":UpdateAll<CR>", { desc = "Update All (Plugins, LSP, Tools)" })
vim.keymap.set("n", "<leader>up", ":UpdatePlugins<CR>", { desc = "Update Plugins Only" })
vim.keymap.set("n", "<leader>um", ":UpdateMason<CR>", { desc = "Update Mason Tools" })
vim.keymap.set("n", "<leader>ut", ":UpdateTreesitter<CR>", { desc = "Update Treesitter Parsers" })
