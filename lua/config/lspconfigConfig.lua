local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', {
  capabilities = capabilities,
})


vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  }
})

-- rust 
vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true, loadOutDirsFromCheck = true },
      procMacro = { enable = true },
      checkOnSave = true,
      check = {
        command = "clippy",
        extraArgs = { "--", "-A", "clippy::upper_case_acronyms" },
      },
      diagnostics = { disabled = { "E0308" } },
    },
  },
})


-- css
vim.lsp.config('cssls', {
  capabilities = capabilities,
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

-- svelte 
local svelte_capabilities = vim.tbl_deep_extend("force", {}, capabilities)
svelte_capabilities.workspace = { didChangeWatchedFiles = false }  -- CRITICAL FIX
vim.lsp.config('svelte', {
  capabilities = svelte_capabilities,
  filetypes = { "svelte" },
  settings = {
    svelte = {
      plugin = {
        svelte = {
          defaultScriptLanguage = "ts",
        },
      },
    },
  },
})

-- emmet ls 
vim.lsp.config('emmet_ls', {
  capabilities = capabilities,
  filetypes = {
    "html",
    "css",
    "svelte",
    "scss",
    "less",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    emmet = {
      preferences = {
        -- Your custom preferences (converted from init_options)
        ["bem.enabled"] = true,
        ["output.inlineBreak"] = 1,
      },
    },
  },
})

-- enable the servers
-- It auto-starts the server when you open a matching filetype.
vim.lsp.enable({ 
  "lua_ls",       -- lua
  "ts_ls",        -- typescript, javascript, tsx
  "eslint-lsp",
  "tailwindcss",  -- html/css/react
  "rust_analyzer",-- rust
  "clangd",       -- c, cpp
  "pyright",      -- python
  "svelte",       -- svelte
  "bashls",       -- bash
  "cssls",        -- css
  "marksman",     -- markdown
})

-- LSP keybindings & autocmds
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
