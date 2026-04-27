local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--no-ignore",
    },
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.9,
      height = 0.8,
      preview_cutoff = 120,
    },
    preview = true,
    mappings = {
      i = {
        -- Escape to normal mode
        ["<C-c>"] = actions.close,
        -- Scroll preview
        ["<C-j>"] = actions.preview_scrolling_down,
        ["<C-k>"] = actions.preview_scrolling_up,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    -- Customize specific pickers
    find_files = {
      hidden = true,  -- Show hidden files
      no_ignore = true,
      follow = true,  -- Follow symlinks
    },
    live_grep = {
      additional_args = function()
        return { "--hidden", "--no-ignore" }
      end,
    },
  },
  extensions = {
    frecency = {
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
    },
  },
})

require("telescope").load_extension("frecency")

vim.keymap.set("n", "<leader>f", function()
  require("telescope").extensions.frecency.frecency({
    workspace = "CWD",
  })
end, { desc = "Frecency files (cwd)" })

