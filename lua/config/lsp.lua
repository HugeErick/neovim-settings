local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- define a function to setup servers properly
local function setup_server(name, config)
  config = config or {}
  config.capabilities = capabilities

  vim.lsp.config(name, config)
  if name ~= "emmet_ls" then
    vim.lsp.enable(name)
  end
end

-- simple servers
local servers = { 'lua_ls', 'ts_ls', 'pyright', 'gopls', 'html', 'tailwindcss', "svelte", "emmet_ls" }
for _, srv in ipairs(servers) do

  if srv == "emmet_ls" then
    setup_server(srv, {
      filetypes = {
        "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte"
      },
    })
  else 
    setup_server(srv)
  end
end

setup_server('clangd', {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--fallback-style=Microsoft" }
})

-- emmet logic

local emmet_active = false

vim.keymap.set('n', '<leader>k', function()
  if emmet_active then
    vim.lsp.stop_client(vim.lsp.get_clients({ name = "emmet_ls" }))
    print("Emmet Stopped")
    emmet_active = false
  else
    vim.lsp.enable("emmet_ls")
    print("Emmet Started")
    emmet_active = true
  end
end, { desc = "Toggle Emmet LSP" })

-- fixing Rust-Analyzer (Cargo dependencies)
setup_server('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { 
        allFeatures = true, 
        loadOutDirsFromCheck = true 
      },
      procMacro = { enable = true },
      checkOnSave = true,
      check = {
        command = "clippy",
        extraArgs = { "--", "-A", "clippy::upper_case_acronyms" },
      },
    },
  },
})
