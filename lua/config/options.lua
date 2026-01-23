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
-- vim.opt.indentexpr = "v:lua.vim.treesitter.indent()"
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

-- italics
vim.cmd([[let &t_ZH="\e[3m"]])
vim.cmd([[let &t_ZR="\e[23m"]])

-- ensure tab settings are applied for all filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.tabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.expandtab = true
		-- vim.opt.formatoptions:remove({ "r", "o" })
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

-- key remaps
-- vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree focus<CR>', { noremap = true, silent = true })
-- toggle Neotree focus/close
vim.api.nvim_set_keymap(
	"n",
	"<leader>e",
	':lua require("neo-tree.command").execute({ toggle=true })<CR>',
	{ noremap = true, silent = true }
)

-- move lines up and down
vim.keymap.set("n", "<C-k>", ":m -2<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":m +1<CR>", { silent = true })

-- visual block mode
vim.keymap.set("n", "<C-B>", "<C-v>", { silent = true })

-- spell Checker Configuration
vim.opt.spelllang = { "en", "es" } -- Set spell languages to English and Spanish
vim.opt.spell = false -- Disable spell checking by default

-- keybindings for spell checking
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

-- change windows easier
vim.keymap.set("n", "<leader>d", "<C-w>w", { noremap = true })


-- smart dd: Don't yank empty lines into the default register
vim.keymap.set("n", "dd", function()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	else
		return "dd"
	end
end, { expr = true, desc = "Smart delete line"})

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


