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
require("lazy").setup({
  -- Your plugins here
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-tree/nvim-tree.lua" },
  { "windwp/nvim-autopairs" },
  { "numToStr/Comment.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-treesitter/nvim-treesitter" },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },
  { "neovim/nvim-lspconfig" },
})

-- Load plugin configurations
local status_ok, _ = pcall(require, "plugins")
if not status_ok then
  vim.notify("Failed to load plugins configuration")
end

-- Set up plugins
require("nvim-tree").setup()
require("nvim-autopairs").setup()
require("Comment").setup()
require("lualine").setup({
  options = { theme = "catppuccin" }
})
require("gitsigns").setup()
require("telescope").setup()
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python" },
  highlight = { enable = true },
})

-- Set up completion
local cmp = require("cmp")
local luasnip = require("luasnip")
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

-- Set up LSP
local lspconfig = require("lspconfig")
lspconfig.bashls.setup({
  filetypes = { "sh", "zsh", "bash" },
})

-- Custom commands
vim.api.nvim_create_user_command("Tree", function(opts)
  local path = vim.fn.expand(opts.args ~= "" and opts.args or ".")
  require("nvim-tree.api").tree.open({ path = path, find_file = true, focus = true })
end, {
  nargs = "?", -- Allow optional argument
  complete = "file", -- Enable file path auto-completion
})

-- Key mappings
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })

local builtin = require("telescope.builtin")
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

-- Autocmds
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.opt.clipboard = "unnamedplus"
  end
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.toggle()
  end
})

-- Options
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.wildmenu = true
vim.opt.wildmode = "longest,list"
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldminlines = 5
vim.opt.modeline = false

-- Function to create a new scratch buffer
local function new_scratch()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_var(buf, "name", "")
end

vim.keymap.set("n", "<leader>x", new_scratch, { desc = "New Scratch" })

-- Key mappings for running files and quitting
vim.keymap.set('n', '\\rp', ':w !python3 %<CR>', { noremap = true, silent = true, desc = "Run Python" })
vim.keymap.set('n', '\\rb', ':w !bash %<CR>', { noremap = true, silent = true, desc = "Run Bash" })
vim.keymap.set('n', '\\q', ':q<CR>', { noremap = true, silent = true, desc = "Quit" })
vim.keymap.set('n', '\\qq', ':q!<CR>', { noremap = true, silent = true, desc = "Force Quit" })
vim.keymap.set('n', '\\wq', ':wq<CR>', { noremap = true, silent = true, desc = "Save and Quit" })
vim.keymap.set('n', '\\w', ':w<CR>', { noremap = true, silent = true, desc = "Save" })

vim.keymap.set('n', '\\n', function()
  vim.opt.splitright = true
  vim.cmd('vsplit')
  new_scratch()
end, { noremap = true, silent = true, desc = "VSplit + New Scratch" })

-- Function to run pylint and filter output
local function run_pylint()
  vim.cmd('write')
  local filename = vim.fn.expand('%')
  local handle = io.popen('pylint "' .. filename .. '" 2>&1')
  if handle then
    local output = handle:read('*a')
    handle:close()

    local filtered_output = {}
    for line in output:gmatch('[^\r\n]+') do
      if line:match('^%S+:%d+:%d+: E') and not line:match('E0401') then
        table.insert(filtered_output, line)
      end
    end
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width * 0.6)
    local height = math.floor(ui.height * 0.6)
    local col = math.floor((ui.width - width) / 2)
    local row = math.floor((ui.height - height) / 2)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered_output)
    vim.api.nvim_open_win(bufnr, true, {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      col = col,
      row = row,
      border = "rounded"
    })
  else
    vim.notify("Failed to run pylint")
  end
end

-- Create the custom command :Wt
vim.api.nvim_create_user_command('Wt', run_pylint, {})

-- Set colorscheme
vim.cmd.colorscheme "catppuccin"
