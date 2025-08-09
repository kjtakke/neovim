require("nvim-tree").setup({
  view = {
    width = 50,
    side = "left",
    preserve_window_proportions = true,
  },
  filters = {
    custom = { ".git" },
    exclude = {},
  },
  respect_buf_cwd = false,
})

