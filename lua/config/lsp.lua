-- lsp.lua  ––  new 0.11 API version
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Helper: enable a server with the new API
local function enable(name, opts)
  opts = opts or {}
  opts.capabilities = capabilities
  vim.lsp.config[name] = opts
  vim.lsp.enable(name)
end

-- Default servers
for _, srv in ipairs {
  'lua_ls',
  'ts_ls',
  'pyright',
  'gopls',
  'clangd',
  'texlab',
  'html',
  'tailwindcss',
} do
  enable(srv)
end

-- rust-analyzer with custom settings
enable('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = { disabled = {} },
      checkOnSave  = true,
      check        = { command = 'clippy' },
      cargo        = { allFeatures = true },
      rustfmt      = { extraArgs = { '--config', 'max_width=100' } },
      lint = {
        overrideCommand = {
          'cargo', 'clippy', '--', '-A', 'clippy::non_snake_case',
        },
      },
    },
  },
})
