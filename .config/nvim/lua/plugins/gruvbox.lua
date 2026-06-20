return {
  "ellisonleao/gruvbox.nvim",
  lazy = true,
  opts = {
    contrast = "soft",
    transparent_mode = false,
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
  end,
}
