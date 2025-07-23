-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.encoding = "UTF-8"
vim.opt.termguicolors = true
vim.cmd("filetype plugin indent on") -- Corrected line (Vimscript command)
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- Ensure spaces are used instead of tabs
vim.opt.mouse = "a"
vim.opt.backup = false -- Corrected line
vim.opt.writebackup = false -- Corrected line
vim.opt.swapfile = false -- Corrected line
vim.opt.backspace = "indent,eol,start"
vim.opt.title = true
vim.opt.lazyredraw = true
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

-- Italics
vim.cmd([[let &t_ZH="\e[3m"]])
vim.cmd([[let &t_ZR="\e[23m"]])

-- Ensure tab settings are applied for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.expandtab = true
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})

-- key remaps
-- vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree focus<CR>', { noremap = true, silent = true })
-- Toggle Neotree focus/close
vim.api.nvim_set_keymap('n', '<leader>e', ':lua require("neo-tree.command").execute({ toggle=true })<CR>', { noremap = true, silent = true })

-- Move lines up and down
vim.keymap.set("n", "<C-k>", ":m -2<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":m +1<CR>", { silent = true })

-- Visual block mode
vim.keymap.set("n", "<C-B>", "<C-v>", { silent = true })


-- Spell Checker Configuration
vim.opt.spelllang = { "en", "es" } -- Set spell languages to English and Spanish
vim.opt.spell = false -- Disable spell checking by default

-- Keybindings for spell checking
vim.keymap.set("n", "<leader>ss", function()
    vim.opt.spell = not vim.opt.spell:get() -- Toggle spell checking
    if vim.opt.spell:get() then
        print("Spell checking enabled")
    else
        print("Spell checking disabled")
    end
end, { desc = "Toggle Spell Checking" })

vim.keymap.set("n", "<leader>sl", function()
    local current_lang = vim.opt.spelllang:get()
    local next_lang = current_lang == "en" and "es" or "en"
    vim.opt.spelllang = next_lang
    print("Switched spell language to " .. next_lang)
end, { desc = "Switch Spell Language (English/Spanish)" })

-- Change windows easier
vim.keymap.set('n', '<leader>d', '<C-w>w', { noremap = true })

