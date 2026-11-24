-- Python-only indentation (2 spaces), buffer-local and gated on FileType=python.
local SW = 2

local function set(list)
  local t = {}
  for _, v in ipairs(list) do t[v] = true end
  return t
end

local OPEN, CLOSE = set({ "(", "[", "{" }), set({ ")", "]", "}" })
local DEDENT = set({ "return", "pass", "break", "continue", "raise" })
local CLAUSE = {
  ["else"] = set({ "if", "elif", "for", "while", "try", "except" }),
  ["elif"] = set({ "if", "elif" }),
  ["except"] = set({ "try", "except" }),
  ["finally"] = set({ "try", "except", "else" }),
}

-- state after scanning some lines:
--   stack     open brackets (each { line = n })
--   triple    open triple-quote delimiter or nil
--   cont      previous line ended with a backslash
--   stmt_line first line of the current logical statement
--   first     first word of that statement, last = last code char so far
local INIT = { stack = {}, triple = nil, cont = false }

local function scan_line(prev, text, lnum)
  local st = {
    stack = vim.list_slice(prev.stack),
    triple = prev.triple,
    cont = false,
    stmt_line = prev.stmt_line,
    first = prev.first,
    last = prev.last,
  }
  local new_stmt = (prev.triple == nil and #prev.stack == 0 and not prev.cont)
  local i, n = 1, #text

  if st.triple then -- continue inside a triple-quoted string
    local j = 1
    while j <= n do
      local c = text:sub(j, j)
      if c == "\\" then
        j = j + 2
      elseif text:sub(j, j + 2) == st.triple then
        st.triple = nil
        i = j + 3
        break
      else
        j = j + 1
      end
    end
    if st.triple then return st end
  end

  while i <= n do
    local c = text:sub(i, i)
    if c == "#" then break end
    if c:match("%s") then
      i = i + 1
    else
      if new_stmt then
        new_stmt = false
        st.stmt_line = lnum
        st.first = text:match("^[%a_]+", i)
        st.last = nil
      end
      if c == '"' or c == "'" then
        st.last = c
        local q3 = c:rep(3)
        local j = i + 1
        if text:sub(i, i + 2) == q3 then
          st.triple = q3
          j = i + 3
          local closed = false
          while j <= n do
            local d = text:sub(j, j)
            if d == "\\" then
              j = j + 2
            elseif text:sub(j, j + 2) == q3 then
              closed = true
              j = j + 3
              break
            else
              j = j + 1
            end
          end
          if not closed then return st end
          st.triple = nil
          i = j
        else
          while j <= n do
            local d = text:sub(j, j)
            if d == "\\" then
              j = j + 2
            elseif d == c then
              break
            else
              j = j + 1
            end
          end
          i = j + 1
        end
      else
        if OPEN[c] then
          st.stack[#st.stack + 1] = { line = lnum }
        elseif CLOSE[c] then
          st.stack[#st.stack] = nil
        end
        if c == "\\" and not text:find("%S", i + 1) then
          st.cont = true
        else
          st.last = c
        end
        i = i + 1
      end
    end
  end
  return st
end

-- per-buffer cache: reuse state of unchanged leading lines
local cache = {}

local function state_before(buf, lnum)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, lnum - 1, false)
  local c = cache[buf]
  if not c then
    c = { texts = {}, states = {} }
    cache[buf] = c
  end
  local st, valid = INIT, true
  for i, text in ipairs(lines) do
    if valid and c.texts[i] == text and c.states[i] then
      st = c.states[i]
    else
      valid = false
      st = scan_line(st, text, i)
      c.texts[i], c.states[i] = text, st
    end
  end
  return st
end

local function indent_for(buf, lnum)
  local sw = vim.fn.shiftwidth()
  local st = state_before(buf, lnum)
  if st.triple then return -1 end -- inside a multi-line string: leave alone

  local cur = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
  local trimmed = vim.trim(cur)

  -- inside brackets: hanging indent from the line that opened the bracket
  if #st.stack > 0 then
    local base = vim.fn.indent(st.stack[#st.stack].line)
    if trimmed:match("^[%)%]}]") then return base end
    return base + sw
  end

  if not st.stmt_line then return 0 end
  if st.cont then return vim.fn.indent(st.stmt_line) + sw end

  local base = vim.fn.indent(st.stmt_line)
  local ind
  if st.last == ":" then
    ind = base + sw
  elseif DEDENT[st.first] then
    ind = math.max(0, base - sw)
  else
    ind = base
  end

  -- else / elif / except / finally: align with the matching header
  local kw = trimmed:match("^([%a_]+)")
  local valid = kw and CLAUSE[kw]
  if valid then
    local c = cache[buf]
    local limit = ind + 1
    for i = lnum - 1, 1, -1 do
      local ps = (i == 1) and INIT or c.states[i - 1]
      if ps and #ps.stack == 0 and not ps.triple and not ps.cont then
        local word = c.texts[i]:match("^%s*([%a_]+)")
        if word then
          local li = vim.fn.indent(i)
          if li < limit then
            limit = li
            if valid[word] then return li end
          end
        end
      end
    end
    return math.max(0, ind - sw)
  end
  return ind
end

function _G.PyIndentExpr()
  local ok, res = pcall(indent_for, vim.api.nvim_get_current_buf(), vim.v.lnum)
  return ok and res or -1
end

vim.api.nvim_create_autocmd("BufWipeout", {
  group = vim.api.nvim_create_augroup("PythonIndentCache", { clear = true }),
  callback = function(ev) cache[ev.buf] = nil end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PythonIndent", { clear = true }),
  pattern = "python",
  callback = function(ev)
    local bo = vim.bo[ev.buf]
    bo.tabstop, bo.shiftwidth, bo.softtabstop, bo.expandtab = SW, SW, SW, true
    bo.autoindent, bo.smartindent, bo.cindent = true, false, false
    bo.indentexpr = "v:lua.PyIndentExpr()"
    bo.indentkeys = "0{,0},0),0],!^F,o,O,0=elif,0=else,0=except,0=finally"
  end,
})
