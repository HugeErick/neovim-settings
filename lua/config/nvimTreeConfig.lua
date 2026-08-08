-- https://github.com/nvim-tree/nvim-tree.lua

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  filters = {
    dotfiles = false,
    git_clean = false, 
    no_buffer = false,
    custom = { "node_modules" },
    exclude = {},
  },
  tab = {
    sync = {
      open = true,
      close = true,
    },
  },
})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
