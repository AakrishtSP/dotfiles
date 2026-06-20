return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  event = "VeryLazy",
  keys = {
    { "<leader>ff",  "<cmd>FzfLua files<cr>",                  desc = "find files" },
    { "<leader>gf",  "<cmd>FzfLua git_files<cr>",              desc = "git files" },
    { "<leader>fF",  "<cmd>FzfLua files<cr>",                  desc = "all files (names)" },
    { "<leader>fg",  "<cmd>FzfLua live_grep<cr>",              desc = "live grep" },
    { "<leader>fb",  "<cmd>FzfLua buffers<cr>",                desc = "buffers" },
    { "<leader>fh",  "<cmd>FzfLua help_tags<cr>",              desc = "help tags" },
    { "<leader>fs",  "<cmd>FzfLua grep_cword<cr>",             desc = "search word" },
    { "<leader>fc",  "<cmd>FzfLua commands<cr>",               desc = "commands" },
    { "<leader>fo",  "<cmd>FzfLua oldfiles<cr>",               desc = "recent files" },
    { "<leader>fr",  "<cmd>FzfLua lsp_references<cr>",         desc = "lsp references" },
    { "<leader>fd",  "<cmd>FzfLua lsp_definitions<cr>",        desc = "lsp definitions" },
    { "<leader>fi",  "<cmd>FzfLua lsp_implementations<cr>",    desc = "lsp implementations" },
    { "<leader>fds", "<cmd>FzfLua lsp_document_symbols<cr>",   desc = "document symbols" },
    { "<leader>fws", "<cmd>FzfLua lsp_workspace_symbols<cr>",  desc = "workspace symbols" },
  },
  opts = {
    silent = true,
    defaults = {
      formatter = "path.filename_first",
    },
    winopts = {
      height = 0.85,
      width  = 0.80,
      border = "rounded",
      preview = {
        layout = "flex",
        flip_columns = 120,
      },
    },
    files = {
      cwd_prompt = false,
      -- use builtin previewer to avoid external previewer stat issues on odd filenames
      previewer  = "builtin",
      -- use fd with null separator to be safe with spaces/newlines in filenames
      fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude .zig-cache --exclude zig-out --exclude build -0",
    },
    grep = {
      rg_opts = "--color=never -n --column --hidden --smart-case --follow -g '!.git' -g '!.zig-cache/**' -g '!zig-out/**' -g '!build/**'",
    },
    lsp = {
      symbols = {
        symbol_icons = {
          File        = "󰈙",
          Module      = "",
          Namespace   = "󰌗",
          Package     = "",
          Class       = "󰌗",
          Method      = "󰆧",
          Property    = "",
          Field       = "",
          Constructor = "",
          Enum        = "󰕘",
          Interface   = "󰕘",
          Function    = "󰊕",
          Variable    = "󰆧",
          Constant    = "󰏿",
          String      = "",
          Number      = "󰎠",
          Boolean     = "◩",
          Array       = "󰅪",
          Object      = "󰅩",
          Key         = "󰌋",
          Null        = "󰟢",
        },
      },
    },
  },
}
