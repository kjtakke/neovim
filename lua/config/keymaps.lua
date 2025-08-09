local map = vim.keymap.set
local sr  = require("utils").safe_require

-- Scratch buffer
local function new_scratch()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
end
map("n", "<leader>x", new_scratch, { desc = "New Scratch" })

-- Quick runners
map("n", "\\rp",  ":w !python3 %<CR>", { silent = true, desc = "Run Python" })
map("n", "\\rb",  ":w !bash %<CR>",    { silent = true, desc = "Run Bash"   })

-- Save/Quit
map("n", "\\w",  ":w<CR>",  { silent = true, desc = "Save"        })
map("n", "\\q",  ":q<CR>",  { silent = true, desc = "Quit"        })
map("n", "\\qq", ":q!<CR>", { silent = true, desc = "Force Quit"  })

-- Fugitive blame
map("n", "<leader>b", ":G blame<CR>", { noremap = true, silent = true, desc = "Git Blame" })

-- Window navigation
map("n", "<C-Right>", "<C-w>l", { noremap = true, silent = true })
map("n", "<C-Left>",  "<C-w>h", { noremap = true, silent = true })
map("n", "<C-Down>",  "<C-w>j", { noremap = true, silent = true })
map("n", "<C-Up>",    "<C-w>k", { noremap = true, silent = true })

-- Copilot keys
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-b>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })

-- nvim-tree toggle (kept near plugin but mapping can live here)
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle File Tree" })

-- Telescope: basic set provided in plugins.cfg.telescope (use those)
-- Extra grep helpers are in custom.telescope_extras

-- AI UI
vim.api.nvim_set_keymap('n', '<leader>ai',
  [[<cmd>lua require'ai_ui'.set_last_buf()<CR><cmd>lua require'ai_ui'.open_ui()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_create_user_command("Models", function() require("ai_ui").show_models() end, {})
vim.api.nvim_create_user_command("ChangeModel", function(opts) require("ai_ui").change_model(opts.args) end, { nargs = 1 })

-- Add word to dictionary
map("n", "<leader>z", "zg", { desc = "Add word to dictionary" })

-- Select All --
vim.keymap.set('n', '<C-a>', 'ggVG', { noremap = true, silent = true })

-- Code statistics
map("n", "\\cs", "<cmd>CodeStats<cr>", { silent = true, desc = "Show Code Statistics" })

