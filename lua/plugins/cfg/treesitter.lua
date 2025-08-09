require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "css","html","javascript","json","scss","typescript",
    "bash","c","cpp","elixir","go","java","kotlin","lua","perl","php","python","ruby","rust",
    "dockerfile","make","terraform","toml","yaml",
    "latex","markdown","markdown_inline",
    "graphql","regex","sql",
  },
  highlight = { enable = true },
})

