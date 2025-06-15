local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Example setup for a few languages
local servers = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "gopls",
  "rust_analyzer",
  "clangd",
  "texlab",
  "html",
  "tailwindcss",
}

for _, lsp in ipairs(servers) do
  if lsp == "rust_analyzer" then
    -- Special configuration for rust-analyzer
    lspconfig[lsp].setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            disabled = {}, -- Disable specific diagnostics if needed
          },
          checkOnSave = true, -- Enable check on save
          check = {
            command = "clippy", -- Use clippy for additional checks
          },
          cargo = {
            allFeatures = true, -- Enable all features for workspace-wide checks
          },
          rustfmt = {
            extraArgs = { "--config", "max_width=100" }, -- Example of rustfmt config
          },
          lint = {
            overrideCommand = {
              "cargo", "clippy", "--", "-A", "clippy::non_snake_case"
            },
          },
        },
      },
    })
  else
    -- Default configuration for other language servers
    lspconfig[lsp].setup({
      capabilities = capabilities,
    })
  end
end
