-- Visual‑Multi tweaks & mappings
vim.g.VM_default_mappings = 0
vim.g.VM_mouse_mappings = 1
vim.g.VM_show_insert_mode = 1
vim.g.VM_set_statusline = 0

local map = vim.keymap.set

-- Add cursor above/below
map("n", "<A-Up>",   "<Plug>(VM-Add-Cursor-Up)",   {})
map("n", "<A-Down>", "<Plug>(VM-Add-Cursor-Down)", {})
map("i", "<A-Up>",   "<Esc><Plug>(VM-Add-Cursor-Up)i",   {})
map("i", "<A-Down>", "<Esc><Plug>(VM-Add-Cursor-Down)i", {})

-- Smart Ctrl+Right / Ctrl+Left
map("n", "<C-Right>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local char = line:sub(col, col)

  if char:match("%s") then
    vim.cmd("normal! w")
  elseif char:match("%w") then
    if col == 1 or not line:sub(col - 1, col - 1):match("%w") then
      vim.cmd("normal! e")
    else
      vim.cmd("normal! w")
    end
  else
    vim.cmd("normal! w")
  end
end, { noremap = true, silent = true })

map("n", "<C-Left>", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local char = line:sub(col, col)

  if char:match("%s") then
    vim.cmd("normal! b")
  elseif char:match("%w") then
    if col > 1 and not line:sub(col - 1, col - 1):match("%w") then
      vim.cmd("normal! b")
    else
      vim.cmd("normal! ge")
    end
  else
    vim.cmd("normal! b")
  end
end, { noremap = true, silent = true })

-- Shift+Ctrl selection helpers
map({ "n", "v" }, "<C-S-Right>", function()
  if vim.fn.mode() == "n" then vim.cmd("normal! v") end
  vim.cmd("normal! e")
end, { noremap = true, silent = true })

map({ "n", "v" }, "<C-S-Left>", function()
  if vim.fn.mode() == "n" then vim.cmd("normal! v") end
  vim.cmd("normal! b")
end, { noremap = true, silent = true })

map({ "n", "v" }, "<C-S-Down>", function()
  if vim.fn.mode() == "n" then vim.cmd("normal! V") end
  vim.cmd("normal! j")
end, { noremap = true, silent = true })

map({ "n", "v" }, "<C-S-Up>", function()
  if vim.fn.mode() == "n" then vim.cmd("normal! V") end
  vim.cmd("normal! k")
end, { noremap = true, silent = true })

