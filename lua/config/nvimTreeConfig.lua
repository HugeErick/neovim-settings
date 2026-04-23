require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
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
})

-- open nvim-tree when nvim starts 
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
    vim.cmd("wincmd l")
  end,
})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })
