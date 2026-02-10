-- basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus" -- system clipboard integration
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.encoding = "UTF-8"
vim.opt.termguicolors = true
vim.cmd("filetype plugin indent on") -- corrected line (Vimscript command)
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- ensure spaces are used instead of tabs
vim.opt.mouse = "a"
vim.opt.smartindent = false
vim.opt.cindent = true
vim.opt.backup = false -- corrected line
vim.opt.writebackup = false -- corrected line
vim.opt.swapfile = false -- corrected line
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
vim.opt.formatoptions:remove({ "c", "r", "o" })
-- italics
vim.cmd([[let &t_ZH="\e[3m"]])
vim.cmd([[let &t_ZR="\e[23m"]])

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
        vim.opt_local.cindent = false
        vim.opt_local.smartindent = true
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})

-- ensure tab settings are applied for all filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.expandtab = true
	end,
})

-- this tells Neovim: "If you have a Treesitter parser for this file, use it!"
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        -- Only start if we have a parser for this filetype
        if pcall(vim.treesitter.start, buf) then
            -- Success: Highlighting is now active
        end
    end,
})

