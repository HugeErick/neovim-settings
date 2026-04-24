require("nvim-treesitter").setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "lua", "rust", "vim", "vimdoc", "html", "javascript", "typescript", "tsx", "python", "svelte", "bash", "css", "markdown", "markdown_inline", "php", "json", "fish", "go" },

  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})

