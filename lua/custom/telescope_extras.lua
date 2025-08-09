-- :Todo command via Telescope, and two handy Go symbol greps
vim.api.nvim_create_user_command("Todo", function()
  require("telescope.builtin").live_grep({ default_text = "TODO" })
end, {})

vim.keymap.set("n", "<leader>gf", function()
  local word = vim.fn.expand("<cword>")
  if word and word ~= "" then
    local query = "^(func|var|type|const) " .. word
    require("telescope.builtin").live_grep({ default_text = query })
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gd", function()
  local word = vim.fn.expand("<cword>")
  if word and word ~= "" then
    local query = word .. "\\("
    require("telescope.builtin").live_grep({ default_text = query })
  end
end, { noremap = true, silent = true })

