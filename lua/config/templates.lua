-- define the templates as tables of strings
local templates = {
	cpp = {
		"#include <iostream>",
		"#include <string>",
		"#include <map>",
		"#include <vector>",
		"#include <algorithm>",
		"#include <iterator>",
		"#include <exception>",
		"#include <bitset>",
		"#include <sstream>",
		"",
		"#define ll long long",
		"",
		"using namespace std",
		"",
		"int main() {",
		"  // templ generation",
		"  return 0;",
		"}",
	},
	c = {
		"#include <stdio.h>",
		"",
		"int main() {",
		'  printf("Hello world!\\n");',
		"",
		"  return 0;",
		"}",
	},
}

-- create the autocommand
local template_group = vim.api.nvim_create_augroup("CppTemplates", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
	group = template_group,
	pattern = { "*.cpp", "*.c" },
	callback = function(args)
		local ext = vim.fn.expand("%:e")
		local lines = templates[ext]

		if lines then
			-- we use vim.schedule to wait for the buffer to be ready
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(args.buf) then
					-- force modifiable just in case
					vim.bo[args.buf].modifiable = true

					-- insert the lines starting at line 0
					vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)

					-- move the cursor to the "code here" line (line 4, column 4)
					-- note: api uses 0-indexed rows, so 3 is the 4th line.
					pcall(vim.api.nvim_win_set_cursor, 0, { 4, 4 })
				end
			end)
		end
	end,
})
