local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- define a function to setup servers properly
local function setup_server(name, config)
  config = config or {}
  config.capabilities = capabilities

  vim.lsp.config(name, config)
  vim.lsp.enable(name)
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
