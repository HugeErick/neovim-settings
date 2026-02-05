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
				require("neo-tree").setup({
					window = {
						width = 15,
					},
					filesystem = {
						use_libuv_file_watcher = true,
						bind_to_cwd = false,
						follow_current_file = {
							enabled = true,
						},
            filtered_items = {
              visible = true,
            },
					},
				})
				-- startup
				vim.api.nvim_create_autocmd("VimEnter", {
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
				vim.keymap.set("n", "<leader>F", ":Files ../<CR>", { desc = "FZF search 1 levels up" })
				vim.keymap.set("n", "<leader>f", ":Files<CR>", { desc = "FZF search current dir" })
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
				vim.g.vimtex_view_method = "zathura"
				-- use Arara as the compiler
				vim.g.vimtex_compiler_method = "latexmk"
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
					},
				})
			end,
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},

		{
			"windwp/nvim-ts-autotag",
			event = "InsertEnter",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("nvim-ts-autotag").setup({
					filetypes = {
						"html",
						"xml",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"svelte",
						"vue",
					},
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
				automatic_installation = true,
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
							if t == content then
								return content
							end
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
					if v == saved then
						current_theme_idx = i
						break
					end
				end

				-- define the toggle function
				_G.next_theme = function()
					current_theme_idx = current_theme_idx % #themes + 1
					local new_theme = themes[current_theme_idx]

					vim.cmd("colorscheme " .. new_theme)
					save_theme(new_theme) -- SAVE TO DISK

					vim.api.nvim_command("redraw")
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
						theme = "auto", 
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
				"stevearc/resession.nvim",
			},
			config = function()
        local hlgroups = require("cokeline.hlgroups")
        local hl_attr = hlgroups.get_hl_attr
        require("cokeline").setup({
          default_hl = {
            fg = function(buffer)
              return buffer.is_focused
                and hl_attr("Normal", "fg")
                or hl_attr("Comment", "fg")
            end,
            bg = hl_attr("ColorColumn", "bg"),
          },
        })
      end,
		},

		-- nvim-treesitter gigachads
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.config").setup({
          ensure_installed = {
            "lua", "typescript", "javascript",
            "html", "css", "svelte",
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
						char = "╎", -- This removes the dotted character
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
			"stevearc/conform.nvim",
			opts = {
				-- all from mason
				formatters_by_ft = {
					cpp = { "clang-format" },
					c = { "clang-format" },
					python = { "autopep8" },
					lua = { "stylua" },
				},

				formatters = {

					autopep8 = {
						args = { "--indent-size", "2", "-" },
					},
				},
				format_on_save = false,
			},
			config = function(_, opts)
				require("conform").setup(opts)
				-- This creates a keymap to format instead of using ggVG=
				vim.keymap.set("n", "<leader>mp", function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 500,
					})
				end, { desc = "Format file" })
			end,
		},

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

		{
			"toppair/peek.nvim",
			event = { "VeryLazy" },
			build = "deno task --quiet build:fast",
			config = function()
				require("peek").setup({
					app = { "firefox" },
				})
				vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
				vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
			end,
		},

		rocks = {
			enabled = false,
		},
	})

