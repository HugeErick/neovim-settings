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
    "#include <cstdio>",
    "",
    "#define ll long long",
    "",
    "using namespace std;",
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

vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
  group = template_group,
  pattern = { "*.cpp", "*.c" },
  callback = function(args)
    local ext = vim.fn.expand("%:e")
    local lines = templates[ext]

    if not lines then
      return
    end

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end 

      local buf_lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      local is_empty = #buf_lines == 0 or (#buf_lines == 1 and buf_lines[1] == "")

      if is_empty then
        vim.bo[args.buf].modifiable = true
        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)

        -- Move cursor if window is valid
        pcall(vim.api.nvim_win_set_cursor, 0, { 4, 4 })
      end
    end)
  end,
})
