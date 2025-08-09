local safe_require = require("utils").safe_require

-- Open nvim-tree on startup if available
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local api = safe_require("nvim-tree.api")
    if api then api.tree.open() end
  end,
})

-- Spell for loads of filetypes, Australian English
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "markdown","gitcommit","text","python","rst","tex","html","xml","json","yaml",
    "toml","mail","help","go","lua","vim","javascript","typescript","css","sh",
    "bash","zsh","c","cpp","java","rust","php","ruby","perl","dockerfile","make","sql"
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_au"
  end,
})

-- Ensure SpellBad undercurl on colourscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd("highlight SpellBad gui=undercurl guisp=Red")
  end,
})

-- Trigger once in case a scheme is already set
vim.cmd("highlight SpellBad gui=undercurl guisp=Red")

