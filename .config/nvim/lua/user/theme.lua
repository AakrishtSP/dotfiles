local M = {}

-- Simple theme selector: SetTheme <name>
local function apply_theme(name)
  if not name or name == "catppuccin" then
    pcall(function()
      vim.cmd([[colorscheme catppuccin]])
    end)
  elseif name == "gruvbox" then
    pcall(function()
      vim.cmd([[colorscheme gruvbox]])
    end)
  else
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.WARN)
  end
  vim.g.user_theme = name
end

function M.setup()
  -- Default: catppuccin if available
  local theme = vim.g.user_theme or "catppuccin"
  apply_theme(theme)

  vim.api.nvim_create_user_command("SetTheme", function(opts)
    local t = opts.args
    if t == "" then
      vim.notify("Usage: SetTheme <catppuccin|gruvbox>", vim.log.levels.INFO)
      return
    end
    apply_theme(t)
    vim.notify("Theme set to: " .. t)
  end, { nargs = 1 })
end

return M
