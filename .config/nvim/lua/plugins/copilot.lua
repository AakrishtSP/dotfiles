return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Enable Copilot for all filetypes
    vim.g.copilot_enabled = true
    
    -- Copilot settings - Enable tab completion
    vim.g.copilot_no_tab_map = false
    vim.g.copilot_assume_mapped = false
    vim.g.copilot_tab_fallback = ""
    
    -- Custom keymaps for Copilot suggestions (keeping alternatives)
    vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot suggestion"
    })
    
    -- Tab for acceptance (primary method)
    vim.keymap.set("i", "<Tab>", 'copilot#Accept("\\<Tab>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Accept Copilot suggestion with Tab"
    })
    
    vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
    vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
    
    -- Word-level and line-level acceptance
    vim.keymap.set("i", "<C-f>", "<Plug>(copilot-accept-word)", { desc = "Accept Copilot word" })
    vim.keymap.set("i", "<C-e>", "<Plug>(copilot-accept-line)", { desc = "Accept Copilot line" })
  end,
}
