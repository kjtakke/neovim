-- BOOTSTRAP Lazy.nvim
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


-- Load plugins
require("plugins")
require("lsp")
require("nvim-tree").setup()
-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.


vim.cmd.colorscheme "catppuccin"

require("nvim-autopairs").setup()
require("Comment").setup()
require("nvim-tree").setup()
require("lualine").setup {
  options = { theme = "catppuccin" }
}
require("gitsigns").setup()
require("telescope").setup()

require("nvim-treesitter.configs").setup {
  ensure_installed = { "python" },
  highlight = { enable = true },
}

local cmp = require("cmp")
local luasnip = require("luasnip")

local lspconfig = require("lspconfig")

lspconfig.bashls.setup({
  filetypes = { "sh", "zsh", "bash" },
})

vim.api.nvim_create_user_command("Tree", function(opts)
  local path = vim.fn.expand(opts.args ~= "" and opts.args or ".")
  require("nvim-tree.api").tree.open({ path = path, find_file = true, focus = true })
end, {
  nargs = "?", -- Allow optional argument
  complete = "file", -- Enable file path auto-completion
})



cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  })
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })

local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>x", ":e scratch<CR>", { desc = "[X] New Scratch File" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>fg", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.opt.clipboard = "unnamedplus"
  end
})


vim.opt.number = true
-- vim.opt.rnu = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make file name completion work just like bash
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list"

-- vim.opt.wrapscan = false

vim.o.foldmethod = "indent"
vim.o.foldenable = true

vim.o.foldlevel = 99
vim.o.foldminlines = 5

# vim.o.mo = false
vim.opt.modline = false

local function new_scratch()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_set_current_buf(buf)

    vim.api.nvim_buf_set_var(buf, "name", "")
end

vim.keymap.set("n", "<leader>x", new_scratch, { desc = "New Scratch" })


-- Auto-open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.toggle()
  end
})

-- Run current file with Python
vim.keymap.set('n', '\\rp', ':w !python3 %<CR>', { noremap = true, silent = true })

-- Run current file with Bash
vim.keymap.set('n', '\\rb', ':w !bash %<CR>', { noremap = true, silent = true })

-- Run Quit
vim.keymap.set('n', '\\q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '\\qq', ':q!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '\\wq', ':wq<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '\\w', ':w<CR>', { noremap = true, silent = true })


vim.keymap.set('n', '\\n', function()
  vim.opt.splitright = true      -- ensures vsplit goes to the right
  vim.cmd('vsplit')
  new_scratch()
end, { noremap = true, silent = true, desc = "VSplit + New Scratch" })
require("lazy").setup("plugins")

-- AI UI
vim.api.nvim_set_keymap('n', '<leader>ai', [[<cmd>lua require'ai_ui'.set_last_buf()<CR><cmd>lua require'ai_ui'.open_ui()<CR>]], { noremap = true, silent = true })

