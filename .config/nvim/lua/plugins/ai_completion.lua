return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-\\>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = false,
        help = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      -- Ensure Copilot does not consume the raw <Esc> key in insert mode
      pcall(vim.keymap.del, "i", "<Esc>")
    end,
  },
}
