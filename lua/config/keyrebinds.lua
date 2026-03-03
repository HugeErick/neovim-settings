vim.api.nvim_set_keymap(
	"n",
	"<leader>e",
	':lua require("neo-tree.command").execute({ toggle=true })<CR>',
	{ noremap = true, silent = true }
)
-- visual block mode
vim.keymap.set("n", "<C-B>", "<C-v>", { silent = true })

-- spell Checker Configuration
vim.opt.spelllang = { "en", "es" } -- Set spell languages to English and Spanish
vim.opt.spell = false -- Disable spell checking by default
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

