local themes = { "tokyonight", "catppuccin-mocha", "rose-pine", "catppuccin-latte" }

-- path where the theme name will be saved
local theme_cache = vim.fn.stdpath("data") .. "/last_theme.txt"

-- function to read the saved theme
local function get_saved_theme()
  local f = io.open(theme_cache, "r")
  if f then
    local content = f:read("*all"):gsub("%s+", "")
    f:close()
    for _, t in ipairs(themes) do
      if t == content then
        return content
      end
    end
  end
  return "tokyonight" -- default if no file exists
end

-- function to save the theme
local function save_theme(name)
  local f = io.open(theme_cache, "w")
  if f then
    f:write(name)
    f:close()
  end
end

-- initialize theme index based on saved theme
local saved = get_saved_theme()
local current_theme_idx = 1
for i, v in ipairs(themes) do
  if v == saved then
    current_theme_idx = i
    break
  end
end

-- define the toggle function
_G.next_theme = function()
  current_theme_idx = current_theme_idx % #themes + 1
  local new_theme = themes[current_theme_idx]

  vim.cmd("colorscheme " .. new_theme)
  save_theme(new_theme) -- SAVE TO DISK

  vim.api.nvim_command("redraw")
  print("HD Theme Switched to: " .. new_theme)
end

-- set the keymap
vim.keymap.set("n", "<leader>th", _G.next_theme, { desc = "Cycle Themes" })

-- apply the saved theme on startup
vim.schedule(function()
  pcall(vim.cmd, "colorscheme " .. saved)
end)
