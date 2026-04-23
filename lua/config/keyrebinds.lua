-- visual block mode
vim.keymap.set("n", "<C-B>", "<C-v>", { silent = true })

-- vim.opt.spell = false -- Disable spell checking by default

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


vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>N", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
