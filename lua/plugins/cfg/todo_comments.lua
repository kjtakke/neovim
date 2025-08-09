require("todo-comments").setup({
  signs = true,
  highlight = {
    keyword = "bg",
    after = "fg",
  },
  search = {
    command = "rg",
    args = { "--color=never","--no-heading","--with-filename","--line-number","--column" },
    pattern = [[\b(KEYWORDS):]],
  },
  keywords = {
    TODO  = { icon = " ", colour = "info" },
    FIX   = { icon = " ", colour = "error", alt = { "FIXME","BUG" } },
    WARN  = { icon = " ", colour = "warning", alt = { "WARNING" } },
    NOTE  = { icon = " ", colour = "hint", alt = { "INFO" } },
    PERF  = { icon = " ", colour = "default", alt = { "PERFORMANCE" } },
    CHORE = { icon = " ", colour = "default" },
    IDEA  = { icon = "💡", colour = "hint" },
  },
})

