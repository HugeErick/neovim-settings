require("lazy").setup({
  -- file manager
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("config.nvimTreeConfig")
    end,
  },
  -- emmet
  {
    "mattn/emmet-vim",
  },
  -- web devicons
  {
    "nvim-web-devicons",
  },
  -- fuzzy finder 
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.nvimTelescopeConfig")
    end,
  },
  -- LaTeX
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      require("config.vimtexConfig")
    end,
  },
  -- mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  -- mason lsp-config
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "jsonls",
          "emmet_ls", "html", "cssls",
          "svelte", "clangd", "pyright",
          "rust_analyzer", "marksman",
        },
      })
    end,
  },
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", },
    config = function()
      require("config.lspconfigConfig")
    end,
  },
  -- autocompletion
  {
    "hrsh7th/nvim-cmp", -- autocompletion plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer", -- buffer source
      "hrsh7th/cmp-path", -- filesystem paths
      "saadparwaiz1/cmp_luasnip", -- snippets source
      "L3MON4D3/LuaSnip", -- snippet engine
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require("config.cmpConfig")
    end,
  },
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require("config.treesitterConfig")
    end,
  },
  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {"hrsh7th/nvim-cmp"},
    config = function ()
      require("config.autopairsConfig")
    end,
  },
  -- markdown preview
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function ()
      require("config.peekConfig")
    end,
  },
  -- colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    dependencies = {
      "catppuccin/nvim",
      "rose-pine/neovim",
    },
    config = function ()
      require("config.tokyonightConfig")
    end,
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("config.lualineConfig")
    end,
  },
  -- blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function ()
      require("config.blanklineConfig")
    end,
  },
  -- smear cursor
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.6,
      trailing_stiffness = 0.3,
      distance_stop_animation = 0.5,
    },
  },
  -- venvs acknowledge
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true,
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
    },
  },
})
