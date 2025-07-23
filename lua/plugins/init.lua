-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  -- File management
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          width = 12,
        },
      })
      vim.keymap.set("n", "<C-t>", ":Neotree toggle<CR>", { silent = true })
    end,
  },
  -- Fuzzy Finder
  { "junegunn/fzf", dependencies = { "junegunn/fzf", build = "./install --all" } },
  { "junegunn/fzf.vim" },
  -- LaTeX Support
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      -- Set PDF viewer to Atril
      -- vim.g.vimtex_view_method = 'atril'

      -- Use Arara as the compiler
      vim.g.vimtex_compiler_method = 'arara'

      -- Ensure compilation keybinding is ',ll'
      vim.g.maplocalleader = ','
    end,
  },
  -- LSP Enhancements
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    }
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue" },
      })
    end,
  },


  -- LSP config and autocompletion
  {
    "neovim/nvim-lspconfig", -- Quick LSP setup
  },
  {
    "williamboman/mason.nvim", -- Manage external tools like language servers
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer", -- Buffer source
      "hrsh7th/cmp-path", -- Filesystem paths
      "saadparwaiz1/cmp_luasnip", -- Snippets source
      "L3MON4D3/LuaSnip", -- Snippet engine
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
            { name = "buffer" },
            { name = "path" },
          }),
      })
    end,
  },

  -- Colorscheme (Replaced kanagawa with tokyonight)
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight", -- Updated to match the colorscheme
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- Use treesitter to check for pairs
      })

      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  -- Bufferline (Cokeline)
  {
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "stevearc/resession.nvim"
    },
    config = function()
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      -- Navigate buffers
      map("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
      map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
      -- Move buffers
      map("n", "<leader>bn", "<Plug>(cokeline-switch-next)", opts)
      map("n", "<leader>bp", "<Plug>(cokeline-switch-prev)", opts)
      -- Close buffer
      map("n", "<leader>bd", ":bd<CR>", opts)
      -- Jump to buffer by index (1-9)
      for i = 1, 9 do
        map("n", string.format("<leader>%d", i), string.format("<Plug>(cokeline-focus-%d)", i), opts)
      end
    end
  },
  -- nvim-treesitter (Added for syntax highlighting and more)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", -- Lua and Vim
          "javascript", "typescript", "tsx", -- JavaScript/TypeScript
          "html", "css", "scss", -- Web development
          "json", "yaml", "toml", -- Config files
          "python", "bash",  -- Scripting
          "markdown", "markdown_inline", -- Markdown
          "rust", "go", "c", "cpp", -- Systems programming
          "java", "kotlin", -- JVM languages
          "ruby", "php", -- Web backend
          "sql", -- Databases
          "dockerfile", -- Docker
          "gitignore", -- Git
          "svelte", "vue", -- Frontend frameworks
          "regex", "query", -- Tree-sitter utilities
        },
        highlight = {
          enable = true, -- Enable syntax highlighting
        },
        indent = {
          enable = true, -- Enable smart indentation
        },
      })
    end,
  },
})


