vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- bootstrap Lazy.nvim
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

-- load plugins
require("lazy").setup({

  -- file management
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local function focus_buffer_if_open(state)
        local node = state.tree:get_node()
        if node.type ~= "file" then
          return false
        end

        local full_path = node:get_id()
        local wins = vim.api.nvim_list_wins()

        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_name(buf) == full_path then
            vim.api.nvim_set_current_win(win)
            return true
          end
        end
        return false
      end

      require("neo-tree").setup({
        -- close_if_last_window = true,
        window = {
          width = 15,
          mappings = {
            ["<cr>"] = function(state)
              if focus_buffer_if_open(state) then
                return 
              end
              require("neo-tree.sources.filesystem.commands").open(state)
            end,

            ["t"] = function(state)
              if focus_buffer_if_open(state) then
                return
              end
              require("neo-tree.sources.filesystem.commands").open_tabnew(state)
            end,
          },
        },
        filesystem = {
          use_libuv_file_watcher = true,
          bind_to_cwd = false, 
          follow_current_file = {
            enabled = true,
          },
        },
      })

      -- startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("Neotree show")
        end,
      })

      -- show neo-tree automatically in every new tab
      vim.api.nvim_create_autocmd("TabNewEntered", {
        callback = function()
          vim.cmd("Neotree show")
        end,
      })

      -- keymap(s)
      vim.keymap.set("n", "<C-t>", ":Neotree toggle<CR>", { silent = true })
    end,
    -- end of neo-tree
  },

  -- fuzzy finder
  { "junegunn/fzf", dependencies = { "junegunn/fzf", build = "./install --all" } },
  {
    "junegunn/fzf.vim",
    config = function()

      vim.keymap.set("n", "<leader>f", ":Files ../<CR>", { desc = "FZF search 1 levels up" })

      vim.keymap.set("n", "<leader>F", ":Files<CR>", { desc = "FZF search current dir" })

      -- search through the content of open buffers
      vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { desc = "FZF find buffers" })

      -- search lines in the current buffer
      vim.keymap.set("n", "<leader>fl", ":BLines<CR>", { desc = "FZF find lines" })
    end,

  },
  -- LaTeX support
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      -- set PDF viewer to Atril
      vim.g.vimtex_view_method = 'zathura'
      -- use Arara as the compiler
      vim.g.vimtex_compiler_method = 'latexmk'

    end,
  },

  -- LSP enhancements
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        -- disabling lightbulb
        lightbulb = {
          enable = false,
        }
      })
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
    "neovim/nvim-lspconfig", 
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "williamboman/mason.nvim", -- manage external tools like language servers
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "emmet_ls" },
    },
  },

  {
    "hrsh7th/nvim-cmp", -- autocompletion plugin
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer", -- buffer source
      "hrsh7th/cmp-path", -- filesystem paths
      "saadparwaiz1/cmp_luasnip", -- snippets source
      "L3MON4D3/LuaSnip", -- snippet engine
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

  -- colorschemes with persistence
  {
    "folke/tokyonight.nvim",
    lazy = false,
    dependencies = {
      "catppuccin/nvim",
      "rose-pine/neovim",
    },
    config = function()
      local themes = { "tokyonight", "catppuccin-mocha", "rose-pine", "catppuccin-latte" }

      -- path where the theme name will be saved
      local theme_cache = vim.fn.stdpath("data") .. "/last_theme.txt"

      -- function to read the saved theme
      local function get_saved_theme()
        local f = io.open(theme_cache, "r")
        if f then
          local content = f:read("*all"):gsub("%s+", "")
          f:close()
          for _, t in ipairs(themes) do
            if t == content then return content end
          end
        end
        return "tokyonight" -- default if no file exists
      end

      -- function to save the theme
      local function save_theme(name)
        local f = io.open(theme_cache, "w")
        if f then
          f:write(name)
          f:close()
        end
      end

      -- initialize theme index based on saved theme
      local saved = get_saved_theme()
      local current_theme_idx = 1
      for i, v in ipairs(themes) do
        if v == saved then current_theme_idx = i break end
      end

      -- define the toggle function
      _G.next_theme = function()
        current_theme_idx = current_theme_idx % #themes + 1
        local new_theme = themes[current_theme_idx]

        vim.cmd("colorscheme " .. new_theme)
        save_theme(new_theme) -- SAVE TO DISK

        vim.api.nvim_command('redraw')
        print("HD Theme Switched to: " .. new_theme)
      end

      -- set the keymap
      vim.keymap.set("n", "<leader>th", _G.next_theme, { desc = "Cycle Themes" })

      -- apply the saved theme on startup
      vim.schedule(function()
        pcall(vim.cmd, "colorscheme " .. saved)
      end)
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- IMPORTANT: this makes the bar change color with the theme
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
        check_ts = true, -- use treesitter to check for pairs
      })

      -- integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = { "hrsh7th/nvim-cmp" },
  },

  -- bufferline (Cokeline)
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
      -- navigate buffers
      map("n", "<Tab>", "<Plug>(cokeline-focus-next)", opts)
      map("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", opts)
      -- move buffers
      map("n", "<leader>bn", "<Plug>(cokeline-switch-next)", opts)
      map("n", "<leader>bp", "<Plug>(cokeline-switch-prev)", opts)
      -- close buffer
      map("n", "<leader>bd", ":bd<CR>", opts)
      -- jump to buffer by index (1-9)
      for i = 1, 9 do
        map("n", string.format("<leader>%d", i), string.format("<Plug>(cokeline-focus-%d)", i), opts)
      end
    end
  },
  -- nvim-treesitter 
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

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { 
          char = "╎" -- This removes the dotted character
        },
        scope = {
          enabled = false,
        },
        whitespace = {
          remove_blankline_trail = true,
        },
      })
    end,
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      hide_target_hack = true,

    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
    },
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        app = {'firefox'}
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

})


-- close the current buffer without closing the window or messed up layout
vim.keymap.set("n", "<leader>q", function()
  -- try to get the neo-tree delete function safely
  local has_neotree, nt_utils = pcall(require, "neo-tree.utils")
  local bd = has_neotree and nt_utils.delete_buffer or nil

  if vim.bo.buftype == "terminal" then
    vim.cmd("bdelete!")
  elseif bd then
    -- if Neo-tree is loaded and has the function, use it
    bd()
  else
    -- fallback: Use standard buffer delete if Neo-tree isn't ready
    vim.cmd("bdelete")
  end
end, { desc = "Close Buffer safely" })



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
    "",
    "#define ll long long",
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
    "  printf(\"Hello world!\\\n\");",
    "",
    "  return 0;",
    "}",
  }
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
