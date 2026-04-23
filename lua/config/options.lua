-- basic settings
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus" -- system clipboard integration
vim.opt.showcmd = true
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = false
vim.opt.smarttab = true
vim.opt.cindent = false
vim.opt.smartindent = false
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backspace = "indent,eol,start"
vim.opt.title = true
vim.opt.ttyfast = true
vim.opt.guifont = "MesloLGS Nerd Font:h12"
vim.opt.history = 999
vim.opt.undolevels = 999
vim.opt.report = 0
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 6
vim.opt.sidescroll = 1
vim.opt.hlsearch = false
vim.opt.ttimeoutlen = 100
vim.opt.switchbuf = "useopen,usetab"

-- stop newline continuation of comments
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    -- Standard indentation settings
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true

    -- C-specific indent options
    vim.opt_local.cinoptions = "g0,:0,l1,(0,Ws,m1"
    -- Explanation:
    -- g0 = No indent for C++ scope declarations (public:, private:)
    -- :0 = No indent for case labels
    -- l1 = Align with case label instead of statement after it
    -- (0 = Line up with next character after unclosed parentheses
    -- Ws = Indent in unclosed parentheses when they end with whitespace
    -- m1 = Line up closing parenthesis with first character of line with opening
  end,
})

-- for Makefiles, use actual tabs but display as 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 3
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.cindent = false
  end,
})
